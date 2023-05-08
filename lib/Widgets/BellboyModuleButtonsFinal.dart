import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellboyDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/HotelModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyReturn.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellboyDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class BellboyModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const BellboyModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<BellboyModuleButtonsFinal> createState() =>
      _BellboyModuleButtonsFinalState();
}

class _BellboyModuleButtonsFinalState extends State<BellboyModuleButtonsFinal> {
  late HotelModel _hotelProvider;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late int buttonNumbers = 0;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String? currentNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentNum = "";
  }

  void showDestinationListPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const BellboyDestinationListModalFinal();
        });
  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const NavCountDownModalFinal();
        });
  }

  // 목적지 미입력 시 알람
  void showGoalFalsePopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 270),
            child: AlertDialog(
              content: const SizedBox(
                width: 670,
                height: 210,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('목적지를 입력 해 주세요.'),
                  ],
                ),
              ),
              backgroundColor: const Color(0xff191919),
              contentTextStyle: Theme.of(context).textTheme.headlineLarge,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color(0xFFB7B7B7),
                    style: BorderStyle.solid,
                    width: 1,
                  )),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xff797979),
                          shape: const LinearBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              top: LinearBorderEdge(size: 1)),
                          minimumSize: const Size(670, 120)),
                      child: Text(
                        '확인',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _hotelProvider = Provider.of<HotelModel>(context, listen: false);

    if (widget.screens == 0) {
      // 벨보이 메인 화면
      buttonPositionWidth = [104];
      buttonPositionHeight = [1378];

      buttonSize = [870, 160];

      buttonRadius = 40;
    } else if (widget.screens == 1) {
      // 키패드 화면
      buttonPositionWidth = [
        115,
        409,
        703,
        115,
        409,
        703,
        115,
        409,
        703,
        115,
        409,
        703
      ];
      buttonPositionHeight = [
        521,
        521,
        521,
        813,
        813,
        813,
        1104,
        1104,
        1104,
        1394,
        1394,
        1394
      ];

      buttonSize = [261, 258];

      buttonRadius = 37;
    } else if (widget.screens == 2) {
      // 목적지 리스트
      buttonPositionWidth = [77, 525, 79, 525, 79, 525, 79];
      buttonPositionHeight = [1286, 303, 303, 550, 550, 797, 797];

      buttonSize = [];

      buttonSize1 = [847, 158];
      buttonSize2 = [400, 210];

      buttonRadius = 40;
    } else if (widget.screens == 3) {
      // 도착 화면
      buttonPositionWidth = [107];
      buttonPositionHeight = [1376];

      buttonSize = [866, 160];

      buttonRadius = 50;
    }

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      (currentNum == null && widget.screens == 1)
          ? Container()
          // 키패드 입력 호수 표시
          : widget.screens == 1
              ? Positioned(
                  top: 217.5,
                  left: 323.25,
                  width: 355,
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$currentNum',
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 150,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff)),
                      ),
                    ],
                  ),
                )
              : Container(),
      // 키패드 입력 호수 초기화 버튼
      widget.screens == 1
          ? Positioned(
              left: 1213 * 0.75,
              top: 451 * 0.75,
              child: Container(
                width: 60,
                height: 60,
                color: Colors.transparent,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        // side: BorderSide(width: 1, color: Colors.white)
                      )),
                  onPressed: () {
                    setState(() {
                      currentNum = "";
                    });
                  },
                  child: null,
                ),
              ))
          : Container(),
      for (int i = 0; i < buttonNumbers; i++)
        Positioned(
          left: buttonPositionWidth[i],
          top: buttonPositionHeight[i],
          child: FilledButton(
            style: FilledButton.styleFrom(
                foregroundColor: widget.screens == 1
                    ? i != 9
                        ? i != 11
                            ? Colors.tealAccent
                            : null
                        : null
                    : null,
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius)),
                fixedSize: widget.screens == 2
                    ? i == 0
                        ? Size(
                            buttonSize1[buttonWidth], buttonSize1[buttonHeight])
                        : Size(
                            buttonSize2[buttonWidth], buttonSize2[buttonHeight])
                    : Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
                    if (_hotelProvider.bellboyTF == true) {
                      showCountDownPopup(context);
                    } else {
                      navPage(
                              context: context,
                              page: const BellboyDestinationScreenFinal(),
                              enablePop: true)
                          .navPageToPage();
                    }
                  }
                : widget.screens == 1
                    ? () {
                        setState(() {
                          // 호실 자릿수
                          if (currentNum!.length < 4) {
                            if (i < 9) {
                              currentNum = '$currentNum${i + 1}';
                            }
                          }
                        });
                        if (i == 9) {
                          showDestinationListPopup(context);
                        } else if (i == 10) {
                          currentNum = '${currentNum}0';
                        } else if (i == 11) {
                          if (currentNum == "") {
                            showGoalFalsePopup(context);
                          } else {
                            showCountDownPopup(context);
                          }
                        }
                      }
                    : widget.screens == 2
                        ? () {
                            showCountDownPopup(context);
                          }
                        : widget.screens == 3
                            ? () {
                                setState(() {
                                  _hotelProvider.bellboyTF = false;
                                });
                                navPage(
                                        context: context,
                                        page: const BellboyReturnModuleFinal(),
                                        enablePop: false)
                                    .navPageToPage();
                              }
                            : null,
            child: null,
          ),
        ),
    ]);
  }
}
