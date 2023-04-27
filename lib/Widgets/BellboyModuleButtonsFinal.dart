import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellboyDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
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
  late NetworkModel _networkProvider;

  late ServingModel _servingProvider;
  late OrderModel _orderProvider;

  late var screenList = List<Widget>.empty();
  late var serviceList = List<Widget>.empty();

  late var homeButtonName = List<String>.empty();

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

  String? startUrl;
  String? navUrl;

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
          return BellboyDestinationListModalFinal();
        });
  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

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
        520.5,
        520.5,
        520.5,
        810,
        810,
        810,
        1101,
        1101,
        1101,
        1394,
        1394,
        1394
      ];

      buttonSize = [263, 260];

      buttonRadius = 40;
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
      // buttonPositionWidth = [107];
      // buttonPositionHeight = [1376];
      //
      // buttonSize = [866, 160];
      //
      // buttonRadius = 50;
    } else if (widget.screens == 4) {
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
          : widget.screens == 1 ?Positioned(
        top: 220,
        left: 400,
        width: 270,
        height: 180,
        child: Text(
          '$currentNum',
          style: TextStyle(
              fontFamily: 'kor',
              fontSize: 150,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        ),
      ) : Container(),
      widget.screens == 1
          ? Positioned(
          left: 909,
          top: 338,
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
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius:
                    BorderRadius.circular(buttonRadius)),
                fixedSize:
                // Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
                widget.screens == 2
                    ? i == 0
                    ? Size(buttonSize1[buttonWidth],
                    buttonSize1[buttonHeight])
                    : Size(buttonSize2[buttonWidth],
                    buttonSize2[buttonHeight])
                    : Size(
                    buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
              if (_networkProvider.bellboyTF == true) {
                showCountDownPopup(context);
              } else {
                navPage(
                    context: context,
                    page: BellboyDestinationScreenFinal(),
                    enablePop: true)
                    .navPageToPage();
              }
            }
                : widget.screens == 1
                ? () {
              setState(() {
                if (currentNum!.length < 3) {
                  if (i < 9) {
                    currentNum = '${currentNum}${i + 1}';
                  }
                }
              });
              if (i == 9) {
                showDestinationListPopup(context);
              } else if (i == 10) {
                currentNum = '${currentNum}0';
              } else if (i == 11) {
                showCountDownPopup(context);
              }
            }
                : widget.screens == 2
                ? () {
              showCountDownPopup(context);
            }
                : widget.screens == 3
                ? () {}
                : widget.screens == 4
                ? () {
              setState(() {
                _networkProvider.bellboyTF = false;
              });
              navPage(
                  context: context,
                  page: BellboyReturnModuleFinal(),
                  enablePop: false)
                  .navPageToPage();
            }
                : widget.screens == 5
                ? () {}
                : null,
            child: null,
          ),
        ),
    ]);
  }
}
