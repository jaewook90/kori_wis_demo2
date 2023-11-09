import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class EMGStateModalScreen extends StatefulWidget {
  const EMGStateModalScreen({Key? key}) : super(key: key);

  @override
  State<EMGStateModalScreen> createState() => _EMGStateModalScreenState();
}

class _EMGStateModalScreenState extends State<EMGStateModalScreen> {
  late MainStatusModel _mainStatusProvider;

  final CountdownController _controller = CountdownController(autoStart: true);

  final String EmgStatusBG = 'assets/images/emgStatusDim.svg';
  final String EmgStatusClose = 'assets/icons/appBar/btn_close.svg';
  late String modalIcon;
  late Timer _pwrTimer;
  late int EMGStatus;

  late String emgText1;
  late String emgText2;
  late String emgText3;

  late bool EMGbtnPush;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EMGbtnPush = true;
    emgText1 = '비상정지 모드가 활성화 되었습니다.';
    emgText2 = '본 모드는 위급 시 로봇의 움직임을 즉시 멈추게 합니다.';
    emgText3 = '로봇은 더 이상 움직이지 않습니다.';

    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      EMGStatus =
          Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (EMGStatus != 0) {
      setState(() {
        _controller.restart();
        EMGbtnPush = false;
        modalIcon = 'assets/icons/appBar/icon_stop_c.svg';
        emgText1 = '자율 주행모드가 활성화되었습니다.';
        emgText2 = '이제 로봇의 움직임을 제어하여 자율주행을 시작합니다.';
        emgText3 = '위험 발생 시 비상정지 버튼을 눌러주세요.';
      });
    } else {
      setState(() {
        _controller.restart();
        EMGbtnPush = true;
        modalIcon = 'assets/icons/appBar/icon_stop.svg';
        emgText1 = '비상정지 모드가 활성화 되었습니다.';
        emgText2 = '본 모드는 위급 시 로봇의 움직임을 즉시 멈추게 합니다.';
        emgText3 = '로봇은 더 이상 움직이지 않습니다.';
      });
    }
    return Container(
      width: 1080,
      height: 1920,
      child: Stack(children: [
        Countdown(
          controller: _controller,
          seconds: 5,
          build: (_, double time) {
            return Container();
          },
          interval: const Duration(seconds: 1),
          onFinished: () {
            setState(() {
              _mainStatusProvider.EMGModalChange = false;
              Navigator.pop(context);
            });
          },
        ),
        Opacity(
            opacity: 0.4,
            child: SvgPicture.asset(EmgStatusBG, width: 1080, height: 1920)),
        Padding(
          padding: const EdgeInsets.only(top: 14 * 3, left: 17 * 3),
          child: Container(
            width: 326 * 3,
            height: 120 * 3,
            decoration: BoxDecoration(
                color: Color(0xff323232),
                borderRadius: BorderRadius.circular(4 * 3),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x99000000),
                    spreadRadius: 0,
                    blurRadius: 15*3,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10 * 3, left: 149 * 3),
                  child: SvgPicture.asset(
                    modalIcon,
                    width: 28 * 3,
                    height: 28 * 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50 * 3, left: 33 * 3),
                  child: Container(
                    width: 260 * 3,
                    height: 54 * 3,
                    child: Column(
                      children: [
                        Text(
                          emgText1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 12 * 3,
                              letterSpacing: -0.4 * 3,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffffffff)),
                        ),
                        Text(
                          emgText2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 12 * 3,
                              letterSpacing: -0.4 * 3,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffffffff)),
                        ),
                        Text(
                          emgText3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 12 * 3,
                              letterSpacing: -0.4 * 3,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffffffff)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8 * 3, left: 300 * 3),
                  child: Container(
                    width: 18 * 3,
                    height: 18 * 3,
                    child: Stack(children: [
                      SvgPicture.asset(EmgStatusClose,
                          width: 18 * 3, height: 18 * 3, fit: BoxFit.cover),
                      FilledButton(
                          style: FilledButton.styleFrom(
                            fixedSize: Size(18 * 3, 18 * 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            _mainStatusProvider.EMGModalChange = false;
                            _controller.pause();
                            Navigator.pop(context);
                          },
                          child: null),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
