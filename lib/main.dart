import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MusicPlayer());
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  final player = AudioPlayer();

  bool isPlaying = false;
  double value = 0;

  Duration? duration = Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(AssetSource("Gio-JanK.mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Music App'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/2emotions_copy__62507.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 29),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/2emotions_copy__62507.jpg",
                  width: 250.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Gió - JanK",
                style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.white,
                  letterSpacing: 6.0,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()} : ${(value % 60).floor()}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    },
                    min: 0.0,
                    max: duration!.inSeconds.toDouble(),
                    value: value,
                    onChangeEnd: (newValue) async {
                      setState(() {
                        value = newValue;
                        print(newValue);
                      });
                      player.pause();
                      await player.seek(Duration(seconds: newValue.toInt()));
                      await player.resume();
                    },
                    activeColor: Colors.white,
                  ),
                  Text(
                    "${duration!.inMinutes} : ${duration!.inSeconds % 60}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Colors.black87,
                  border: Border.all(color: Colors.pink),
                ),
                child: InkWell(
                  onTap: () async {
                    if (isPlaying) {
                      await player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });
                      player.onPositionChanged.listen(
                        (event) {
                          setState(() {
                            value = event.inSeconds.toDouble();
                          });
                        },
                      );
                    }
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
