import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Quran Surah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SurahList(),
    );
  }
}

class SurahList extends StatefulWidget {
  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  Future<List<dynamic>> fetchSurah() async {
    final response = await http.get(Uri.parse('https://quran-api.santrikoding.com/api/surah'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load surah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Surah'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSurah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            final surahList = snapshot.data!;
            return ListView.builder(
              itemCount: surahList.length,
              itemBuilder: (context, index) {
                final surah = surahList[index];
                return ListTile(
                  title: Text(surah['nama_latin']),
                  subtitle: Text('Jumlah Ayat: ${surah['jumlah_ayat']}'),
                  trailing: Text(surah['nama']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
