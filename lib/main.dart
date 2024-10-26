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
      home: AnimeDownloader(),
    );
  }
}

class AnimeDownloader extends StatefulWidget {
  @override
  _AnimeDownloaderState createState() => _AnimeDownloaderState();
}

class _AnimeDownloaderState extends State<AnimeDownloader> {
  final TextEditingController _titleController = TextEditingController();
  String _message = '';

  Future<void> downloadAnime() async {
    final url = Uri.parse('http://localhost:5000/download');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'quality': '720p',
        'start_episode': 1,
        'end_episode': 1,
        'sub_or_dub': 'sub',
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _message = 'Download started!';
      });
    } else {
      setState(() {
        _message = 'Failed to start download: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Anime Downloader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Anime Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: downloadAnime,
              child: Text('Download'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
