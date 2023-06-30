import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ADScreen extends StatefulWidget {
  const ADScreen({Key? key}) : super(key: key);

  @override
  State<ADScreen> createState() => _ADScreenState();
}

class _ADScreenState extends State<ADScreen>
    with TickerProviderStateMixin {
  // 블루투스 연결
  late VideoPlayerController _controller;


  FirebaseFirestore robotDb = FirebaseFirestore.instance;

  final String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  @override
  void initState() {
    super.initState();
    // // 웹 플레이어
    // _controller = VideoPlayerController.networkUrl(
    //   Uri.parse(
    //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    //   // closedCaptionFile: _loadCaptions(),
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // );
    //
    // _controller.addListener(() {
    //   setState(() {});
    // });
    // _controller.setLooping(true);
    // _controller.initialize();

    // 어셋 플레이어
    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(false);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    if(Provider.of<ServingModel>(context, listen: false).servingState == 2){
      const int newState = 0;
      final data = {"serviceState": newState};
      robotDb
          .collection("servingBot1")
          .doc("robotState")
          .set(data, SetOptions(merge: true));
    }
    _playVideo();
  }

  void _playVideo() async {
    await Future.delayed(const Duration(seconds: 1));
    _controller.play();
  }

  void getStarted_readData() async {
    // [START get_started_read_data]
    await robotDb.collection("servingBot1").get().then((event) {
      for (var doc in event.docs) {
        if(doc.id == "robotState"){
          print(doc.data()['serviceState']);
          setState(() {
            Provider.of<ServingModel>(context, listen: false).servingState = doc.data()['serviceState'];
          });
          if(doc.data()['serviceState']==3){
            const int newState = 0;
            final data = {"serviceState": newState};
            robotDb
                .collection("servingBot1")
                .doc("robotState")
                .set(data, SetOptions(merge: true));
            Navigator.pop(context);
          }
        }
      }
    });
    // [END get_started_read_data]
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var deviceId1 = "";

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

    WidgetsBinding.instance.addPostFrameCallback((_){getStarted_readData();});

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
            const int newState = 3;
            final data = {"serviceState": newState};
            robotDb
                .collection("servingBot1")
                .doc("robotState")
                .set(data, SetOptions(merge: true));
          });
        },
        child: Center(
          child: Scaffold(
            body: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.8,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: videoWidth,
                            height: videoHeight,
                            child: _controller.value.isInitialized
                                ? AspectRatio(
                              aspectRatio:
                              _controller.value.aspectRatio,
                              child: VideoPlayer(
                                _controller,
                              ),
                            )
                                : Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
