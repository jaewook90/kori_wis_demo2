import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NavigatorPauseModuleFinal extends StatefulWidget {
  NavigatorPauseModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorPauseModuleFinal> createState() =>
      _NavigatorPauseModuleFinalState();
}

class _NavigatorPauseModuleFinalState extends State<NavigatorPauseModuleFinal> {
  late NetworkModel _networkProvider;
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

  late String backgroundImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    if (_networkProvider.serviceState == 0) {
      backgroundImage = "assets/screens/Nav/koriZFinalShipPauseNav.png";
    } else if (_networkProvider.serviceState == 1) {
      backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";
    }

    offStageAd = _servingProvider.playAd;

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;
    currentGoal = _networkProvider.currentGoal;

    serviceState = _networkProvider.serviceState;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Color(0xffB7B7B7),
          iconSize: screenHeight * 0.03,
          alignment: Alignment.centerRight,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 600, 0),
            child: TextButton(
              onPressed: () {
                if(_networkProvider.serviceState==0){
                  navPage(
                      context: context,
                      page: ShippingDoneFinal(),
                      enablePop: false)
                      .navPageToPage();
                  // showShippingDone(context);
                }else if(_networkProvider.serviceState==1){
                  navPage(
                      context: context,
                      page: ServingProgressFinal(),
                      enablePop: false)
                      .navPageToPage();
                }
              },
              child: Text(
                '도착',
                style: TextStyle(
                    fontFamily: 'kok',
                    fontSize: 20,
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
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
            onPressed: () {
              _servingProvider.clearAllTray();
              _servingProvider.initServing();
              navPage(context: context, page: ServiceScreenFinal(), enablePop: false)
                  .navPageToPage();
            },
            icon: Icon(
              Icons.home_outlined,
            ),
            color: Color(0xffB7B7B7),
            iconSize: screenHeight * 0.03,
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Icon(Icons.battery_charging_full,
                color: Colors.teal, size: screenHeight * 0.03),
          ),
        ],
        toolbarHeight: screenHeight * 0.045,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Container(
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.04),
                    child: null),
                _networkProvider.serviceState == 0
                    ? NavModuleButtonsFinal(
                        screens: 2,
                      )
                    : _networkProvider.serviceState == 1
                        ? NavModuleButtonsFinal(screens: 1)
                        : Container(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}