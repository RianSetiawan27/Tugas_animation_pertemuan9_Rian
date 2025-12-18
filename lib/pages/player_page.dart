import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/song.dart';
import '../services/audio_service.dart';
import '../data/dummy_songs.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioService _audio = AudioService();

  late List<Song> _songs;
  late int _currentIndex;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  Color _bgColor = const Color(0xFF1A237E); 

  Song get _currentSong => _songs[_currentIndex];

  @override
  void initState() {
    super.initState();

    _audio.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });

    _audio.durationStream.listen((dur) {
      if (dur != null && mounted) setState(() => _duration = dur);
    });

    _audio.playingStream.listen((playing) {
      if (mounted) setState(() => _isPlaying = playing);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    _songs = dummySongs;
    _currentIndex = 0;

    if (args is Map<String, dynamic>) {
      if (args['songs'] is List<Song>) {
        _songs = List<Song>.from(args['songs']);
      }
      if (args['index'] is int) {
        _currentIndex = args['index'];
      }
    }

    _loadSong();
  }

  Future<void> _loadSong() async {
    _audio.load(_currentSong.audioPath);
    _audio.play();
    await _updateBackgroundColor();
  }

  
  Future<void> _updateBackgroundColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      AssetImage(_currentSong.coverPath),
    );

    if (!mounted) return;

    setState(() {
      _bgColor = palette.dominantColor?.color ?? _bgColor;
    });
  }

  void _nextSong() {
    if (_currentIndex < _songs.length - 1) {
      setState(() => _currentIndex++);
      _loadSong();
    }
  }

  void _prevSong() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _loadSong();
    } else {
      _audio.seek(Duration.zero);
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _bgColor.withOpacity(0.45),
              _bgColor.withOpacity(0.20),
              const Color(0xFF0E0B1F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔙 BACK
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 10),

              
              ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  _currentSong.coverPath,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _currentSong.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black54,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentSong.artist,
                      style: const TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds
                    .clamp(0, _duration.inSeconds)
                    .toDouble(),
                onChanged: (v) =>
                    _audio.seek(Duration(seconds: v.toInt())),
                activeColor: const Color.fromARGB(255, 0, 0, 0),
                inactiveColor: const Color.fromARGB(60, 255, 255, 255),
              ),

              Text(
                '${_format(_position)} / ${_format(_duration)}',
                style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
              ),

              const SizedBox(height: 24),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: const Icon(Icons.skip_previous,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: _prevSong,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    iconSize: 72,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      _isPlaying ? _audio.pause() : _audio.play();
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    iconSize: 42,
                    icon:
                        const Icon(Icons.skip_next, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: _nextSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString();
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
