import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class NavCountDownModalFinal extends StatefulWidget {
  final String? goalPosition;

  const NavCountDownModalFinal({Key? key, this.goalPosition}) : super(key: key);

  @override
  State<NavCountDownModalFinal> createState() => _NavCountDownModalFinalState();
}

class _NavCountDownModalFinalState extends State<NavCountDownModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  final CountdownController _controller = CountdownController(autoStart: true);

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';
  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingNavBegin.mp3';

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  late int tableQT;

  late bool countDownNav;

  late String targetTableNum;

  bool? goalChecker;

  late bool apiCallFlag;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
    goalChecker = false;
    tableQT = 8;
    apiCallFlag = false;
    countDownNav = true;

    _initAudio();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initAudio();
    // });
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.8);
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
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
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    countDownPopup = 'assets/screens/Serving/koriServingCountDown.png';
    if (_servingProvider.trayCheckAll == true) {
      targetTableNum = _servingProvider.allTable!;
    } else {
      if (_servingProvider.table1 != "") {
        targetTableNum = _servingProvider.table1!;
      } else {
        if (_servingProvider.table2 != "") {
          targetTableNum = _servingProvider.table2!;
        } else {
          if (_servingProvider.table3 != "") {
            targetTableNum = _servingProvider.table3!;
          }
        }
      }
    }
    _servingProvider.targetTableNum = targetTableNum;

    return Container(
        padding: const EdgeInsets.only(top: 607),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 740,
              height: 362,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(countDownPopup), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 60, 540, 200),
                child: Countdown(
                  controller: _controller,
                  seconds: 5,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 80,
                        fontWeight: FontWeight.bold),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    _audioPlayer.play();
                    _servingProvider.trayChange = true;
                    _networkProvider.servTable =
                        _servingProvider.targetTableNum;
                    PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: targetTableNum)
                        .Posting(context);
                    navPage(
                      context: context,
                      page: const NavigatorProgressModuleFinal(),
                    ).navPageToPage();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                      ).navPageToPage();
                    });
                  },
                ),
              ),
            ),
            Positioned(
                left: 240,
                top: 100,
                child: Text('초 후 서빙을 시작합니다.',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            Positioned(
              left: 0,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    enableFeedback: false,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.seek(Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    if (_servingProvider.table1 != "" ||
                        (_servingProvider.table2 != "" ||
                            _servingProvider.table3 != "")) {
                      navPage(context: context, page: TraySelectionFinal())
                          .navPageToPage();
                    } else {
                      setState(() {
                        _servingProvider.mainInit = true;
                      });
                      navPage(context: context, page: TraySelectionFinal())
                          .navPageToPage();
                    }
                  });

                },
                child: Center(
                  child: Text(
                    '취소',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 370,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    enableFeedback: false,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  _audioPlayer.play();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.seek(Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    _servingProvider.trayChange = true;
                    _networkProvider.servTable =
                        _servingProvider.targetTableNum;
                    PostApi(
                        url: startUrl,
                        endadr: navUrl,
                        keyBody: targetTableNum)
                        .Posting(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                      ).navPageToPage();
                    });
                  });
                },
                child: Center(
                  child: Text(
                    '시작',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
