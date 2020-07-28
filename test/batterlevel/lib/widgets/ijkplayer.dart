// /// https://pub.dev/packages/flutter_ijkplayer#-readme-tab-
// ///
// import 'package:flutter/material.dart';
// import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

// class IjkWidget extends StatefulWidget {
//   @override
//   _IjkWidgetState createState() => _IjkWidgetState();
// }

// class _IjkWidgetState extends State<IjkWidget> {
//   IjkMediaController controller = IjkMediaController();
//   var provider;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('provider: $provider');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Plugin example app'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.videocam),
//             onPressed: () => {print('被电击了')},
//           ),
//         ],
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 400.0,
//         child: ListView(children: <Widget>[
//           buildIjkPlayer(),
//           Image(
//             image: provider != null ? provider : AssetImage('assets/images/common/logo.png'),
//             height: 400.0,
//           )
//         ]),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.play_arrow),
//         onPressed: () async {
//           await controller.setNetworkDataSource(
//               //'http://192.168.0.11:8000/live/itying.flv',
//               'rtmp://202.69.69.180:443/webcast/bshdlive-pc',
//               // 'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov',
//               //'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
//               // 'rtmp://172.16.100.245/live1',
//               // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
//               // "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
//               // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
//               // "file:///benmo/Download/ceshi.mp4",
//               autoPlay: true);
//           print("set data source success");
//           //controller.playOrPause();

//           var uint8List = await controller.screenShot();
//           provider = MemoryImage(uint8List);
//           print('provider: $provider');
//           // image = Image(image: provider);
//         },
//       ),
//     );
//   }

//   Widget buildIjkPlayer() {
//     return Container(
//       height: 400.0,
//       child: IjkPlayer(
//         mediaController: controller,
//       ),
//     );
//   }
// }
