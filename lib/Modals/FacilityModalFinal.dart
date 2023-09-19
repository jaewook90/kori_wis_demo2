import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/CableConnectedModalFinal.dart';
import 'package:kori_wis_demo/Modals/EMGPopModalFinal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';

class FacilityModal extends StatefulWidget {
  final int? number;
  const FacilityModal({Key? key, this.number}) : super(key: key);

  @override
  State<FacilityModal> createState() => _FacilityModalState();
}

class _FacilityModalState extends State<FacilityModal> {
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late Timer _pwrTimer;

  String? startUrl;
  String? navUrl;

  late int CHGFlag;
  late int EMGStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();

    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
          Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false)
              .emgButton! ||
          CHGFlag !=
              Provider.of<MainStatusModel>(context, listen: false)
                  .chargeFlag!) {
        setState(() {});
      }
      // batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag =
      Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus =
      Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  void showEMGAlert(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const EMGPopModalFinal();
        });
  }

  void showAdaptorCableAlert(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const CableConnectedModalFinal();
        });
  }

  void showCountDownPopup(context, officeLocation) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal(serviceMode: 'facilityGuide', goalPosition: officeLocation,);
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    _mainStatusProvider.targetFacilityIndex = widget.number;

    return Container(
        padding: const EdgeInsets.only(top: 588),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Container(
            width: 740,
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border.fromBorderSide(
                BorderSide(
                  width: 3,
                  color: Colors.white
                )
              )
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 110,
                          ),
                          Text('${_mainStatusProvider.facilityNum![widget.number!]}',
                              style: const TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(
                            width: 110,
                          ),
                          Text(_mainStatusProvider.facilityName![widget.number!],
                              style: const TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      // const Divider(
                      //   height: 60,
                      //   color: Colors.white,
                      //   indent: 50,
                      //   endIndent: 50,
                      //   thickness: 3,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     const SizedBox(
                      //       width: 100,
                      //     ),
                      //     Text(_mainStatusProvider.facilityDetail![widget.number!].toString(),
                      //         style: const TextStyle(
                      //             fontFamily: 'kor',
                      //             fontSize: 35,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white)),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 170,
                  child: Row(
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            shape: LinearBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.white
                                ),
                                top: LinearBorderEdge(size: 1),
                              end: LinearBorderEdge(size: 1)
                            ),
                            fixedSize: const Size(370, 120)),
                        onPressed: () {
                          if (EMGStatus == 0) {
                            showEMGAlert(context);
                          } else {
                            if (CHGFlag == 3) {
                              showAdaptorCableAlert(context);
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                  _pwrTimer.cancel();
                                  Future.delayed(
                                      const Duration(milliseconds: 230), () {
                                    _effectPlayer.dispose();
                                    // 우선 8포인트까지 존재하여 나머지 함수를 이용함
                                    showCountDownPopup(context, _mainStatusProvider.facilityNum![widget.number!]);
                                  });

                              });
                            }
                          }
                        },
                        child: const Center(
                          child: Text(
                            '안내',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            shape: LinearBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.white
                                ),
                                top: LinearBorderEdge(size: 1),
                              start: LinearBorderEdge(size: 1)
                            ),
                            fixedSize: const Size(370, 120)),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            Navigator.pop(context);
                          });
                        },
                        child: const Center(
                          child: Text(
                            '닫기',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   left: 0,
                //   top: 800,
                //   child: FilledButton(
                //     style: FilledButton.styleFrom(
                //         enableFeedback: false,
                //         backgroundColor: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(0)),
                //         fixedSize: const Size(370, 120)),
                //     onPressed: () {
                //       WidgetsBinding.instance.addPostFrameCallback((_) {
                //         _effectPlayer.seek(const Duration(seconds: 0));
                //         _effectPlayer.play();
                //         Navigator.pop(context);
                //       });
                //     },
                //     child: const Center(
                //       child: Text(
                //         '닫기',
                //         style: TextStyle(
                //             fontFamily: 'kor',
                //             fontSize: 35,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
