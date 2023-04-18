import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';
import 'package:video_player/video_player.dart';

class ServiceScreenVideoFinal extends StatefulWidget {
  final String videoName;

  const ServiceScreenVideoFinal({Key? key, required this.videoName})
      : super(
          key: key,
        );

  @override
  State<ServiceScreenVideoFinal> createState() =>
      _ServiceScreenVideoFinalState();
}

class _ServiceScreenVideoFinalState extends State<ServiceScreenVideoFinal>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;

  // final String _shipping = "assets/videos/menu_delivery_shipping.mp4";
  // final String _serving = "assets/videos/menu_delivery_serving.mp4";
  // final String _hotel = "assets/videos/menu_delivery_hotel.mp4";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => playVideo());
    // playVideo();
  }

  void playVideo() {
    _controller = VideoPlayerController.asset(widget.videoName,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        _controller.setLooping(true);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });
    _controller.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(
        _controller,
      ),
    );
  }
}
