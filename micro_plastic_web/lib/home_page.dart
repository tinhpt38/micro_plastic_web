import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  bool _isPause = true;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://dl.dropboxusercontent.com/s/owlbvzuogs9fnar/18th12.mp4?dl=0")
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  seekTo() {
    _controller.pause();
    _controller.seekTo(Duration(milliseconds: 0));
    setState(() => _isPause = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: Colors.black,
        width: double.infinity,
        alignment: Alignment.center,
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: (16 / 9),
                child: GestureDetector(
                  onLongPressStart: (_) {
                    _controller.play();
                    setState(() {
                      _isPause = false;
                    });
                  },
                  onLongPressEnd: (_) {
                    seekTo();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      Visibility(
                        visible: _isPause,
                        child: Container(
                          child: Container(
                            color: Color(0xff035099),
                            width: double.infinity,
                            child: Image.asset("assets/ant.gif"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Đang tải video, vui lòng chờ",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
