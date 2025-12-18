import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class PlayControls extends StatelessWidget {
  final AudioService audio;

  const PlayControls({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audio.state,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        return IconButton(
          iconSize: 70,
          color: Colors.white,
          icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
          onPressed: () {
            playing ? audio.pause() : audio.play();
          },
        );
      },
    );
  }
}
