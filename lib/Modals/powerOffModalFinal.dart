import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PowerOffModalFinal extends StatefulWidget {
  const PowerOffModalFinal({Key? key}) : super(key: key);

  @override
  State<PowerOffModalFinal> createState() => _PowerOffModalFinalState();
}

class _PowerOffModalFinalState extends State<PowerOffModalFinal> {
  final CountdownController _controller = CountdownController(autoStart: true);

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';
  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingNavBegin.wav';

  late bool countDownNav;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownNav = true;
    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
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
    countDownPopup = 'assets/screens/Serving/koriServingCountDown.png';

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
                padding: const EdgeInsets.fromLTRB(120, 90, 520, 170),
                child: Countdown(
                  controller: _controller,
                  seconds: 10,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 70,
                        fontWeight: FontWeight.bold),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
            ),
            const Positioned(
                left: 240,
                top: 50,
                child: Text('앱을 종료하시겠습니까?',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            const Positioned(
                left: 240,
                top: 120,
                child: Text('초 후 앱을 종료합니다.',
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
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _effectPlayer.play();
                    _controller.pause();
                    Future.delayed(Duration(milliseconds: 230), () {
                      _audioPlayer.dispose();
                      _effectPlayer.dispose();
                      navPage(
                              context: context,
                              page: const TraySelectionFinal())
                          .navPageToPage();
                    });
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
                  SystemNavigator.pop();
                },
                child: const Center(
                  child: Text(
                    '종료',
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
