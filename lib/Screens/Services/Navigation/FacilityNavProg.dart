import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/unmovableCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityDoneFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavPause.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/KoriZDocking.dart';
import 'package:kori_wis_demo/Utills/FacilityCurrentPose.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityNavigatorProgressModuleFinal extends StatefulWidget {
  const FacilityNavigatorProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<FacilityNavigatorProgressModuleFinal> createState() =>
      _FacilityNavigatorProgressModuleFinalState();
}

class _FacilityNavigatorProgressModuleFinalState
    extends State<FacilityNavigatorProgressModuleFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;

  //assets
  final String _effectFile = 'assets/sounds/button_click.wav';

  late int hiddenCounter;

  late String backgroundImageServ;

  late String navSentence;
  late String destinationSentence;

  late String targetTableNum;

  late String servTableNum;

  late bool arrivedServingTable;

  String? startUrl;
  String? navUrl;
  String? moveBaseStatusUrl;
  String? stpUrl;

  late int navStatus;

  late bool initNavStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hiddenCounter = 0;
    navSentence = '';
    destinationSentence = '';
    initNavStatus = true;
    navStatus = 99;
    arrivedServingTable = false;
    targetTableNum = "";

    _initAudio();
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      // 이동 화면 첫 진입 여부 확인
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

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const UnmovableCountDownModalFinal();
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
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;
    stpUrl = _networkProvider.stpUrl;

    servTableNum = _networkProvider.servTable!;

    if (servTableNum == 'charging_pile') {
      setState(() {
        navSentence = '[이동] 중 입니다';
        destinationSentence = '충전스테이션';
      });
    } else if (servTableNum == '시설1') {
      if(_mainStatusProvider.robotReturning == true){
        setState(() {
          navSentence = '[이동] 중 입니다';
          destinationSentence = '대기장소';
        });
      }else{
        setState(() {
          navSentence = '[안내] 중 입니다';
          destinationSentence =
          '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
        });
      }
    } else {
      setState(() {
        navSentence = '[안내] 중 입니다';
        destinationSentence =
            '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
      });
    }

    backgroundImageServ = "assets/screens/Nav/koriZFacilityNavBg.png";

    targetTableNum = '시설1';

    _servingProvider.targetTableNum = targetTableNum;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Getting(startUrl!, moveBaseStatusUrl!);
      });
      if (navStatus == 3 && arrivedServingTable == false) {
        setState(() {
          arrivedServingTable = true;
          navStatus = 0;
        });
        if (servTableNum != '시설1' && servTableNum != 'charging_pile') {
          Future.delayed(const Duration(milliseconds: 230), () {
            navPage(context: context, page: FacilityDoneScreen())
                .navPageToPage();
          });
        } else if (servTableNum == '시설1') {
          _servingProvider.clearAllTray();
          Future.delayed(const Duration(milliseconds: 230), () {
            navPage(context: context, page: FacilityScreen()).navPageToPage();
          });
        } else if (servTableNum == 'charging_pile') {
          Future.delayed(const Duration(milliseconds: 230), () {
            navPage(
              context: context,
              page: const KoriDocking(),
            ).navPageToPage();
          });
        }
      }
      if (navStatus == 4 && arrivedServingTable == false) {
        setState(() {
          arrivedServingTable = true;
          navStatus = 0;
        });
        showCountDownPopup(context);
      }
    });

    double screenWidth = 1080;

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
              child: Stack(
                children: [
                  const AppBarAction(
                    homeButton: false,
                    screenName: "NavigationProgress",
                  ),
                  const AppBarStatus(),
                  Positioned(
                    right: 30,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          hiddenCounter++;
                        });
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            hiddenCounter = 0;
                          });
                        });
                        if (hiddenCounter == 5) {
                          _servingProvider.clearAllTray();
                          navPage(context: context, page: FacilityScreen())
                              .navPageToPage();
                          PostApi(url: startUrl, endadr: navUrl, keyBody: '시설1')
                              .Posting(context);
                        }
                      },
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          // side: BorderSide(color: Colors.white, width: 5),
                          surfaceTintColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledForegroundColor: Colors.transparent,
                          fixedSize: const Size(120, 60),
                          enableFeedback: false,
                          backgroundColor: Colors.transparent),
                      child: null,
                    ),
                  ),
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
                FacilityCurrentPositionScreen(),
                // Positioned(
                //     top: 250,
                //     child: SizedBox(
                //       width: 1080,
                //       height: 100,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             navSentence,
                //             style: const TextStyle(
                //                 fontFamily: 'kor',
                //                 fontSize: 70,
                //                 fontWeight: FontWeight.bold,
                //                 color: Color(0xfffffefe)),
                //           ),
                //         ],
                //       ),
                //     )),
                Positioned(
                  top: 30,
                    left: 35,
                    child: SizedBox(
                      width: 1080,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 65,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            destinationSentence,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              height: 1,
                                fontFamily: 'kor',
                                fontSize: 55,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  top: 1567,
                  left: 107,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      enableFeedback: false,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.red,
                          width: 3
                        ),
                          borderRadius: BorderRadius.circular(40)),
                      fixedSize: Size(866, 173),
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(Duration(seconds: 0));
                        _effectPlayer.play();
                        PostApi(url: startUrl, endadr: stpUrl, keyBody: 'stop')
                            .Posting(context);
                        Future.delayed(Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          navPage(
                            context: context,
                            page: FacilityNavigatorPauseModuleFinal(
                                servGoalPose: servTableNum),
                          ).navPageToPage();
                        });
                      });
                    },
                    child: Text('정 지', style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 60,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
