import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Screens/ETC/adScreen.dart';

class AppBarQuick extends StatefulWidget {

  const AppBarQuick({Key? key}) : super(key: key);

  @override
  State<AppBarQuick> createState() => _AppBarQuickState();
}

class _AppBarQuickState extends State<AppBarQuick> {

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  void showReturnSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ReturnDishTableModal();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      Positioned(
          left: 20,
          top: 25,
          child: TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _effectPlayer.seek(const Duration(seconds: 0));
                _effectPlayer.play();
                Future.delayed(const Duration(milliseconds: 230), () {
                  _effectPlayer.dispose();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdScreen(
                    patrolMode: false,
                  )));
                });
              });
            },
            style: TextButton.styleFrom(
                fixedSize: const Size(180, 60),
                enableFeedback: false,
                padding: const EdgeInsets.only(right: 0, bottom: 2),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(0))),
            child: const Text(
              '사이니지',
              style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Colors.white),
            ),
          )),
      Positioned(
          left: 220,
          top: 25,
          child: TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _effectPlayer.seek(const Duration(seconds: 0));
                _effectPlayer.play();
                Future.delayed(const Duration(milliseconds: 230), () {
                  _effectPlayer.dispose();
                  showReturnSelectPopup(context);
                });
              });
            },
            style: TextButton.styleFrom(
                fixedSize: const Size(120, 60),
                enableFeedback: false,
                padding: const EdgeInsets.only(right: 0, bottom: 2),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(0))),
            child: const Text(
              '퇴식',
              style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Colors.white),
            ),
          )),
    ]);
  }
}
