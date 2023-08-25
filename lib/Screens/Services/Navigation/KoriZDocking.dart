import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/ChargingStation.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class KoriDocking extends StatefulWidget {
  const KoriDocking({Key? key}) : super(key: key);

  @override
  State<KoriDocking> createState() => _KoriDockingState();
}

class _KoriDockingState extends State<KoriDocking> {
  late MainStatusModel _mainStatusProvider;


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

  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
    _pwrTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (CHGFlag == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mainStatusProvider.fromDocking = true;
        navPage(context: context, page: ChargingStation()).navPageToPage();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: const [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                AppBarStatus(),
                AppBarAction(homeButton: false, screenName: 'Docking',),
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
