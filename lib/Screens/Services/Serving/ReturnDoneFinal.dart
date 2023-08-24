import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class ReturnDoneScreen extends StatefulWidget {
  const ReturnDoneScreen({Key? key}) : super(key: key);

  @override
  State<ReturnDoneScreen> createState() => _ReturnDoneScreenState();
}

class _ReturnDoneScreenState extends State<ReturnDoneScreen> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late Timer _pwrTimer;

  String backgroundImage = "assets/screens/Serving/koriZFinalReturn.png";
  String? startUrl;
  String? navUrl;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late int batData;
  late int CHGFlag;
  late int EMGStatus;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();

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
      CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;
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
    _effectPlayer.dispose();
    _pwrTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

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
              child: const Stack(
                children: [
                  AppBarAction(homeButton: true,),
                  AppBarStatus()
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
              const Positioned(
                  top: 220,
                  child: SizedBox(
                    width: 1080,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '테이블 정리 중',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )),
              Positioned(
                top: 450,
                left: 0,
                child: GestureDetector(
                    onTap: () {
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.waitingPoint)
                          .Posting(context);
                      Future.delayed(const Duration(milliseconds: 230), () {
                        _effectPlayer.dispose();
                        navPage(
                          context: context,
                          page: const TraySelectionFinal(),
                        ).navPageToPage();
                      });
                    },
                    child: Container(
                        height: 1200,
                        width: 1080,
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                color: Colors.transparent, width: 1))))),
              ),
              const ServingModuleButtonsFinal(screens: 3),
            ])));
  }
}
