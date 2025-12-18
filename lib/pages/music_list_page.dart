import 'package:flutter/material.dart';
import '../data/dummy_songs.dart';
import '../widgets/music_card.dart';

class MusicListPage extends StatelessWidget {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        title: const Text(
          'My Music',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dummySongs.length,
        itemBuilder: (context, i) {
          return MusicCard(song: dummySongs[i], index: i, songs: dummySongs);
        },
      ),
    );
  }
}
