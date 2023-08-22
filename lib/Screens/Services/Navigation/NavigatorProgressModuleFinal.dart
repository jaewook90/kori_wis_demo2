import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/unmovableCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/KoriZDocking.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class NavigatorProgressModuleFinal extends StatefulWidget {
  const NavigatorProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorProgressModuleFinal> createState() =>
      _NavigatorProgressModuleFinalState();
}

class _NavigatorProgressModuleFinalState
    extends State<NavigatorProgressModuleFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late int hiddenCounter;

  late Timer _pwrTimer;
  late String backgroundImageServ;

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/sounds/sound_moving_bg.wav';

  late String navSentence;
  late String destinationSentence;

  late String targetTableNum;

  late String servTableNum;

  late bool arrivedServingTable;

  late bool _debugMode;

  String? startUrl;
  String? navUrl;
  String? moveBaseStatusUrl;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

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

    _debugMode = Provider.of<MainStatusModel>((context), listen: false).debugMode!;


    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _initAudio();

    _audioPlayer.seek(const Duration(seconds: 0));
    _audioPlayer.play();

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // initNavStatus = Provider.of<MainStatusModel>(context, listen: false).initNavStatus!;
      StatusManagements(context,
          Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      // StatusManagements(context,
      //     Provider.of<NetworkModel>(context, listen: false).startUrl!)
      //     .gettingMoveData(initNavStatus);

      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      if (batData !=
          Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }
      // if (navStatus !=
      //     Provider.of<MainStatusModel>(context, listen: false).movebaseStatus!) {
      //   setState(() {});
      // }

      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;
      // navStatus = Provider.of<MainStatusModel>(context, listen: false).movebaseStatus!;
    });
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _audioPlayer.setLoopMode(LoopMode.all);
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
    _pwrTimer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    servTableNum = _networkProvider.servTable!;

    if(servTableNum == 'charging_pile'){
      setState(() {
        navSentence = '[이동] 중 입니다';
        destinationSentence = '충전스테이션';
      });
    }else if(servTableNum == 'wait'){
      setState(() {
        navSentence = '[이동] 중 입니다';
        destinationSentence = '대기장소';
      });
    }else{
      setState(() {
        navSentence = '[서빙] 중 입니다';
        destinationSentence = '$servTableNum번 테이블';
      });
    }

    backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";

    if (_servingProvider.targetTableNum != null) {
      targetTableNum = _servingProvider.targetTableNum!;
    }

    setState(() {
      if (targetTableNum == _servingProvider.table1) {
        _servingProvider.table1 = "";
        _servingProvider.item1 = '';
      } else if (targetTableNum == _servingProvider.table2) {
        _servingProvider.table2 = "";
      } else if (targetTableNum == _servingProvider.table3) {
        _servingProvider.table3 = "";
      }
    });
    if (_servingProvider.trayChange == true) {
      if (_servingProvider.table1 != "" &&
          _servingProvider.trayChange == true) {
        targetTableNum = _servingProvider.table1!;
        _servingProvider.trayChange = false;
      } else {
        if (_servingProvider.table2 != "" &&
            _servingProvider.trayChange == true) {
          targetTableNum = _servingProvider.table2!;
          _servingProvider.trayChange = false;
        } else {
          if (_servingProvider.table3 != "" &&
              _servingProvider.trayChange == true) {
            targetTableNum = _servingProvider.table3!;
            _servingProvider.trayChange = false;
          } else {
            if (targetTableNum == 'wait') {
              targetTableNum = 'none';
              _servingProvider.trayChange = false;
            } else {
              targetTableNum = 'wait';
              _servingProvider.trayChange = false;
            }
          }
        }
      }
    }
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
        if (servTableNum != 'wait' && servTableNum != 'charging_pile') {
          Future.delayed(Duration(milliseconds: 230), () {
            _audioPlayer.dispose();
            navPage(
              context: context,
              page: const ServingProgressFinal(),
            ).navPageToPage();
          });
        } else if (servTableNum == 'wait') {
          setState(() {
            _servingProvider.mainInit = true;
          });
          _servingProvider.clearAllTray();
          Future.delayed(Duration(milliseconds: 230), () {
            _audioPlayer.dispose();
            navPage(
              context: context,
              page: const TraySelectionSec(),
            ).navPageToPage();
          });
        } else if (servTableNum == 'charging_pile') {
          setState(() {
            _servingProvider.mainInit = true;
          });
          Future.delayed(Duration(milliseconds: 230), () {
            _audioPlayer.dispose();
            navPage(
              context: context,
              page: const KoriDocking(),
            ).navPageToPage();
          });

        }
      }
      if(navStatus == 4 && arrivedServingTable == false){
        setState(() {
          arrivedServingTable = true;
          navStatus = 0;
        });
        _audioPlayer.dispose();
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
                    right: 30,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          hiddenCounter++;
                        });
                        Future.delayed(Duration(milliseconds: 2000),(){
                          setState(() {
                            hiddenCounter = 0;
                          });
                        });
                        if(hiddenCounter == 5){
                          _audioPlayer.dispose();
                          _servingProvider.clearAllTray();
                          navPage(context: context, page: TraySelectionSec()).navPageToPage();
                          PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: 'wait')
                              .Posting(context);
                        }
                      },
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          // side: BorderSide(color: Colors.white, width: 5),
                          surfaceTintColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,

                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledForegroundColor: Colors.transparent,

                          fixedSize: const Size(120, 60),
                          enableFeedback: false,
                          backgroundColor: Colors.transparent
                      ),
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
                Positioned(
                  top: 500,
                  left: 0,
                  child: Offstage(
                    offstage: _debugMode,
                    child: GestureDetector(
                        onTap: () {
                          if (arrivedServingTable == false) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                arrivedServingTable = true;
                              });
                              if (servTableNum != 'wait' &&
                                  servTableNum != 'charging_pile') {
                                Future.delayed(Duration(milliseconds: 230), () {
                                  _audioPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const ServingProgressFinal(),
                                  ).navPageToPage();
                                });
                              } else if (servTableNum == 'wait') {
                                setState(() {
                                  _servingProvider.mainInit = true;
                                });
                                _servingProvider.clearAllTray();
                                Future.delayed(Duration(milliseconds: 230), () {
                                  _audioPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const TraySelectionSec(),
                                  ).navPageToPage();
                                });

                              } else if (servTableNum == 'charging_pile') {
                                setState(() {
                                  _servingProvider.mainInit = true;
                                });
                                Future.delayed(Duration(milliseconds: 230), () {
                                  _audioPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const TraySelectionSec(),
                                  ).navPageToPage();
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                            height: 800,
                            width: 1080,
                            decoration: const BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    color: Colors.transparent, width: 1))))),
                  ),
                ),
                Positioned(
                    top: 250,
                    child: SizedBox(
                      width: 1080,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            navSentence,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    top: 372,
                    child: SizedBox(
                      width: 1080,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 65, color: Colors.white,),
                          const SizedBox(width: 15,),
                          Text(
                            destinationSentence,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 55,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                NavModuleButtonsFinal(
                  screens: 0,
                  servGoalPose: servTableNum,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
