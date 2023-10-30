import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/CableConnectedModalFinal.dart';
import 'package:kori_wis_demo/Modals/EMGPopModalFinal.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavNew.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavProgNPauseNew.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FacilitySelection extends StatefulWidget {
  final int? number;
  const FacilitySelection({Key? key, this.number}) : super(key: key);

  @override
  State<FacilitySelection> createState() =>
      _FacilitySelectionState();
}

class _FacilitySelectionState extends State<FacilitySelection> {
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late Timer _pwrTimer;

  String? startUrl;
  String? navUrl;

  late int CHGFlag;
  late int EMGStatus;

  // late String officePic;

  // late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();

    // officePic = 'assets/images/facility/facNav/navDone/image.png';

    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;

    // if (mounted) {
    //   _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Navigator.pop(context);
    //     });
    //   });
    // }

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
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    _mainStatusProvider.targetFacilityIndex = widget.number;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          // Container(
          //   width: 360*3,
          //   height: 181*3,
          //     decoration: BoxDecoration(
          //         border: Border.fromBorderSide(BorderSide(color: Color(0xff4cffffff), width: 0.5)),
          //         borderRadius: BorderRadius.circular(15),
          //         gradient: LinearGradient(
          //             begin: Alignment.bottomCenter,
          //             end: Alignment.topCenter,
          //             colors: [Color(0x00ffffff), Color(0x66ffffff)]
          //         )
          //     )
          // ),
          // 도착 장소 정보창
          Padding(
            padding: const EdgeInsets.only(top: 59 * 3, left: 17 * 3),
            child: Container(
              width: 280 * 3,
              height: 62 * 3,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2 * 3),
                    child: Container(
                      width: 103 * 3,
                      height: 59 * 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/facility/banners/${_mainStatusProvider.facilityNum![widget.number!]}.png'))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 114 * 3),
                    child: Column(
                      children: [
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '${_mainStatusProvider.facilityNum![widget.number!]}호',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                                letterSpacing: -0.24),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            _mainStatusProvider.facilityName![widget.number!],
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                                letterSpacing: -0.24),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 4 * 3,
                        ),
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '업종 추가 추후',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 12 * 3,
                                fontWeight: FontWeight.w100,
                                color: Color(0xffffffff),
                                letterSpacing: -0.21),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 버튼
          Padding(
            padding: const EdgeInsets.only(top: 130 * 3, left: 17 * 3),
            child: SizedBox(
              width: 326 * 3,
              height: 34 * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
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
                              // _timer.cancel();
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
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor:
                          const Color(0xff000000).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Center(
                          child: Text(
                            '로봇 길안내',
                            style: TextStyle(
                              fontFamily: 'kor',
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * 3,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                  TextButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          _pwrTimer.cancel();
                          // _timer.cancel();
                          Future.delayed(
                              const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            // 우선 8포인트까지 존재하여 나머지 함수를 이용함
                            // Navigator.pop(context);
                            setState(() {
                              _mainStatusProvider.facilityOfficeSelected=false;
                            });
                          });
                        });
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor: const Color(0xff000000).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Center(
                          child: Text(
                            '새로운 안내',
                            style: TextStyle(
                              fontFamily: 'kor',
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * 3,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
