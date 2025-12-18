import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<PlayerState> get state => _player.playerStateStream;

  Future<void> load(String assetPath) async {
    await _player.setAsset(assetPath);
  }

  void play() => _player.play();
  void pause() => _player.pause();

  void seek(Duration position) {
    _player.seek(position);
  }

  void dispose() {
    _player.dispose();
  }
}
