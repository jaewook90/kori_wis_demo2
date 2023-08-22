import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/ChargingStation.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class KoriDocking extends StatefulWidget {
  const KoriDocking({Key? key}) : super(key: key);

  @override
  State<KoriDocking> createState() => _KoriDockingState();
}

class _KoriDockingState extends State<KoriDocking> {
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _audioPlayer;
  String _audioFile = 'assets/sounds/docking.wav';

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late Timer _pwrTimer;
  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    batData = 0;
    CHGFlag = 8;
    EMGStatus = 1;

    Future.delayed(const Duration(milliseconds: 1000), () {
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
          setState(() {
            batData =
                Provider.of<MainStatusModel>(context, listen: false).batBal!;
            CHGFlag = Provider.of<MainStatusModel>(context, listen: false)
                .chargeFlag!;
            EMGStatus =
                Provider.of<MainStatusModel>(context, listen: false).emgButton!;
          });
        }
      });
    });

    _initAudio();

    _audioPlayer.play();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _audioPlayer.setLoopMode(LoopMode.all);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
    _effectPlayer.dispose();
    _pwrTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (CHGFlag == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mainStatusProvider.fromDocking = true;
        _audioPlayer.dispose();
        navPage(context: context, page: ChargingStation()).navPageToPage();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
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
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      _mainStatusProvider.restartService = true;
                      PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                          .Posting(context);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        navPage(
                          context: context,
                          page: const TraySelectionFinal(),
                        ).navPageToPage();
                      });
                    },
                    style: FilledButton.styleFrom(
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
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: const Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.repeat,
                    size: 400,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    '충전스테이션과 연결 중 입니다',
                    style: TextStyle(
                        height: 1.25,
                        letterSpacing: 5,
                        fontFamily: 'kor',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
