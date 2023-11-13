import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FacilityNavigationDone extends StatefulWidget {
  const FacilityNavigationDone({Key? key}) : super(key: key);

  @override
  State<FacilityNavigationDone> createState() =>
      _FacilityNavigationDoneState();
}

class _FacilityNavigationDoneState extends State<FacilityNavigationDone> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  // String backgroundImage = "assets/screens/Serving/koriZFinalReturn.png";
  String? startUrl;
  String? navUrl;

  late String extendLine;
  late String arrivedIcon;

  late bool audioOn1;

  late Timer _modalTimer;

  final CountdownController _controller = CountdownController(autoStart: true);
  late bool navDoneFlag;

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/KoriFacilityDone.wav';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extendLine = 'assets/images/facility/facNav/navDone/line_5.svg';
    arrivedIcon = 'assets/images/facility/facNav/navDone/frame.svg';

    navDoneFlag = true;

    _initAudio();

    audioOn1 = true;

    _modalTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (navDoneFlag == true) {
        if (_mainStatusProvider.facilityNavDone == true) {
          setState(() {
            _mainStatusProvider.facilityNavDoneScroll = true;
            navDoneFlag = false;
          });
        }
      }
    });

    Provider.of<MainStatusModel>(context, listen: false).lastFacilityNum = Provider.of<MainStatusModel>(context, listen: false).facilityNum![Provider.of<MainStatusModel>(context, listen: false).targetFacilityIndex!];
    Provider.of<MainStatusModel>(context, listen: false).lastFacilityName = Provider.of<MainStatusModel>(context, listen: false).facilityName![Provider.of<MainStatusModel>(context, listen: false).targetFacilityIndex!];
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
  }

  void showReturnCountDownPopup(context) {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;


    if(audioOn1 == true){
      if(_mainStatusProvider.facilityNavDone == true){
        _audioPlayer.seek(const Duration(seconds: 0));
        _audioPlayer.play();
        setState(() {
          audioOn1 = false;
        });
      }
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          Countdown(
            controller: _controller,
            seconds: 10,
            build: (_, double time) {
              if (_mainStatusProvider.facilityNavDone == true) {
                _controller.resume();
              } else {
                _controller.pause();
              }
              return Container();
            },
            interval: const Duration(seconds: 1),
            onFinished: () {
              Future.delayed(const Duration(milliseconds: 230), () {
                _audioPlayer.dispose();
                showReturnCountDownPopup(context);
              });
            },
          ),
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
                          image: DecorationImage(image: AssetImage('assets/images/facility/banners/${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]}.png'))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 114 * 3),
                    child: Column(
                      children: [
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]}호',
                            style: const TextStyle(
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
                            _mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!],
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                                letterSpacing: -0.24),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 4 * 3,
                        ),
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            _mainStatusProvider.facilityDetail![_mainStatusProvider.targetFacilityIndex!],
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 11 * 3,
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
          // 상태 안내
          Padding(
            padding: const EdgeInsets.only(top: 157 * 3, left: 28 * 3),
            child: Container(
              width: 315 * 3,
              height: 24 * 3,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5 * 3, bottom: 4 * 3),
                    child: Container(
                        // height: 15*3,
                        child: const Text(
                      '안내가 완료 되었습니다!',
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * 3,
                          letterSpacing: -0.24,
                          color: Color(0xffffffff),
                          height: 1.001),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: (11.8 - 1.75) * 3, left: 141 * 3),
                    child: Opacity(
                        opacity: 0.6,
                        child: SvgPicture.asset(
                          extendLine,
                          width: 105 * 3,
                          height: 4 * 3,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 248 * 3),
                    child: Container(
                      width: 67 * 3,
                      height: 24 * 3,
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(color: Color(0x99666666), width: 1.5)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5 * 3, left: 6.5 * 3),
                            child: SvgPicture.asset(
                              arrivedIcon,
                              width: 14 * 3,
                              height: 14 * 3,
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 4.5 * 3, left: 23.5 * 3),
                            child: Text(
                              '안내 완료',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 * 3,
                                  letterSpacing: -0.18,
                                  color: Color(0xffffffff),
                                  height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // 버튼
          Padding(
            padding: const EdgeInsets.only(top: 215 * 3, left: 17 * 3),
            child: SizedBox(
              width: 326 * 3,
              height: 34 * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // _controller.pause();
                          _audioPlayer.dispose();
                          if (_servingProvider.targetTableNum != 'none') {
                            _mainStatusProvider.robotReturning = true;
                            _servingProvider.trayChange = true;
                            _networkProvider.servTable =
                                _servingProvider.targetTableNum;
                            PostApi(
                                    url: startUrl,
                                    endadr: navUrl,
                                    keyBody: '시설1')
                                .Posting(context);
                          }
                          Future.delayed(const Duration(milliseconds: 230), () {
                            // _audioPlayer.dispose();
                            setState(() {
                              _mainStatusProvider.facilityNavDoneScroll = false;
                              _mainStatusProvider.facilityNavDone = false;
                              _mainStatusProvider.facilityArrived = false;
                            });
                          });
                        });
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor:
                              const Color(0xff000000).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Center(
                          child: Text(
                        '복귀',
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
                        _audioPlayer.dispose();
                        setState(() {
                          _mainStatusProvider.facilityNavDone = false;
                          _mainStatusProvider.facilityNavDoneScroll = false;
                        });
                        // _audioPlayer.dispose();
                        navPage(context: context, page: const FacilityScreen())
                            .navPageToPage();
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor: const Color(0xff5e5ce6),
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
