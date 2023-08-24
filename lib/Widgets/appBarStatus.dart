import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';

class AppBarStatus extends StatefulWidget {

  const AppBarStatus({Key? key}) : super(key: key);

  @override
  State<AppBarStatus> createState() => _AppBarStatusState();
}

class _AppBarStatusState extends State<AppBarStatus> {

  late Timer _pwrTimer;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _initAudio();

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if ((EMGStatus !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .emgButton! ||
              CHGFlag !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .chargeFlag!) ||
          batData !=
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
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
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
              right: 245,
              top: 15,
              child: Stack(children: [
                Icon(Icons.radio_button_checked,
                    color: Colors.red, size: 80, grade: 200, weight: 200),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 12),
                  child: Text(
                    'EMG',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.yellow),
                  ),
                )
              ]),
            )
          : Container(),
      CHGFlag == 3
          ? const Positioned(
              right: 50,
              top: 18,
              child: Icon(Icons.bolt, color: Colors.yellow, size: 50),
            )
          : Container(),
    ]);
  }
}
