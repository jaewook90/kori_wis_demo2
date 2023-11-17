import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNav.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ChangingCountDownModalFinal extends StatefulWidget {
  final String? modeState;

  const ChangingCountDownModalFinal({Key? key, this.modeState})
      : super(key: key);

  @override
  State<ChangingCountDownModalFinal> createState() =>
      _ChangingCountDownModalFinalState();
}

class _ChangingCountDownModalFinalState
    extends State<ChangingCountDownModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  final CountdownController _controller = CountdownController(autoStart: true);

  late bool countDownNav;
  late bool navPopFlag;

  late Timer _navPopTimer;

  late String countDownModalBg;
  late String countDownModalBtn;

  late String countDownMSG;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownNav = true;
    navPopFlag = true;
    countDownMSG = '초 후 서빙을 시작합니다.';
    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  String? startUrl;
  String? navUrl;

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    _navPopTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    countDownModalBg = 'assets/images/modalIMG/bg.png';
    countDownModalBtn = 'assets/images/modalIMG/btn.png';

    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    if (_mainStatusProvider.robotServiceMode == 0) {
      if ((_servingProvider.tray1 == false &&
              _servingProvider.tray2 == false) &&
          _servingProvider.tray3 == false) {
        setState(() {
          countDownMSG = '초 후 대기장소로 돌아갑니다.';
        });
      } else {
        countDownMSG = '초 후 서빙을 시작합니다.';
      }
    } else if (_mainStatusProvider.robotServiceMode == 2) {
      setState(() {
        countDownMSG = '초 후 대기장소로 돌아갑니다.';
      });
    }

    return Container(
        child: AlertDialog(
      alignment: Alignment.topCenter,
      content: Stack(children: [
        Center(
          child: Container(
            width: 828,
            height: 531,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(countDownModalBg), fit: BoxFit.fill)),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 25),
                    height: 320,
                    width: 828,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Container(
                          margin: EdgeInsets.all(6),
                          width: 640,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Countdown(
                                controller: _controller,
                                seconds: 5,
                                build: (_, double time) => Text(
                                  time.toInt().toString(),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      height: 1.2,
                                      fontFamily: 'kor',
                                      fontSize: 65,
                                      fontWeight: FontWeight.bold),
                                ),
                                interval: const Duration(seconds: 1),
                                onFinished: () {
                                  if (_servingProvider.tray1 == true) {
                                    _servingProvider.tray1 = false;
                                  } else {
                                    if (_servingProvider.tray2 == true) {
                                      _servingProvider.tray2 = false;
                                    } else {
                                      if (_servingProvider.tray3 == true) {
                                        _servingProvider.tray3 = false;
                                      }
                                    }
                                  }
                                  if (widget.modeState == 'return') {
                                    PostApi(
                                            url: startUrl,
                                            endadr: navUrl,
                                            keyBody:
                                                _servingProvider.waitingPoint)
                                        .Posting(context);
                                    Future.delayed(Duration(milliseconds: 230),
                                        () {
                                      _effectPlayer.dispose();
                                      navPage(
                                        context: context,
                                        page: const TraySelectionFinal(),
                                      ).navPageToPage();
                                    });
                                  } else if (widget.modeState == 'serving') {
                                    if (_servingProvider.targetTableNum !=
                                        'none') {
                                      setState(() {
                                        _servingProvider.trayChange = true;
                                        _networkProvider.servTable =
                                            _servingProvider.targetTableNum;
                                      });
                                      PostApi(
                                              url: startUrl,
                                              endadr: navUrl,
                                              keyBody: _servingProvider
                                                  .targetTableNum)
                                          .Posting(context);
                                      Future.delayed(
                                          Duration(milliseconds: 230), () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page:
                                              const NavigatorProgressModuleFinal(),
                                        ).navPageToPage();
                                      });
                                    } else {
                                      _servingProvider.clearAllTray();
                                      PostApi(
                                              url: startUrl,
                                              endadr: navUrl,
                                              keyBody:
                                                  _servingProvider.waitingPoint)
                                          .Posting(context);
                                      Future.delayed(
                                          Duration(milliseconds: 230), () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page: const TraySelectionFinal(),
                                        ).navPageToPage();
                                      });
                                    }
                                  } else if (widget.modeState == 'guideDone') {
                                    if (_servingProvider.targetTableNum !=
                                        'none') {
                                      setState(() {
                                        _mainStatusProvider.robotReturning =
                                            true;
                                        _servingProvider.trayChange = true;
                                        _networkProvider.servTable =
                                            _servingProvider.targetTableNum;
                                        _mainStatusProvider.facilityNavDoneScroll = false;
                                        _mainStatusProvider.audioState = true;
                                      });
                                      PostApi(
                                          url: startUrl,
                                          endadr: navUrl,
                                          keyBody: '시설1')
                                          .Posting(context);
                                      // Future.delayed(
                                      //     Duration(milliseconds: 230), () {
                                      //
                                      // });
                                      _navPopTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                                        if(Provider.of<NetworkModel>((context), listen: false)
                                            .APIGetData['status'] != 3){
                                          if(navPopFlag == true){
                                            _effectPlayer.dispose();
                                            Navigator.pop(context);
                                          }
                                          setState(() {
                                            _mainStatusProvider.facilityNavDone = false;
                                            _mainStatusProvider.facilityArrived = false;
                                            navPopFlag = false;
                                          });
                                        }
                                      });
                                      // if(Provider.of<NetworkModel>((context), listen: false)
                                      //     .APIGetData['status'] != 3){
                                      //   _effectPlayer.dispose();
                                      //   Navigator.pop(context);
                                      // }
                                    }
                                  }
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(countDownMSG,
                                  style: TextStyle(
                                      fontFamily: 'kor',
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.2)),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      width: 336,
                      height: 102,
                      decoration: BoxDecoration(
                          // border: Border.fromBorderSide(
                          //     BorderSide(width: 5, color: Colors.tealAccent)),
                          image: DecorationImage(
                              image: AssetImage(countDownModalBtn),
                              fit: BoxFit.fill)),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            fixedSize: const Size(370, 120)),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            _controller.pause();
                            if (widget.modeState == 'guideDone') {
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: const Center(
                          child: Text(
                            '취소',
                            style: TextStyle(
                                color: Color.fromRGBO(238, 238, 238, 0.7),
                                height: 1.2,
                                fontFamily: 'kor',
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 50),
                      width: 336,
                      height: 102,
                      decoration: BoxDecoration(
                          // border: Border.fromBorderSide(
                          //     BorderSide(width: 5, color: Colors.tealAccent)),
                          image: DecorationImage(
                              image: AssetImage(countDownModalBtn),
                              fit: BoxFit.fill)),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            fixedSize: const Size(370, 120)),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            _controller.pause();
                            if (_servingProvider.tray1 == true) {
                              _servingProvider.tray1 = false;
                            } else {
                              if (_servingProvider.tray2 == true) {
                                _servingProvider.tray2 = false;
                              } else {
                                if (_servingProvider.tray3 == true) {
                                  _servingProvider.tray3 = false;
                                }
                              }
                            }
                            if (widget.modeState == 'return') {
                              PostApi(
                                      url: startUrl,
                                      endadr: navUrl,
                                      keyBody: _servingProvider.waitingPoint)
                                  .Posting(context);
                              Future.delayed(Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const TraySelectionFinal(),
                                ).navPageToPage();
                              });
                            } else if (widget.modeState == 'serving') {
                              if (_servingProvider.targetTableNum != 'none') {
                                setState(() {
                                  _servingProvider.trayChange = true;
                                  _networkProvider.servTable =
                                      _servingProvider.targetTableNum;
                                });
                                PostApi(
                                        url: startUrl,
                                        endadr: navUrl,
                                        keyBody:
                                            _servingProvider.targetTableNum)
                                    .Posting(context);
                                Future.delayed(Duration(milliseconds: 230), () {
                                  _effectPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const NavigatorProgressModuleFinal(),
                                  ).navPageToPage();
                                });
                              } else {
                                _servingProvider.clearAllTray();
                                PostApi(
                                        url: startUrl,
                                        endadr: navUrl,
                                        keyBody: _servingProvider.waitingPoint)
                                    .Posting(context);
                                Future.delayed(Duration(milliseconds: 230), () {
                                  _effectPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const TraySelectionFinal(),
                                  ).navPageToPage();
                                });
                              }
                            } else if (widget.modeState == 'guideDone') {
                              if (_servingProvider.targetTableNum != 'none') {
                                setState(() {
                                  _mainStatusProvider.audioState = true;
                                  _mainStatusProvider.robotReturning = true;
                                  _servingProvider.trayChange = true;
                                  _networkProvider.servTable =
                                      _servingProvider.targetTableNum;
                                  _mainStatusProvider.facilityNavDoneScroll = false;
                                });
                                PostApi(
                                        url: startUrl,
                                        endadr: navUrl,
                                        keyBody: '시설1')
                                    .Posting(context);
                                // Future.delayed(
                                //     Duration(milliseconds: 230), () {
                                //
                                // });
                                _navPopTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                                  if(Provider.of<NetworkModel>((context), listen: false)
                                      .APIGetData['status'] != 3){
                                    setState(() {
                                      _mainStatusProvider.facilityNavDone = false;
                                      _mainStatusProvider.facilityArrived = false;
                                    });
                                    _effectPlayer.dispose();
                                    Navigator.pop(context);
                                  }
                                });
                                // if(Provider.of<NetworkModel>((context), listen: false)
                                //     .APIGetData['status'] != 3){
                                //   _effectPlayer.dispose();
                                //   Navigator.pop(context);
                                // }
                              }
                            }
                          });
                        },
                        child: const Center(
                          child: Text(
                            '시작',
                            style: TextStyle(
                                color: Color.fromRGBO(238, 238, 238, 0.7),
                                height: 1.2,
                                fontFamily: 'kor',
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
      backgroundColor: Colors.transparent,
      contentTextStyle: Theme.of(context).textTheme.headlineLarge,
    ));
  }
}
