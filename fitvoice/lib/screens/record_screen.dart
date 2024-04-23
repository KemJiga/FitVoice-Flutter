import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  final player = AudioPlayer();

  Future<void> playSound() async {
    String sourcePath = 'sounds/record.mp3';
    await player.play(AssetSource(sourcePath));
  }

  Future<void> stopSound() async {
    await player.stop();
  }

  Future<void> pauseSound() async {
    await player.pause();
  }

  Future<void> resumeSound() async {
    await player.resume();
  }

  Future<void> seekSound(int duration) async {
    await player.seek(Duration(milliseconds: duration));
  }

  @override
  Future<void> dispose() async {
    await player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              playSound();
            },
            child: const Text('Play Sound'),
          ),
          ElevatedButton(
            onPressed: () {
              pauseSound();
            },
            child: const Text('Pause Sound'),
          ),
          ElevatedButton(
            onPressed: () {
              resumeSound();
            },
            child: const Text('Resume Sound'),
          ),
          ElevatedButton(
            onPressed: () {
              stopSound();
            },
            child: const Text('Stop Sound'),
          ),
        ],
      ),
    );
  }
}
