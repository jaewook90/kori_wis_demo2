import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/ShippingDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class ShippingModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const ShippingModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<ShippingModuleButtonsFinal> createState() =>
      _ShippingModuleButtonsFinalState();
}

class _ShippingModuleButtonsFinalState
    extends State<ShippingModuleButtonsFinal> {
  late NetworkModel _networkProvider;

  // API 통신에서 불러오는 변수 목록
  // 키패드 호실 설정
  String? currentNum;

  String? goalPosition;

  String? startUrl;
  String? chgUrl;
  String? stpUrl;

  late var goalPositionList = List<String>.empty();

  // 버튼 파라미터
  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late int buttonNumbers = 0;

  int buttonWidth = 0;
  int buttonHeight = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentNum = "";
  }

  void showCountDownStarting(context, goalPosition) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal(
            goalPosition: goalPosition,
          );
        });
  }

  void showDestinationListPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ShippingDestinationModalFinal();
        });
  }

  // 목적지 미입력 혹은 오입력 시 알람
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
                    Text('목적지를 잘못 입력하였습니다.'),
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

  void setGoalPose(int poseNum) {
    goalPosition = goalPositionList[poseNum];
    // print(goalPosition);
    showCountDownStarting(context, goalPosition);
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    goalPositionList = _networkProvider.getPoseData!;

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    chgUrl = _networkProvider.chgUrl;

    if (widget.screens == 0) {
      // 택배 메인 화면
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
      buttonPositionWidth = [79, 525, 79, 525, 79, 525, 79];
      buttonPositionHeight = [303, 303, 550, 550, 797, 797, 1287];

      buttonSize = [];

      buttonSize1 = [847, 157];
      buttonSize2 = [400, 214];

      buttonRadius = 50;
    } else if (widget.screens == 3) {
      // 도착 화면
      buttonPositionWidth = [107];
      buttonPositionHeight = [1372];

      buttonSize = [866, 174];

      buttonRadius = 40;
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
                    // side: BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(buttonRadius)),
                fixedSize: widget.screens == 2
                    ? i != 6
                        ? Size(
                            buttonSize2[buttonWidth], buttonSize2[buttonHeight])
                        : Size(
                            buttonSize1[buttonWidth], buttonSize1[buttonHeight])
                    : Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
              PostApi(
                  url: startUrl,
                  endadr: stpUrl,
                  keyBody: 'charging_pile')
                  .Posting(context);
                    navPage(
                            context: context,
                            page: const ShippingDestinationNewFinal(),
                            enablePop: true)
                        .navPageToPage();
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
                          if (currentNum == "101") {
                            setGoalPose(1);
                          } else if (currentNum == "102") {
                            setGoalPose(2);
                          } else if (currentNum == "201") {
                            setGoalPose(3);
                          } else if (currentNum == "202") {
                            setGoalPose(4);
                          } else if (currentNum == "301") {
                            setGoalPose(5);
                          } else if (currentNum == "302") {
                            setGoalPose(6);
                          } else if (currentNum == "0") {
                            setGoalPose(0);
                          } else {
                            showGoalFalsePopup(context);
                          }
                        }
                      }
                    : widget.screens == 2
                        ? () {
                            if (i == 0) {
                              setGoalPose(i + 1);
                            } else if (i == 1) {
                              setGoalPose(i + 1);
                            } else if (i == 2) {
                              setGoalPose(i + 1);
                            } else if (i == 3) {
                              setGoalPose(i + 1);
                            } else if (i == 4) {
                              setGoalPose(i + 1);
                            } else if (i == 5) {
                              setGoalPose(i + 1);
                            } else if (i == 6) {
                              setGoalPose(0);
                            }
                          }
                        : widget.screens == 3
                            ? () {
                                PostApi(
                                        url: startUrl,
                                        endadr: chgUrl,
                                        keyBody: 'charging_pile')
                                    .Posting(context);
                                navPage(
                                        context: context,
                                        page: const ShippingMenuFinal(),
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
