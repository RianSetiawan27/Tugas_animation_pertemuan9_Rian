import 'package:flutter/material.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Song> _songs = [
    Song(
      title: 'Dj Jkt Hari Ini',
      artist: 'Santri Fvkty',
      coverPath: 'assets/images/cover1.jpg',
      audioPath: 'assets/audio/song1.mp3',
      duration: Duration(minutes: 3, seconds: 30),
    ),
    Song(
      title: 'Ay',
      artist: 'Bagindas',
      coverPath: 'assets/images/cover2.jpg',
      audioPath: 'assets/audio/song2.mp3',
      duration: Duration(minutes: 4, seconds: 5),
    ),
    Song(
      title: 'Anadonk',
      artist: 'Taramood',
      coverPath: 'assets/images/cover3.jpg',
      audioPath: 'assets/audio/song3.mp3',
      duration: Duration(minutes: 3, seconds: 15),
    ),
    Song(
      title: 'Dj Tor Monitor Ketua',
      artist: 'Mmnfndy',
      coverPath: 'assets/images/cover4.jpg',
      audioPath: 'assets/audio/song4.mp3',
      duration: Duration(minutes: 2, seconds: 50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              _searchBar(),
              const SizedBox(height: 30),
              _sectionTitle('Popular Songs'),
              const SizedBox(height: 16),
              _popularSongs(), 
              const SizedBox(height: 30),
              _sectionTitle('Top Albums'),
              const SizedBox(height: 16),
              _albumGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello Kaka Rian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Mau dengar musik apa hari ini?',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/images/logo.png'),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/music'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.white54),
            SizedBox(width: 10),
            Text(
              'Search songs, artists...',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _popularSongs() {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _songs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final song = _songs[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/player',
                arguments: {'songs': _songs, 'index': index},
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: song.coverPath,
                  child: Container(
                    width: 160,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage(song.coverPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 160,
                  child: Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Text(
                    song.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _albumGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _songs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final song = _songs[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/player',
              arguments: {'songs': _songs, 'index': index},
            );
          },
          child: Hero(
            tag: song.coverPath,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(song.coverPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: const Color(0xFF0E0B1F),
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.white54,
      onTap: (index) {
        if (index == 1) {
          setState(() => _currentIndex = index);
          Navigator.pushNamed(context, '/music').then((_) {
            if (mounted) setState(() => _currentIndex = 0);
          });
        } else {
          setState(() => _currentIndex = index);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'My Music',
        ),
      ],
    );
  }
}
