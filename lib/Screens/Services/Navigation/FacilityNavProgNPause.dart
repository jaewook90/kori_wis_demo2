import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class FacilityNavigationProgNPause extends StatefulWidget {
  const FacilityNavigationProgNPause({Key? key}) : super(key: key);

  @override
  State<FacilityNavigationProgNPause> createState() =>
      _FacilityNavigationProgNPauseState();
}

class _FacilityNavigationProgNPauseState
    extends State<FacilityNavigationProgNPause> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;

  final String _effectFile = 'assets/sounds/button_click.wav';
  late String navTopDivider;
  final String navTopDestinationIcon =
      'assets/images/facility/facNav/frame_50.svg';
  late String navTopTextBoxIcon;
  final String navTopSubBTNBG = 'assets/images/facility/facNav/frame_66.svg';
  final String navTopSubBTNBatIcon = 'assets/images/facility/facNav/icon.svg';
  final String navTopSubBTNChangeIcon =
      'assets/images/facility/facNav/frame_56.svg';
  final String navTopSubBTNReturnIcon =
      'assets/images/facility/facNav/frame.svg';

  // parameters
  late double subButtonOpacity;
  late bool navState;
  late double navTopDividerWidth;
  late double navTopStateBoxWidth;
  late double navTopStateBoxHeight;
  late double navTopStateBoxPaddingLeft;
  late double navTopTextBoxIconSize;
  late double navTopTextBoxIconPaddingTop;
  late double navTopTextBoxTextPaddingLeft;
  late Color navTopTextBoxTextColor;
  late String navTopTextBoxText;

  // for function

  late Timer _modalTimer;

  late String targetTableNum;
  late String servTableNum;

  late String destinationSentence;
  late String departureSentence;

  String? startUrl;
  String? navUrl;
  String? stpUrl;
  String? rsmUrl;
  String? chgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navTopDivider = 'assets/images/facility/facNav/line_4.svg';
    navTopTextBoxIcon = 'assets/images/facility/facNav/frame_2.svg';
    navState = true;
    subButtonOpacity = 0.2;
    navTopDividerWidth = 235 * 3;
    navTopStateBoxWidth = 56 * 3;
    navTopStateBoxHeight = 24 * 3;
    navTopStateBoxPaddingLeft = 267 * 3;
    navTopTextBoxIconSize = 12;
    navTopTextBoxIconPaddingTop = 6 * 3;
    navTopTextBoxTextPaddingLeft = 22.5 * 3;
    navTopTextBoxTextColor = const Color(0xff00d7d4);
    navTopTextBoxText = '이동중';

    targetTableNum = "";
    destinationSentence = '';
    departureSentence = '';

    _modalTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_networkProvider.servTable == '시설1') {
        setState(() {});
      }
    });

    _initAudio();
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
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
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    chgUrl = _networkProvider.chgUrl;

    servTableNum = _networkProvider.servTable!;

    if (_mainStatusProvider.lastFacilityNum!.isEmpty ||
        _mainStatusProvider.lastFacilityName!.isEmpty) {
      setState(() {
        departureSentence = '엘리베이터';
      });
    } else {
      setState(() {
        departureSentence =
            '[${_mainStatusProvider.lastFacilityNum!} 호] ${_mainStatusProvider.lastFacilityName!}';
      });
    }

    if (servTableNum == 'charging_pile') {
      setState(() {
        destinationSentence = '충전스테이션';
      });
    } else if (servTableNum == '시설1') {
      if (_mainStatusProvider.robotReturning == true) {
        setState(() {
          destinationSentence = '대기장소';
        });
      } else {
        setState(() {
          destinationSentence =
              '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
        });
      }
    } else {
      setState(() {
        destinationSentence =
            '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
      });
    }

    // servTableNum = 'asdf';

    targetTableNum = '시설1';

    _servingProvider.targetTableNum = targetTableNum;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          // 주행 정보 묶음 출발지, 도착지, 이동상태
          Padding(
            padding: const EdgeInsets.only(top: 72 * 3, left: 20 * 3),
            child: SizedBox(
              width: 323 * 3,
              height: 75 * 3,
              child: Stack(
                children: [
                  // 출발지
                  SizedBox(
                    width: (28 + 224) * 3,
                    height: 18 * 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 14 * 3,
                          height: 14 * 3,
                          child: Icon(Icons.trip_origin,
                              color: Color(0xff00d7d4), size: 14 * 3),
                        ),
                        const SizedBox(
                          width: 14 * 3,
                        ),
                        Text(
                          departureSentence,
                          style: const TextStyle(
                              fontFamily: 'kor',
                              fontSize: 14 * 3,
                              letterSpacing: (-0.24),
                              height: 0.85,
                              color: Color(0xffffffff)),
                          // textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  // 디바이더 => 이동/정지 상태에 따라 길이 조절
                  Padding(
                    padding: const EdgeInsets.only(
                        top: (34.8 - 0.75) * 3, left: 22 * 3),
                    child: SvgPicture.asset(navTopDivider,
                        width: navTopDividerWidth, height: 4 * 3),
                  ),
                  // 도착지
                  Padding(
                    padding: const EdgeInsets.only(top: 57 * 3),
                    child: SizedBox(
                      width: (28 + 224) * 3,
                      height: 18 * 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            navTopDestinationIcon,
                            width: 14 * 3,
                            height: 18 * 3,
                          ),
                          const SizedBox(
                            width: 14 * 3,
                          ),
                          Text(
                            destinationSentence,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                letterSpacing: (-0.24),
                                height: 0.85,
                                color: Color(0xffffffff)),
                            // textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  // 주행 상태 표기 => 이동/일시정지에 따른 값 변경 있음
                  Padding(
                    padding: EdgeInsets.only(
                        top: 23 * 3, left: navTopStateBoxPaddingLeft),
                    child: Container(
                      width: navTopStateBoxWidth,
                      height: navTopStateBoxHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4 * 3),
                          border: const Border.fromBorderSide(BorderSide(
                              width: 1.5, color: Color(0x99666666)))),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: navTopTextBoxIconPaddingTop,
                                left: 7.5 * 3),
                            child: SvgPicture.asset(
                              navTopTextBoxIcon,
                              width: navTopTextBoxIconSize * 3,
                              height: navTopTextBoxIconSize * 3,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 4.5 * 3,
                                left: navTopTextBoxTextPaddingLeft),
                            child: Text(
                              navTopTextBoxText,
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 30,
                                  letterSpacing: -0.18,
                                  color: navTopTextBoxTextColor,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3),
                              textAlign: TextAlign.center,
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
          // 서브 버튼 => 이동 / 정지에 따른 값 변화 있음
          Padding(
            padding: const EdgeInsets.only(top: 175 * 3, left: 17 * 3),
            child: SizedBox(
              width: 325 * 3,
              height: 32 * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 103 * 3,
                    height: 32 * 3,
                    child: Opacity(
                      opacity: subButtonOpacity,
                      child: Stack(
                        children: [
                          SvgPicture.asset(navTopSubBTNBG,
                              width: 103 * 3, height: 32 * 3),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8 * 3, left: 30 * 3),
                            child: SizedBox(
                              width: 44 * 3,
                              height: 16 * 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(navTopSubBTNBatIcon,
                                      width: 16 * 3, height: 16 * 3),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 22 * 3,
                                    height: 14 * 3,
                                    child: Text(
                                      '충전',
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12 * 3,
                                          letterSpacing: -0.21,
                                          height: 0.95),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: navState,
                            child: FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    PostApi(
                                            url: startUrl,
                                            endadr: chgUrl,
                                            keyBody: 'charging_pile')
                                        .Posting(context);
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      setState(() {
                                        _networkProvider.currentGoal = '충전스테이션';
                                        _networkProvider.servTable =
                                            'charging_pile';
                                        navTopDivider =
                                            'assets/images/facility/facNav/line_4.svg';
                                        navTopTextBoxIcon =
                                            'assets/images/facility/facNav/frame_2.svg';
                                        navState = true;
                                        subButtonOpacity = 0.2;
                                        navTopDividerWidth = 235 * 3;
                                        navTopStateBoxWidth = 56 * 3;
                                        navTopStateBoxHeight = 24 * 3;
                                        navTopStateBoxPaddingLeft = 267 * 3;
                                        navTopTextBoxIconSize = 12;
                                        navTopTextBoxIconPaddingTop = 6 * 3;
                                        navTopTextBoxTextPaddingLeft = 22.5 * 3;
                                        navTopTextBoxTextColor =
                                            const Color(0xff00d7d4);
                                        navTopTextBoxText = '이동중';
                                      });
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: const Size(103 * 3, 32 * 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      // side: BorderSide(
                                      //     color: Colors.tealAccent, width: 1)
                                    )),
                                child: null),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 103 * 3,
                    height: 32 * 3,
                    child: Opacity(
                      opacity: subButtonOpacity,
                      child: Stack(
                        children: [
                          SvgPicture.asset(navTopSubBTNBG,
                              width: 103 * 3, height: 32 * 3),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8 * 3, left: 13 * 3),
                            child: SizedBox(
                              width: 77 * 3,
                              height: 16 * 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      width: 16 * 3,
                                      height: 16 * 3,
                                      child: Center(
                                          child: SvgPicture.asset(
                                              navTopSubBTNChangeIcon,
                                              width: 14 * 3,
                                              height: 14 * 3))),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  const SizedBox(
                                    width: 58 * 3,
                                    height: 14 * 3,
                                    child: Text(
                                      '목적지 변경',
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12 * 3,
                                          letterSpacing: -0.21,
                                          height: 0.95),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: navState,
                            child: FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      _effectPlayer.dispose();
                                      if (_mainStatusProvider
                                              .robotServiceMode ==
                                          2) {
                                        navPage(
                                          context: context,
                                          page: const FacilityScreen(),
                                        ).navPageToPage();
                                      }
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: const Size(103 * 3, 32 * 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      // side: BorderSide(
                                      //     color: Colors.tealAccent, width: 1)
                                    )),
                                child: null),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 103 * 3,
                    height: 32 * 3,
                    child: Opacity(
                      opacity: subButtonOpacity,
                      child: Stack(
                        children: [
                          SvgPicture.asset(navTopSubBTNBG,
                              width: 103 * 3, height: 32 * 3),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8 * 3, left: 30 * 3),
                            child: SizedBox(
                              width: 44 * 3,
                              height: 16 * 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(navTopSubBTNReturnIcon,
                                      width: 16 * 3, height: 16 * 3),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 22 * 3,
                                    height: 14 * 3,
                                    child: Text(
                                      '복귀',
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12 * 3,
                                          letterSpacing: -0.21,
                                          height: 0.95),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: navState,
                            child: FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    _mainStatusProvider.robotReturning = true;
                                    PostApi(
                                            url: startUrl,
                                            endadr: navUrl,
                                            keyBody: '시설1')
                                        .Posting(context);
                                    _networkProvider.servTable = '시설1';
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      setState(() {
                                        _networkProvider.currentGoal = '충전스테이션';
                                        _networkProvider.servTable =
                                            'charging_pile';
                                        navTopDivider =
                                            'assets/images/facility/facNav/line_4.svg';
                                        navTopTextBoxIcon =
                                            'assets/images/facility/facNav/frame_2.svg';
                                        navState = true;
                                        subButtonOpacity = 0.2;
                                        navTopDividerWidth = 235 * 3;
                                        navTopStateBoxWidth = 56 * 3;
                                        navTopStateBoxHeight = 24 * 3;
                                        navTopStateBoxPaddingLeft = 267 * 3;
                                        navTopTextBoxIconSize = 12;
                                        navTopTextBoxIconPaddingTop = 6 * 3;
                                        navTopTextBoxTextPaddingLeft = 22.5 * 3;
                                        navTopTextBoxTextColor =
                                            const Color(0xff00d7d4);
                                        navTopTextBoxText = '이동중';
                                      });
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: const Size(103 * 3, 32 * 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      // side: BorderSide(
                                      //     color: Colors.tealAccent, width: 1)
                                    )),
                                child: null),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // 메인 버튼
          Offstage(
            offstage: !navState,
            child: Padding(
              padding: const EdgeInsets.only(top: 215 * 3, left: 17 * 3),
              child: SizedBox(
                width: 326 * 3,
                height: 34 * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          navPage(
                                  context: context,
                                  page: const FacilityScreen())
                              .navPageToPage();
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(159 * 3, 34 * 3),
                            backgroundColor:
                                const Color(0xff000000).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Center(
                            child: Text(
                          '취소',
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
                            PostApi(
                                    url: startUrl,
                                    endadr: stpUrl,
                                    keyBody: 'stop')
                                .Posting(context);
                            Future.delayed(const Duration(milliseconds: 230),
                                () {
                              setState(() {
                                navState = false;
                                subButtonOpacity = 1;
                                navTopDividerWidth = 224 * 3;
                                navTopDivider =
                                    'assets/images/facility/facNav/line_3.svg';
                                navTopStateBoxWidth = 67 * 3;
                                navTopStateBoxHeight = 24 * 3;
                                navTopStateBoxPaddingLeft = 256 * 3;
                                navTopTextBoxIcon =
                                    'assets/images/facility/facNav/navPauseIcon.svg';
                                navTopTextBoxIconSize = 14;
                                navTopTextBoxIconPaddingTop = 5 * 3;
                                navTopTextBoxTextPaddingLeft = 24.5 * 3;
                                navTopTextBoxTextColor =
                                    const Color(0xffffffff);
                                navTopTextBoxText = '일시정지';
                                _mainStatusProvider.facilityNavPause = true;
                              });
                            });
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(159 * 3, 34 * 3),
                            backgroundColor: const Color(0xffff453a),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Center(
                            child: Text(
                          '일시정지',
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
          ),
          Offstage(
            offstage: navState,
            child: Padding(
              padding: const EdgeInsets.only(top: 215 * 3, left: 17 * 3),
              child: SizedBox(
                width: 326 * 3,
                height: 34 * 3,
                child: TextButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        PostApi(url: startUrl, endadr: rsmUrl, keyBody: 'stop')
                            .Posting(context);
                        Future.delayed(const Duration(milliseconds: 230), () {
                          setState(() {
                            navTopDivider =
                                'assets/images/facility/facNav/line_4.svg';
                            navTopTextBoxIcon =
                                'assets/images/facility/facNav/frame_2.svg';
                            navState = true;
                            subButtonOpacity = 0.2;
                            navTopDividerWidth = 235 * 3;
                            navTopStateBoxWidth = 56 * 3;
                            navTopStateBoxHeight = 24 * 3;
                            navTopStateBoxPaddingLeft = 267 * 3;
                            navTopTextBoxIconSize = 12;
                            navTopTextBoxIconPaddingTop = 6 * 3;
                            navTopTextBoxTextPaddingLeft = 22.5 * 3;
                            navTopTextBoxTextColor = const Color(0xff00d7d4);
                            navTopTextBoxText = '이동중';
                            _mainStatusProvider.facilityNavPause = false;
                          });
                        });
                      });
                    },
                    style: TextButton.styleFrom(
                        fixedSize: const Size(326 * 3, 34 * 3),
                        backgroundColor: const Color(0xff0a84ff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Center(
                        child: Text(
                      '계속 이동',
                      style: TextStyle(
                        fontFamily: 'kor',
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * 3,
                      ),
                      textAlign: TextAlign.center,
                    ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
