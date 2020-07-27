// /// video_player  flutter 视频播放插件
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlay extends StatefulWidget {
//   @override
//   _VideoPlayState createState() => _VideoPlayState();
// }

// class _VideoPlayState extends State<VideoPlay> {
//   VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network('http://192.168.0.11:8000/live/itying.flv')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(_controller.value.aspectRatio);
//     return Scaffold(
//       appBar: AppBar(title: Text('video')),
//       body: Center(
//         child: _controller.value.initialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying ? _controller.pause() : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
