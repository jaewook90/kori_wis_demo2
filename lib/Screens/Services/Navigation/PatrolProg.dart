import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/ETC/adScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class PatrolProgress extends StatefulWidget {
  final String patrol1;
  final String patrol2;

  const PatrolProgress({
    required this.patrol1,
    required this.patrol2,
    Key? key,
  }) : super(key: key);

  @override
  State<PatrolProgress> createState() => _PatrolProgressState();
}

class _PatrolProgressState extends State<PatrolProgress> {
  late NetworkModel _networkProvider;

  late bool adPlay;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late String backgroundImageServ;

  late String targetPoint1;
  late String targetPoint2;

  late String targetPoint;

  late String pastTargetPoint;

  late bool patrolling;

  late bool arrivedServingTable;

  String? startUrl;
  String? navUrl;
  String? stpUrl;

  String? moveBaseStatusUrl;

  late int navStatus;

  late bool initNavStatus;

  late int stopDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adPlay = true;

    initNavStatus = true;
    navStatus = 0;
    arrivedServingTable = false;

    targetPoint1 = widget.patrol1;
    targetPoint2 = widget.patrol2;

    targetPoint = targetPoint1;
    pastTargetPoint = '';

    patrolling = true;

    stopDuration = 0;

    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      if (navStatus == 3) {
        while (navStatus != 3) {
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
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    stpUrl = _networkProvider.stpUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";

    //TODO: 완료 후 토픽 한번만 날리게 수정 필요( 현재는 스테이터스 2개중 0번에서 작동 안하도록 수정함 )
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Getting(startUrl!, moveBaseStatusUrl!);
        if (navStatus == 3 && pastTargetPoint != targetPoint) {
          PostApi(url: startUrl, endadr: navUrl, keyBody: targetPoint)
              .Posting(context);
          setState(() {
            arrivedServingTable = true;
          });
          Future.delayed(const Duration(seconds: 5), () {
            if (targetPoint == targetPoint1) {
              setState(() {
                arrivedServingTable = false;
                if (navStatus != 0) {
                  pastTargetPoint = targetPoint;
                  targetPoint = targetPoint2;
                }
              });
            } else if (targetPoint == targetPoint2) {
              setState(() {
                arrivedServingTable = false;
                if (navStatus != 0) {
                  pastTargetPoint = targetPoint2;
                  targetPoint = targetPoint1;
                }
              });
            }
          });
        }
      });
    });

    if (navStatus == 4) {
      PostApi(url: startUrl, endadr: navUrl, keyBody: pastTargetPoint)
          .Posting(context);
      setState(() {
        targetPoint = pastTargetPoint;
      });
    }

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
                  const AppBarAction(homeButton: true, screenName: "Patrolling",),
                  const AppBarStatus(),
                  Positioned(
                    right: 150,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            if (adPlay == false) {
                              setState(() {
                                adPlay = true;
                              });
                            } else {
                              setState(() {
                                adPlay = false;
                              });
                            }
                          });
                        });
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(60, 60),
                          enableFeedback: false,
                          padding: const EdgeInsets.only(right: 0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      child: Icon(
                          adPlay == false
                              ? Icons.play_circle_outline_sharp
                              : Icons.pause_circle_outline_sharp,
                          color: Colors.white,
                          size: 60),
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
                    top: 372,
                    left: 460,
                    child: SizedBox(
                      width: 300,
                      height: 90,
                      child: Text(
                        '$targetPoint번 테이블',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                Positioned(
                    top: 1367,
                    left: 107,
                    child: FilledButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            PostApi(
                                    url: startUrl,
                                    endadr: stpUrl,
                                    keyBody: 'stop')
                                .Posting(context);
                            Future.delayed(const Duration(milliseconds: 20),
                                () {
                              PostApi(
                                      url: startUrl,
                                      endadr: navUrl,
                                      keyBody: 'wait')
                                  .Posting(context);
                            });
                            navPage(
                                    context: context,
                                    page: const TraySelectionFinal())
                                .navPageToPage();
                          });
                        });
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          fixedSize: const Size(866, 173)),
                    ))
              ],
            ),
          ),
          Offstage(
            offstage: !adPlay,
            child: const AdScreen(patrolMode: true),
          ),
        ]),
      ),
    );
  }
}
