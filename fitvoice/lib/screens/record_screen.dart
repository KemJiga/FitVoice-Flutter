import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  final AudioPlayer player = AudioPlayer();
  final Record _record = Record();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Timer? _timer;
  int _time = 0;
  bool _isRecording = false;
  String? _audioPath;

  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  @override
  initState() {
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        _audioDuration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        _audioPosition = newPosition;
      });
    });
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _time++;
      });
    });
  }

  Future<void> _startRecording() async {
    try {
      if (await _record.hasPermission()) {
        Directory? dir;

        if (Platform.isIOS) {
          dir = await getApplicationCacheDirectory();
        } else {
          dir = Directory('/storage/emulated/0/Download');
          if (!await dir.exists()) {
            dir = await getExternalStorageDirectory();
          }
        }

        await _record.start();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    final path = await _record.stop();
    _audioPath = path;
    if (_audioPath?.isNotEmpty ?? false) {
      log(path!);
    }
  }

  Future<void> playSound() async {
    //String sourcePath = 'sounds/record.mp3';
    String sourcePath = _audioPath!;
    try {
      //await player.play(AssetSource(sourcePath));
      await player.play(DeviceFileSource(sourcePath)).then(
            (value) => log('Playing sound from $sourcePath'),
          );
    } on Exception catch (e) {
      log('Error: $e');
    }
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
    await player.seek(Duration(seconds: duration));
    await player.resume();
  }

  String formatTime(int time) {
    return '${(Duration(seconds: time))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _timer?.cancel();
    _record.dispose();
    await player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Graba lo que comiste hoy!'),
          const SizedBox(height: 40),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 55, 203, 85),
            ),
            child: IconButton(
              iconSize: 100,
              onPressed: () {
                if (!_isRecording) {
                  _startRecording();
                  _startTimer();
                  setState(() {
                    _isRecording = true;
                  });
                } else {
                  _stopRecording();
                  _timer?.cancel();
                  setState(() {
                    _isRecording = false;
                    _time = 0;
                  });
                }
              },
              icon: Icon(_isRecording ? Icons.stop : Icons.mic_none_outlined),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      playSound();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () {
                      pauseSound();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay_outlined),
                    onPressed: () {
                      stopSound();
                      setState(() {
                        _audioPosition = Duration.zero;
                      });
                    },
                  ),
                ],
              ),
              Slider(
                min: 0,
                max: _audioDuration.inSeconds.toDouble(),
                value: _audioPosition.inSeconds.toDouble(),
                onChanged: (value) {
                  seekSound(value.toInt());
                },
                activeColor: const Color.fromARGB(255, 55, 203, 85),
              ),
              Text(
                  '${formatTime((_audioDuration - _audioPosition).inSeconds)}s'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  //TODO: Enviar audio al servidor
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Audio enviado a s2n ✅'),
                    ),
                  );
                  Timer(const Duration(seconds: 2), () {
                    //Navigator.pop(context);
                  });
                },
                child: const Text('Enviar grabación'),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
