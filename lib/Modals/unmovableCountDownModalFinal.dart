import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class UnmovableCountDownModalFinal extends StatefulWidget {
  final String? goalPosition;

  const UnmovableCountDownModalFinal({Key? key, this.goalPosition}) : super(key: key);

  @override
  State<UnmovableCountDownModalFinal> createState() => _UnmovableCountDownModalFinalState();
}

class _UnmovableCountDownModalFinalState extends State<UnmovableCountDownModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  final CountdownController _controller = CountdownController(autoStart: true);

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';
  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingNavFail.wav';

  String? startUrl;
  String? navUrl;

  late String targetTableNum;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();
    _audioPlayer.play();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
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

    countDownPopup = 'assets/screens/Serving/koriServingEMGAlert.png';

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
                    _networkProvider.servTable = 'wait';
                    PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: 'wait')
                        .Posting(context);
                    Future.delayed(Duration(milliseconds: 230), () {
                      _audioPlayer.dispose();
                      _effectPlayer.dispose();
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
            const Positioned(
                left: 240,
                top: 100,
                child: Text('초 후 대기장소로 돌아 갑니다.',
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
                    fixedSize: const Size(740, 120)),
                onPressed: () {
                  _audioPlayer.play();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _controller.pause();
                    _audioPlayer.play();
                    _servingProvider.trayChange = true;
                    _networkProvider.servTable = 'wait';
                    PostApi(
                        url: startUrl,
                        endadr: navUrl,
                        keyBody: 'wait')
                        .Posting(context);
                    Future.delayed(Duration(milliseconds: 230), () {
                      _audioPlayer.dispose();
                      _effectPlayer.dispose();
                      navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                      ).navPageToPage();
                    });
                  });
                },
                child: const Center(
                  child: Text(
                    '확인',
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
