import 'package:just_audio/just_audio.dart';

class AudioLoad{
  final String audioFile;

  AudioLoad({required this.audioFile});

  late AudioPlayer controller;

  void playSound(){
    controller = AudioPlayer()..setAsset(audioFile);
    controller.setVolume(1);
    controller.play();
  }

  void stopSound(){
    controller = AudioPlayer()..setAsset(audioFile);
    controller.stop();
  }

  void disposeSound(){
    controller = AudioPlayer()..setAsset(audioFile);
    controller.dispose();
  }
}