import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FacilityDoneScreen extends StatefulWidget {
  const FacilityDoneScreen({Key? key}) : super(key: key);

  @override
  State<FacilityDoneScreen> createState() => _FacilityDoneScreenState();
}

class _FacilityDoneScreenState extends State<FacilityDoneScreen> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  // String backgroundImage = "assets/screens/Serving/koriZFinalReturn.png";
  String? startUrl;
  String? navUrl;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/KoriFacilityDone.wav';

  late String backgroundImage;

  final CountdownController _controller = CountdownController(autoStart: true);

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ChangingCountDownModalFinal(
            modeState: 'guideDone',
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backgroundImage = "assets/screens/Facility/FacilityGuideDone.png";
    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    double screenWidth = 1080;

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    _audioPlayer.seek(const Duration(seconds: 0));
    _audioPlayer.play();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: screenWidth,
              height: 108,
              child: const Stack(
                children: [
                  const AppBarStatus(
                    EMGImgPos: 500,
                    batteryImgPos: 420,
                    batteryTextPos: 410,
                  ),
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
                seconds: 10,
                build: (_, double time) {
                  return Container();
                },
                interval: const Duration(seconds: 1),
                onFinished: () {
                  Future.delayed(const Duration(milliseconds: 230), () {
                    _effectPlayer.dispose();
                    showCountDownPopup(context);
                  });
                },
              ),
              Positioned(
                  top: 250,
                  child: SizedBox(
                    width: 1080,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]}호 ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}',
                                style: const TextStyle(
                                    fontFamily: 'kor',
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '[안내완료]',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              Positioned(
                top: 1403,
                left: 107,
                child: FilledButton(
                style: FilledButton.styleFrom(
                    fixedSize: const Size((524-107), (1562-1403)),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)
                    )),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    if (_servingProvider.targetTableNum != 'none') {
                      _mainStatusProvider.robotReturning = true;
                      _servingProvider.trayChange = true;
                      _networkProvider.servTable =
                          _servingProvider.targetTableNum;
                      PostApi(
                          url: startUrl,
                          endadr: navUrl,
                          keyBody: _servingProvider.targetTableNum)
                          .Posting(context);
                    }
                    Future.delayed(const Duration(milliseconds: 230), () {
                      _effectPlayer.dispose();
                      _audioPlayer.dispose();
                      navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                      ).navPageToPage();
                    });
                  });
                },
                child: null),
              ),
              Positioned(
                  top: 1403,
                  left: 556,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        fixedSize: const Size((524-107), (1562-1403)),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                        )),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        Future.delayed(const Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          _audioPlayer.dispose();
                          navPage(
                            context: context,
                            page: const FacilityScreen(),
                          ).navPageToPage();
                        });
                      });
                    },
                    child: null
                  ))
            ])));
  }
}
