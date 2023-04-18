import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/RoomServiceModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class RoomServiceReturnModuleFinal extends StatefulWidget {
  RoomServiceReturnModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomServiceReturnModuleFinal> createState() =>
      _RoomServiceReturnModuleFinalState();
}

class _RoomServiceReturnModuleFinalState
    extends State<RoomServiceReturnModuleFinal> {
  late NetworkModel _networkProvider;
  late RoomServiceModel _roomServiceProvider;
  late ServingModel _servingProvider;

  late VideoPlayerController _controller;

  String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  bool? offStageAd;

  int? shipping;
  int? serving;
  int? bellboy;
  int? roomService;

  String? currentGoal;

  bool? pauseCheck;

  int? serviceState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pauseCheck = false;

    shipping = 0;
    serving = 1;
    bellboy = 2;
    roomService = 3;

    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(true);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    _playVideo();
  }

  void _playVideo() async {
    _controller.play();
  }

  late String backgroundImageServ;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _roomServiceProvider = Provider.of<RoomServiceModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    backgroundImageServ = "assets/screens/Nav/koriZFinalRoomReturnNav.png";


    offStageAd = _servingProvider.playAd;

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;
    currentGoal = _networkProvider.currentGoal;

    serviceState = _networkProvider.serviceState;

    print(serviceState);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          // leading:
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  Center(
                    child: Text(
                      "시간",
                      style: TextStyle(fontFamily: 'kor', fontSize: 60),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          navPage(
                              context: context,
                              page: HotelServiceMenu(),
                              enablePop: false)
                              .navPageToPage();
                        },
                        child: Text(
                          '도착',
                          style: TextStyle(
                              fontFamily: 'kok',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff)),
                        ),
                        style: TextButton.styleFrom(
                          fixedSize: Size(100, 0),
                          backgroundColor: Colors.transparent,
                          // shape: RoundedRectangleBorder(
                          //     side: BorderSide(width: 1, color: Colors.white)
                          // )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // SizedBox(width: screenWidth * 0.03)
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Container(
              child: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.04),
                      child: null),
                ],
              ),
            ),
          ),
          GestureDetector(
            // 스크린 터치시 화면 이동을 위한 위젯
            onTap: () {
              setState(() {
                _servingProvider.playAD();
              });
            },
            child: Center(
              child: Offstage(
                offstage: offStageAd!,
                child: Center(
                  child: Column(
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
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}