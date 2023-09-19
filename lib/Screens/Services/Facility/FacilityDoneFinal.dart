import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FacilityDoneScreen extends StatefulWidget {
  const FacilityDoneScreen({Key? key}) : super(key: key);

  @override
  State<FacilityDoneScreen> createState() => _FacilityDoneScreenState();
}

class _FacilityDoneScreenState extends State<FacilityDoneScreen> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  // String backgroundImage = "assets/screens/Serving/koriZFinalReturn.png";
  String? startUrl;
  String? navUrl;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  final CountdownController _controller = CountdownController(autoStart: true);

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ChangingCountDownModalFinal(
            modeState: 'guideDone',
          );
        });
  }

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

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
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
                  AppBarAction(
                    homeButton: true,
                  ),
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
            child: Stack(children: [
              Countdown(
                controller: _controller,
                seconds: 10,
                build: (_, double time) {
                  return Container();
                },
                interval: const Duration(seconds: 1),
                onFinished: () {
                  Future.delayed(const Duration(milliseconds: 230), () {
                    _effectPlayer.dispose();
                    showCountDownPopup(context);
                  });
                },
              ),
              const Positioned(
                  top: 450,
                  child: SizedBox(
                    width: 1080,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '안내 완료',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 180,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 1200,
                  left: 140,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(800, 150),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(30)
                        )),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        if (_servingProvider.targetTableNum != 'none') {
                          _servingProvider.trayChange = true;
                          _networkProvider.servTable =
                              _servingProvider.targetTableNum;
                          PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.targetTableNum)
                              .Posting(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Future.delayed(const Duration(milliseconds: 230), () {
                              _effectPlayer.dispose();
                              navPage(
                                context: context,
                                page: const NavigatorProgressModuleFinal(),
                              ).navPageToPage();
                            });
                          });
                        }
                      });
                    },
                    child: Text('복 귀', style: TextStyle(
                      fontFamily: 'kor',
                      color: Colors.black,
                      fontSize: 60
                    )),
                  ))
              // Positioned(
              //   top: 450,
              //   left: 0,
              //   child: GestureDetector(
              //       onTap: () {
              //         PostApi(
              //                 url: startUrl,
              //                 endadr: navUrl,
              //                 keyBody: _servingProvider.waitingPoint)
              //             .Posting(context);
              //         Future.delayed(const Duration(milliseconds: 230), () {
              //           _effectPlayer.dispose();
              //           navPage(
              //             context: context,
              //             page: const TraySelectionFinal(),
              //           ).navPageToPage();
              //         });
              //       },
              //       child: Container(
              //           height: 1200,
              //           width: 1080,
              //           decoration: const BoxDecoration(
              //               border: Border.fromBorderSide(BorderSide(
              //                   color: Colors.transparent, width: 1))))),
              // ),
              // const ServingModuleButtonsFinal(screens: 3),
            ])));
  }
}
