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

  late String countDownModalBg;
  late String countDownModalBtn;

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();

    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;

    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      });
    }

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
    _pwrTimer.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    countDownModalBg = 'assets/images/modalIMG/bg.png';
    countDownModalBtn = 'assets/images/modalIMG/btn.png';

    _mainStatusProvider.targetFacilityIndex = widget.number;

    return Container(
        // padding: const EdgeInsets.only(top: 588),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Center(
              child: Container(
                width: 828,
                height: 531,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(countDownModalBg), fit: BoxFit.fill)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 35),
                      height: 320,
                      width: 828,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Container(
                            margin: EdgeInsets.all(6),
                            width: 640,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${_mainStatusProvider.facilityNum![widget.number!]}',
                                    style: TextStyle(
                                        fontFamily: 'kor',
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2)),
                                const SizedBox(
                                  width: 110,
                                ),
                                Text(_mainStatusProvider.facilityName![widget.number!],
                                    style: TextStyle(
                                        fontFamily: 'kor',
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2)),

                                SizedBox(width: 15,),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          width: 336,
                          height: 102,
                          decoration: BoxDecoration(
                            // border: Border.fromBorderSide(
                            //     BorderSide(width: 5, color: Colors.tealAccent)),
                              image: DecorationImage(
                                  image: AssetImage(countDownModalBtn), fit: BoxFit.fill)),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                enableFeedback: false,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                fixedSize: const Size(370, 120)),
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                _timer.cancel();
                                Navigator.pop(context);
                              });
                            },
                            child: const Center(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 0.7),
                                    height: 1.2,
                                    fontFamily: 'kor',
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 50),
                          width: 336,
                          height: 102,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(countDownModalBtn), fit: BoxFit.fill)),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                enableFeedback: false,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
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
                                    _timer.cancel();
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
                                '시작',
                                style: TextStyle(
                                    color: Color.fromRGBO(238, 238, 238, 0.7),
                                    height: 1.2,
                                    fontFamily: 'kor',
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
