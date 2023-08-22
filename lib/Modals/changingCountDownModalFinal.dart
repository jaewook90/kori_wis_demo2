import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
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

  final CountdownController _controller = CountdownController(autoStart: true);

  late bool countDownNav;

  late String countDownPopup;

  late String countDownMSG;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownNav = true;
    countDownMSG = '초 후 서빙을 시작합니다.';
    _initAudio();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  String? startUrl;
  String? navUrl;

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    countDownPopup = 'assets/screens/Serving/koriServingCountDown.png';

    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    if((_servingProvider.tray1 == false&&_servingProvider.tray2==false)&&_servingProvider.tray3==false ){
      setState(() {
        countDownMSG = '초 후 대기장소로 돌아갑니다.';
      });
    }else{
      countDownMSG = '초 후 서빙을 시작합니다.';
    }

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
                  seconds: 30,
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
                    if(_servingProvider.tray1 == true){
                      _servingProvider.tray1 = false;
                    }else{
                      if(_servingProvider.tray2 == true){
                        _servingProvider.tray2 = false;
                      }else{
                        if(_servingProvider.tray3 == true){
                          _servingProvider.tray3 = false;
                        }
                      }
                    }
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
                          page: const TraySelectionSec(),
                        ).navPageToPage();
                      });

                    }
                  },
                ),
              ),
            ),
            Positioned(
                left: 240,
                top: 100,
                child: Text(countDownMSG,
                    style: const TextStyle(
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
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: const Center(
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    if(_servingProvider.tray1 == true){
                      _servingProvider.tray1 = false;
                    }else{
                      if(_servingProvider.tray2 == true){
                        _servingProvider.tray2 = false;
                      }else{
                        if(_servingProvider.tray3 == true){
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
                          page: const TraySelectionSec(),
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
                            keyBody: _servingProvider.targetTableNum)
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
                            page: const TraySelectionSec(),
                          ).navPageToPage();
                        });

                      }
                    }
                  });
                },
                child: const Center(
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
