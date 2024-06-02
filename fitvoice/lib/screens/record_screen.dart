// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'package:fitvoice/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key, required this.authToken});

  final String? authToken;
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
  bool _recorded = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  @override
  initState() {
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    player.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _audioDuration = newDuration;
        });
      }
    });

    player.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _audioPosition = newPosition;
        });
      }
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
    //_audioPath = '${path!.substring(0, path.length - 4)}.mp3';
    //final mp3Path = await convertToMp3(path);
    _audioPath = path;
    //await File(path).rename(_audioPath!);
    if (_audioPath?.isNotEmpty ?? false) {
      print(path);
    }
    if (mounted) {
      setState(() {
        _isRecording = false;
        _recorded = true;
        _time = 0;
      });
    }
  }

  Future<void> playSound() async {
    //String sourcePath = 'sounds/record.mp3';
    String sourcePath = _audioPath!;
    print(sourcePath);
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

  final baseUrl = Config.url;
  bool sent = false;
  Future<bool> uploadAudio() async {
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/report/upload');

    var request = http.MultipartRequest('POST', URL);
    request.files.add(await http.MultipartFile.fromPath('file', _audioPath!,
        contentType: MediaType('audio', 'm4a')));
    request.headers.addAll({"Authorization": 'Bearer ${widget.authToken}'});

    var res = await request.send();

    if (res.statusCode == 201) {
      var resData = await res.stream.bytesToString();
      var jsonResponse = jsonDecode(resData);
      print(jsonResponse['message']);
      print(jsonResponse['body']);

      sent = true;
      setState(() {
        _recorded = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Audio enviado a s2n ✅'),
        ),
      );
      Timer(const Duration(seconds: 2), () {});

      return true;
    } else if (res.statusCode == 422) {
      sent = true;
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Error al enviar audio ❌ : ${res.statusCode}'),
        ),
      );
      Timer(const Duration(seconds: 2), () {
        //Navigator.pop(context);
      });
      sent = false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('¡Graba lo que comiste hoy!',
              style: Estilos.textStyle1(20, Estilos.color5, 'bold')),
          const SizedBox(height: 20),
          Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: MyCirclePainter(),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 75,
                  onPressed: () {
                    if (!_isRecording) {
                      _startRecording();
                      _startTimer();
                      setState(() {
                        _audioPosition = Duration.zero;
                        _isRecording = true;
                        _recorded = false;
                      });
                    } else {
                      _stopRecording();
                      _timer?.cancel();
                      setState(() {
                        _isRecording = false;
                        _recorded = true;
                        _time = 0;
                      });
                    }
                  },
                  icon:
                      Icon(_isRecording ? Icons.stop : Icons.mic_none_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_recorded)
            Column(
              children: [
                Text('¡Escucha tu grabación! ⬇️',
                    style: Estilos.textStyle1(20, Estilos.color5, 'bold')),
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
                  activeColor: Estilos.color1,
                ),
                Text(
                    '${formatTime((_audioDuration - _audioPosition).inSeconds)}s',
                    style: Estilos.textStyle1(16, Colors.black, 'bold')),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: uploadAudio,
                  child: Text(
                    'Enviar grabación',
                    style: Estilos.textStyle1(16, Estilos.color1, 'normal'),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class MyCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = (size.width - 12) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paintBase = Paint()
      ..color = Estilos.color1
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Paint paintArc1 = Paint()
      ..color = Estilos.color4
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Paint paintArc2 = Paint()
      ..color = Estilos.color2
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paintBase);

    double arcStartAngle = -math.pi / 2; // Start angle for the first arc
    double arcSweepAngle = 2 * math.pi / 3; // Sweep angle for each arc

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      arcStartAngle,
      arcSweepAngle,
      false,
      paintArc1,
    );
    arcStartAngle += (arcSweepAngle);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      arcStartAngle,
      arcSweepAngle,
      false,
      paintArc2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
