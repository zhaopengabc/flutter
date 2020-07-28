import 'package:flutter/material.dart';
import 'package:flutter_ijk/flutter_ijk.dart';

class VideoPage extends StatefulWidget {
  VideoPage();

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> {
  IjkPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        IjkPlayerController.network("rtsp://192.168.10.95:8554/h264ESVideoTest")
          // _controller = IjkPlayerController.asset("video/big_buck_bunny.mp4")
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _controller == null
          ? Container()
          : Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: IjkPlayer(_controller),
                    )
                  : Container(),
            ),
    );
  }

  void _stop() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stop();
  }
}