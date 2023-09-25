import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavProg.dart';
import 'package:kori_wis_demo/Utills/FacilityCurrentPose.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityNavigatorPauseModuleFinal extends StatefulWidget {
  final String? servGoalPose;

  const FacilityNavigatorPauseModuleFinal({
    this.servGoalPose,
    Key? key,
  }) : super(key: key);

  @override
  State<FacilityNavigatorPauseModuleFinal> createState() =>
      _FacilityNavigatorPauseModuleFinalState();
}

class _FacilityNavigatorPauseModuleFinalState
    extends State<FacilityNavigatorPauseModuleFinal> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late String backgroundImageServ;

  late int buttonNumbers;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late String serviceState;
  late String navSentence;
  late String destinationSentence;

  late String servTableNum;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late double buttonRadius1;
  late double buttonRadius2;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    serviceState = '';
    navSentence = '';
    destinationSentence = '';

    _initAudio();
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    double screenWidth = 1080;

    buttonPositionWidth = [107, 107, 406, 705];
    buttonPositionHeight = [1311, 1501, 1501, 1501];

    buttonSize = [];
    buttonSize1 = [866, 160];
    buttonSize2 = [268, 205];

    buttonRadius1 = 40;
    buttonRadius2 = 32;

    buttonNumbers = buttonPositionHeight.length;

    servTableNum = _networkProvider.servTable!;

    if (servTableNum == 'charging_pile') {
      setState(() {
        serviceState = '[이동]';
        navSentence = '$serviceState이 일시중지 되었습니다';
        destinationSentence = '충전스테이션';
      });
    } else if (servTableNum == '시설1') {
      if(_mainStatusProvider.robotReturning == true){
        setState(() {
          navSentence = '[이동] 중 입니다';
          destinationSentence = '대기장소';
        });
      }else{
        setState(() {
          navSentence = '[안내] 중 입니다';
          destinationSentence =
          '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
        });
      }
    } else {
      setState(() {
        serviceState = '[안내]';
        navSentence = '$serviceState가 일시중지 되었습니다';
        destinationSentence =
            '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
      });
    }

    backgroundImageServ = "assets/screens/Nav/koriZFacilityNavPauseBg.png";

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  const AppBarAction(
                    homeButton: false,
                    screenName: "NavigationPause",
                  ),
                  const AppBarStatus(),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                FacilityCurrentPositionScreen(),
                Positioned(
                    top: 30,
                    left: 35,
                    child: SizedBox(
                      width: 1080,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 65,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            destinationSentence,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                height: 1,
                                fontFamily: 'kor',
                                fontSize: 55,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  left: 107,
                  top: 1510,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(
                            //     color: Colors.white,
                            //     width: 3
                            // ),
                            borderRadius: BorderRadius.circular(40)),
                        fixedSize: Size(866, 160)),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        // 재시작 추가 필요
                        PostApi(url: startUrl, endadr: rsmUrl, keyBody: 'stop')
                            .Posting(context);
                        Future.delayed(const Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          navPage(
                            context: context,
                            page: const FacilityNavigatorProgressModuleFinal(),
                          ).navPageToPage();
                        });
                      });
                    },
                    child: null,
                  ),
                ),
                Positioned(
                  left: 107,
                  top: 1700,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(
                            //     color: Colors.white,
                            //     width: 3
                            // ),
                            borderRadius: BorderRadius.circular(32)),
                        fixedSize: Size(268, 205)),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        PostApi(
                            url: startUrl,
                            endadr: chgUrl,
                            keyBody: 'charging_pile')
                            .Posting(context);
                        _networkProvider.currentGoal = '충전스테이션';
                        _networkProvider.servTable = 'charging_pile';
                        Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              navPage(
                                context: context,
                                page:
                                const FacilityNavigatorProgressModuleFinal(),
                              ).navPageToPage();
                            });
                      });
                    },
                    child: null,
                  ),
                ),
                Positioned(
                  left: 406,
                  top: 1700,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(
                            //     color: Colors.white,
                            //     width: 3
                            // ),
                            borderRadius: BorderRadius.circular(32)),
                        fixedSize: Size(268, 205)),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              if (_mainStatusProvider.robotServiceMode == 2) {
                                navPage(
                                  context: context,
                                  page: const FacilityScreen(),
                                ).navPageToPage();
                              }
                            });
                      });
                    },
                    child: null,
                  ),
                ),
                Positioned(
                  left: 705,
                  top: 1700,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: Colors.white,
                          //   width: 3
                          // ),
                            borderRadius: BorderRadius.circular(32)),
                        fixedSize: Size(268, 205)),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        _mainStatusProvider.robotReturning = true;
                        PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: '시설1')
                            .Posting(context);
                        _networkProvider.servTable = '시설1';
                        Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              navPage(
                                context: context,
                                page:
                                const FacilityNavigatorProgressModuleFinal(),
                              ).navPageToPage();
                            });
                      });
                    },
                    child: null,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
