import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ServingProgressFinal extends StatefulWidget {
  const ServingProgressFinal({Key? key}) : super(key: key);

  @override
  State<ServingProgressFinal> createState() => _ServingProgressFinalState();
}

class _ServingProgressFinalState extends State<ServingProgressFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  // late MainStatusModel _mainStatusProvider;

  late String currentServedTrayNum;
  late Timer _pwrTimer;

  late String _audioFile;

  late AudioPlayer _audioPlayer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ChangingCountDownModalFinal(
            modeState: 'serving',
          );
        });
  }

  final CountdownController _controller = CountdownController(autoStart: true);

  String backgroundImage = "assets/screens/Serving/koriServingDone.png";
  String? startUrl;
  String? navUrl;

  late String targetTableNum;

  late bool _debugMode;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.pause();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);

    currentServedTrayNum = '';
    _audioFile = '';
    _debugMode =
        Provider.of<MainStatusModel>((context), listen: false).debugMode!;

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      if (batData !=
          Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }
      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag =
          Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus =
          Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
    _effectPlayer.dispose();
    _controller.pause();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    // _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (_servingProvider.tray1 == true) {
      currentServedTrayNum = '1번 ';
      _audioFile = 'assets/voices/koriServingNavDoneTray1.wav';
    } else {
      if (_servingProvider.tray2 == true) {
        currentServedTrayNum = '2번 ';
        _audioFile = 'assets/voices/koriServingNavDoneTray2.wav';
      } else {
        if (_servingProvider.tray3 == true) {
          currentServedTrayNum = '3번 ';
          _audioFile = 'assets/voices/koriServingNavDoneTray3.wav';
        } else {
          currentServedTrayNum = '';
          _audioFile = 'assets/voices/koriServingNavDone.wav';
        }
      }
    }

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

    _initAudio();

    Future.delayed(Duration(seconds: 1), () {
      _audioPlayer.play();
    });

    double screenWidth = 1080;

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();
                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });
                        });
                      },
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          fixedSize: const Size(90, 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Home.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 46,
                    top: 60,
                    child: Text(('${batData.toString()} %')),
                  ),
                  Positioned(
                    right: 50,
                    top: 20,
                    child: Container(
                      height: 45,
                      width: 50,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  EMGStatus == 0
                      ? const Positioned(
                          right: 35,
                          top: 15,
                          child: Icon(Icons.block,
                              color: Colors.red,
                              size: 80,
                              grade: 200,
                              weight: 200),
                        )
                      : Container(),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(children: [
              Countdown(
                controller: _controller,
                seconds: 15,
                build: (_, double time) {
                  return Container();
                },
                interval: const Duration(seconds: 1),
                onFinished: () {
                  Future.delayed(Duration(milliseconds: 230), () {
                    _effectPlayer.dispose();
                    _audioPlayer.dispose();
                    showCountDownPopup(context);
                  });
                },
              ),
              Positioned(
                  top: 310,
                  child: SizedBox(
                    width: 1080,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentServedTrayNum,
                                  style: const TextStyle(
                                      fontFamily: 'kor',
                                      fontSize: 33,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const Text(
                                  '트레이에서 상품을 수령하신 후',
                                  style: TextStyle(
                                      fontFamily: 'kor',
                                      fontSize: 32,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  '[완료] ',
                                  style: TextStyle(
                                      fontFamily: 'kor',
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  '버튼을 눌러주세요.',
                                  style: TextStyle(
                                      fontFamily: 'kor',
                                      fontSize: 32,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Positioned(
                top: 450,
                left: 0,
                child: Offstage(
                  offstage: _debugMode,
                  child: GestureDetector(
                      onTap: () {
                        _controller.pause();
                        // _mainStatusProvider.initNavStatus = true;
                        if (_servingProvider.targetTableNum != 'none') {
                          setState(() {
                            _servingProvider.trayChange = true;
                            _networkProvider.servTable =
                                _servingProvider.targetTableNum;
                          });
                          PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: _servingProvider.targetTableNum)
                              .Posting(context);
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();
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
                            _audioPlayer.dispose();
                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });

                        }
                      },
                      child: Container(
                          height: 1200,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.transparent, width: 1))))),
                ),
              ),
              Positioned(
                left: 107.3,
                top: 1372.5,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      enableFeedback: false,
                      backgroundColor: const Color(0xff3a46f0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      fixedSize: const Size(866, 160)),
                  child: const Text(
                    '완 료',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _effectPlayer.seek(const Duration(seconds: 0));
                      _effectPlayer.play();
                      _controller.pause();
                      if (_servingProvider.targetTableNum != 'none') {
                        _servingProvider.trayChange = true;
                        _networkProvider.servTable =
                            _servingProvider.targetTableNum;
                        PostApi(
                                url: startUrl,
                                endadr: navUrl,
                                keyBody: _servingProvider.targetTableNum)
                            .Posting(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();
                            navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                            ).navPageToPage();
                          });
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
                          _audioPlayer.dispose();
                          navPage(
                            context: context,
                            page: const TraySelectionFinal(),
                          ).navPageToPage();
                        });
                      }
                    });
                  },
                ),
              ),
            ])));
  }
}
