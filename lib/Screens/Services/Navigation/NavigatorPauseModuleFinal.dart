import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/ServingModules/tableSelectModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class NavigatorPauseModuleFinal extends StatefulWidget {
  final String? servGoalPose;

  const NavigatorPauseModuleFinal({
    this.servGoalPose,
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorPauseModuleFinal> createState() =>
      _NavigatorPauseModuleFinalState();
}

class _NavigatorPauseModuleFinalState extends State<NavigatorPauseModuleFinal> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  late String backgroundImage;

  late String serviceState;
  late String navSentence;
  late String destinationSentence;

  late String servTableNum;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late int buttonNumbers;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

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
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  // 추후 디테일 하게 변경 ( 전체 서빙 / 트레이별 서빙 )
  void showTableSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectTableModalFinal();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
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

    backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";

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
    } else if (servTableNum == 'wait' || servTableNum == '716') {
      setState(() {
        serviceState = '[이동]';
        navSentence = '$serviceState이 일시중지 되었습니다';
        destinationSentence = '대기장소';
      });
    } else {
      if (_mainStatusProvider.robotServiceMode == 0) {
        setState(() {
          serviceState = '[서빙]';
          navSentence = '$serviceState이 일시중지 되었습니다';
          destinationSentence = '$servTableNum번 테이블';
        });
      } else if (_mainStatusProvider.robotServiceMode == 1) {
        setState(() {
          serviceState = '[배송]';
          navSentence = '$serviceState이 일시중지 되었습니다';
          destinationSentence = '$servTableNum 호';
        });
      } else if (_mainStatusProvider.robotServiceMode == 2) {
        setState(() {
          serviceState = '[안내]';
          navSentence = '$serviceState가 일시중지 되었습니다';
          destinationSentence =
              '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
        });
      }
    }

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
              child: const Stack(
                children: [
                  AppBarAction(
                    homeButton: false,
                    screenName: "NavigationPause",
                  ),
                  AppBarStatus(),
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
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                    top: 250,
                    child: SizedBox(
                      width: 1080,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            navSentence,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    top: 372,
                    child: SizedBox(
                      width: 1080,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                fontFamily: 'kor',
                                fontSize: 55,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                for (int i = 0; i < buttonNumbers; i++)
                  Positioned(
                    left: buttonPositionWidth[i],
                    top: buttonPositionHeight[i],
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  i == 0 ? buttonRadius1 : buttonRadius2)),
                          fixedSize: i == 0
                              ? Size(buttonSize1[buttonWidth],
                                  buttonSize1[buttonHeight])
                              : Size(buttonSize2[buttonWidth],
                                  buttonSize2[buttonHeight])),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          if (i == 0) {
                            // 재시작 추가 필요
                            PostApi(
                                    url: startUrl,
                                    endadr: rsmUrl,
                                    keyBody: 'stop')
                                .Posting(context);
                            Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              navPage(
                                context: context,
                                page: const NavigatorProgressModuleFinal(),
                              ).navPageToPage();
                            });
                          } else if (i == 1) {
                            // 충전하러가기 기능
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
                                page: const NavigatorProgressModuleFinal(),
                              ).navPageToPage();
                            });
                          } else if (i == 2) {
                            // 추후에는 골 포지션 변경을 하며 자율주행 명령 추가
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
                            // showTableSelectPopup(context);
                          } else {
                            // 추후에는 거점으로 복귀
                            if (_mainStatusProvider.robotServiceMode == 0) {
                              PostApi(
                                      url: startUrl,
                                      endadr: navUrl,
                                      keyBody: 'wait')
                                  .Posting(context);
                              _networkProvider.servTable = 'wait';
                              Future.delayed(const Duration(milliseconds: 230),
                                  () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const NavigatorProgressModuleFinal(),
                                ).navPageToPage();
                              });
                            }else if (_mainStatusProvider.robotServiceMode == 1) {
                              PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: 'wait')
                                  .Posting(context);
                              _networkProvider.servTable = 'wait';
                              Future.delayed(const Duration(milliseconds: 230),
                                      () {
                                    _effectPlayer.dispose();
                                    navPage(
                                      context: context,
                                      page: const NavigatorProgressModuleFinal(),
                                    ).navPageToPage();
                                  });
                            }else if (_mainStatusProvider.robotServiceMode == 2) {
                              PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: '716')
                                  .Posting(context);
                              _networkProvider.servTable = '716';
                              Future.delayed(const Duration(milliseconds: 230),
                                      () {
                                    _effectPlayer.dispose();
                                    navPage(
                                      context: context,
                                      page: const NavigatorProgressModuleFinal(),
                                    ).navPageToPage();
                                  });
                            }
                            // _networkProvider.currentGoal = '충전스테이션';
                          }
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
