import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class ShippingDestinationNewFinal extends StatefulWidget {
  const ShippingDestinationNewFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ShippingDestinationNewFinal> createState() =>
      _ShippingDestinationNewFinalState();
}

class _ShippingDestinationNewFinalState
    extends State<ShippingDestinationNewFinal> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;


  String shippingKeyPadIMG =
      "assets/screens/Shipping/koriZFinalShippingDestinations.png";

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
            serviceMode: 'Shipping',
          );
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
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    goalPositionList = _networkProvider.getPoseData!;

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    chgUrl = _networkProvider.chgUrl;

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

    buttonNumbers = buttonPositionHeight.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          mounted == true
              ? const SizedBox(
                  width: 1080,
                  height: 108,
                  child: Stack(
                    children: [
                      AppBarStatus(),
                      AppBarAction(
                        homeButton: true,
                        screenName: 'Shipping',
                      )
                    ],
                  ),
                )
              : Container()
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(shippingKeyPadIMG), fit: BoxFit.cover)),
        child: Stack(
          children: [
            const Positioned(
              top: 278,
              left: 700,
              child: Text(
                '호',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff)),
              ),
            ),
            Positioned(
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
            ),
            Positioned(
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
                )),
            for (int i = 0; i < buttonNumbers; i++)
              Positioned(
                left: buttonPositionWidth[i],
                top: buttonPositionHeight[i],
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      foregroundColor: i != 9
                          ? i != 11
                              ? Colors.tealAccent
                              : null
                          : null,
                      splashFactory:
                          InkSparkle.constantTurbulenceSeedSplashFactory,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(buttonRadius)),
                      fixedSize: Size(
                          buttonSize[buttonWidth], buttonSize[buttonHeight])),
                  onPressed: () {
                    setState(() {
                      // 호실 자릿수
                      if (currentNum!.length < 4) {
                        if (i < 9) {
                          currentNum = '$currentNum${i + 1}';
                        }
                      }
                    });
                    if (i == 9) {
                      // showDestinationListPopup(context);
                    } else if (i == 10) {
                      currentNum = '${currentNum}0';
                    } else if (i == 11) {
                      setState(() {
                        _mainStatusProvider.targetRoomNum = currentNum;
                      });
                      if (currentNum == "101") {
                        setGoalPose(0);
                      } else if (currentNum == "102") {
                        setGoalPose(1);
                      } else if (currentNum == "201") {
                        setGoalPose(2);
                      } else if (currentNum == "202") {
                        setGoalPose(3);
                      } else if (currentNum == "301") {
                        setGoalPose(4);
                      } else if (currentNum == "302") {
                        setGoalPose(5);
                      } else if (currentNum == "401") {
                        setGoalPose(6);
                      } else if (currentNum == "402") {
                        setGoalPose(7);
                      } else {
                        showGoalFalsePopup(context);
                      }
                    }
                  },
                  child: null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
