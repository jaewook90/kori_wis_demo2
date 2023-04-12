import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/ShippingDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
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
  // late NetworkModel _networkProvider;

  late ServingModel _servingProvider;
  late OrderModel _orderProvider;

  late var screenList = List<Widget>.empty();
  late var serviceList = List<Widget>.empty();

  late var homeButtonName = List<String>.empty();

  double pixelRatio = 0.75;

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

  void showCountDownStarting(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal();
        });
  }

  void showDestinationListPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ShippingDestinationModalFinal();
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
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    if (widget.screens == 0) {
      // 택배 메인 화면
      buttonPositionWidth = [139];
      buttonPositionHeight = [1408];

      buttonSize = [1160, 254];

      buttonRadius = 50;
    } else if (widget.screens == 1) {
      // 키패드 화면
      buttonPositionWidth = [
        154,
        546,
        938,
        154,
        546,
        938,
        154,
        546,
        938,
        154,
        546,
        938
      ];
      buttonPositionHeight = [
        699,
        699,
        699,
        1085,
        1085,
        1085,
        1471,
        1471,
        1471,
        1857,
        1857,
        1857
      ];

      buttonSize = [349, 344];

      buttonRadius = 50;
    } else if (widget.screens == 2) {
      // 목적지 리스트
      buttonPositionWidth = [100, 100, 694, 100, 694, 100, 694];
      buttonPositionHeight = [423, 691, 691, 1020, 1020, 1345, 1345];

      buttonSize = [];

      buttonSize1 = [1129, 211];
      buttonSize2 = [534, 278];

      buttonRadius = 50;
    } else if (widget.screens == 3) {
      // 도착 화면
      buttonPositionWidth = [107];
      buttonPositionHeight = [1372];

      buttonSize = [866, 172];

      buttonRadius = 50;
    } else if (widget.screens == 4) {
      // 팝업 ( 추가 여부 / 카운트다운 )
      buttonPositionWidth = [70, 695];
      buttonPositionHeight = [327, 327];

      buttonSize = [565, 194];

      buttonRadius = 50;
    } else if (widget.screens == 5) {
      // 완료 화면
      buttonPositionWidth = [143];
      buttonPositionHeight = [1308];

      buttonSize = [1155, 230];

      buttonRadius = 50;
    }

    if (widget.screens != 3) {
      for (int i = 0; i < buttonPositionHeight.length; i++) {
        buttonPositionHeight[i] = buttonPositionHeight[i] * pixelRatio;
      }
      for (int i = 0; i < buttonPositionWidth.length; i++) {
        buttonPositionWidth[i] = buttonPositionWidth[i] * pixelRatio;
      }
      if (buttonSize.isNotEmpty) {
        for (int i = 0; i < buttonSize.length; i++) {
          buttonSize[i] = buttonSize[i] * pixelRatio;
        }
      }else if (buttonSize.isEmpty) {
        for (int i = 0; i < buttonSize1.length; i++) {
          buttonSize1[i] = buttonSize1[i] * pixelRatio;
        }
        for (int i = 0; i < buttonSize2.length; i++) {
          buttonSize2[i] = buttonSize2[i] * pixelRatio;
        }
      }
    }

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      (currentNum == null && widget.screens == 1)
          ? Container()
          : Positioned(
              top: 290 * 0.75,
              left: 551 * 0.75,
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
            ),
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
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius:
                        BorderRadius.circular(buttonRadius * pixelRatio)),
                fixedSize: widget.screens == 2
                    ? i != 0
                        ? Size(buttonSize2[buttonWidth],
                            buttonSize2[buttonHeight])
                        : Size(buttonSize1[buttonWidth],
                            buttonSize1[buttonHeight])
                    : Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
                    navPage(
                            context: context,
                            page: ShippingDestinationNewFinal(),
                            enablePop: true)
                        .navPageToPage();
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
                          showCountDownStarting(context);
                        }
                      }
                    : widget.screens == 2
                        ? () {
                            showCountDownStarting(context);
                          }
                        : widget.screens == 3
                            ? () {
                                navPage(
                                        context: context,
                                        page: ShippingMenuFinal(),
                                        enablePop: false)
                                    .navPageToPage();
                              }
                            : widget.screens == 4
                                ? () {}
                                : widget.screens == 5
                                    ? () {}
                                    : null,
            child: null,
          ),
        ),
    ]);
  }
}