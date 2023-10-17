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

    countDownModalBtn = 'assets/images/modalIMG/btn.png';

    _mainStatusProvider.targetFacilityIndex = widget.number;

    return Container(
        padding: const EdgeInsets.only(top: 144),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 738,
              height: 441,
              decoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: Color(0xff4cffffff), width: 0.5)),
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [Color(0xff4e4e4e), Color(0xff444444)]
                )
              ),
              child: Stack(
                children: [Container(
                  margin: EdgeInsets.only(top: 36, left: 27),
                  height: 240,
                  width: 684,
                  child:Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${_mainStatusProvider.facilityNum![widget.number!]}',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              letterSpacing: -0.04
                            )),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(_mainStatusProvider.facilityName![widget.number!],
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.04
                            )),
                      ],
                    ),
                  )
                ),
                  Container(
                    width: 684,
                    height: 102,
                    margin: EdgeInsets.only(top: 312, left: 27),
                    child: Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              enableFeedback: false,
                              foregroundColor: Color(0xff222222),
                              backgroundColor: Color(0xffb3333333),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: TextStyle(

                              ),
                              fixedSize: const Size(336, 102)),
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
                          child: Text(
                            '로봇 길안내',
                            style: TextStyle(
                                color: Color(0xffffffff),
                                fontFamily: 'kor',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                            letterSpacing: -0.03),
                          ),
                        ),
                        SizedBox(width: 11,),
                        TextButton(
                          style: TextButton.styleFrom(
                              enableFeedback: false,
                              foregroundColor: Color(0xff222222),
                              backgroundColor: Color(0xffb3333333),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: TextStyle(

                              ),
                              fixedSize: const Size(336, 102)),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _timer.cancel();
                              Navigator.pop(context);
                            });
                          },
                          child: Center(
                            child: Text(
                              '지도안내',
                              style: TextStyle(
                                  color: Color(0xffffffff).withOpacity(0.7),
                                  fontFamily: 'kor',
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.03),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),

          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
