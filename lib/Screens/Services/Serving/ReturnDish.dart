import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/unmovableCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDoneFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class ReturnProgressModuleFinal extends StatefulWidget {
  const ReturnProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ReturnProgressModuleFinal> createState() =>
      _ReturnProgressModuleFinalState();
}

class _ReturnProgressModuleFinalState extends State<ReturnProgressModuleFinal> {
  late NetworkModel _networkProvider;

  late Timer _pwrTimer;
  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late String backgroundImageServ;

  late String targetTableNum;

  late bool arrivedReturnTable;

  late String currentTargetTable;

  String? startUrl;
  String? navUrl;
  String? moveBaseStatusUrl;

  late int navStatus;
  late bool initNavStatus;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arrivedReturnTable = false;
    navStatus = 0;
    initNavStatus = true;

    currentTargetTable =
        Provider.of<ServingModel>(context, listen: false).returnTargetTable!;

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

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const UnmovableCountDownModalFinal();
        });
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      if (getApiData == 3) {
        while (getApiData != 3) {
          if (mounted) {
            Provider.of<NetworkModel>((context), listen: false).APIGetData =
                getApiData;
            setState(() {
              navStatus = Provider.of<NetworkModel>((context), listen: false)
                  .APIGetData['status'];
              initNavStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          Provider.of<NetworkModel>((context), listen: false).APIGetData =
              getApiData;
          setState(() {
            navStatus = Provider.of<NetworkModel>((context), listen: false)
                .APIGetData['status'];
            initNavStatus = false;
          });
        }
      }
    } else {
      if (mounted) {
        Provider.of<NetworkModel>((context), listen: false).APIGetData =
            getApiData;
        setState(() {
          navStatus = Provider.of<NetworkModel>((context), listen: false)
              .APIGetData['status'];
          initNavStatus = false;
        });
      }
    }
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
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    backgroundImageServ = "assets/screens/Nav/koriZFinalReturnProgNav.png";

    double screenWidth = 1080;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Getting(startUrl!, moveBaseStatusUrl!);
      });
      if (navStatus == 3 && arrivedReturnTable == false) {
          setState(() {
            navStatus = 0;
            arrivedReturnTable = true;
          });
          if(currentTargetTable != 'wait' && currentTargetTable != 'charging_pile'){
            Future.delayed(const Duration(milliseconds: 230), () {
              _effectPlayer.dispose();
              navPage(
                context: context,
                page: const ReturnDoneScreen(),
              ).navPageToPage();
            });
          }
      }
      if(navStatus == 4 && arrivedReturnTable == false){
        setState(() {
          arrivedReturnTable = true;
          navStatus = 0;
        });
        showCountDownPopup(context);
      }
    });

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: screenWidth,
              height: 108,
              child: const Stack(
                children: [
                  AppBarAction(homeButton: false, screenName: "ReturnProgress",),
                  AppBarStatus()
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                const Positioned(
                    top: 220,
                    child: SizedBox(
                      width: 1080,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '테이블 정리 시작 (이동중)',
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
                    top: 400,
                    left: 350,
                    child: SizedBox(
                      width: 380,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 70,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            '$currentTargetTable번 테이블',
                            style: const TextStyle(
                                fontSize: 48, color: Colors.white),
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: 500,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          navPage(
                            context: context,
                            page: const ReturnDoneScreen(),
                          ).navPageToPage();
                        });
                      },
                      child: Container(
                          height: 800,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.transparent, width: 1))))),
                ),
                const NavModuleButtonsFinal(
                  screens: 2,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
