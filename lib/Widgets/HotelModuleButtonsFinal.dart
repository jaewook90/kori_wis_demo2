import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellBoyYNModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/hotelBookedRoomWarnModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/ShippingDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomInfoNCartFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomSelectFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class HotelModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const HotelModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<HotelModuleButtonsFinal> createState() =>
      _HotelModuleButtonsFinalState();
}

class _HotelModuleButtonsFinalState extends State<HotelModuleButtonsFinal> {
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

  void showBookingRoomWarn(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '예약 확인 서비스 준비 중',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 50,
                        color: Color(0xffF0F0F0)),
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xff2C2C2C),
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: Color(0xFFB7B7B7),
                  style: BorderStyle.solid,
                  width: 1,
                )),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확 인',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 30,
                        color: Color(0xffF0F0F0)),
                  ),
                  style: TextButton.styleFrom(
                      shape: LinearBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          top: LinearBorderEdge(size: 1)),
                      minimumSize:
                          Size(screenWidth * 0.5, screenHeight * 0.05)),
                ),
              ),
            ],
            // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
          );
        });
  }

  void showBookingNoRoomWarn(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '모든 객실이 예약 되었습니다.',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 30,
                        color: Color(0xffF0F0F0)),
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xff2C2C2C),
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: Color(0xFFB7B7B7),
                  style: BorderStyle.solid,
                  width: 1,
                )),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확 인',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 30,
                        color: Color(0xffF0F0F0)),
                  ),
                  style: TextButton.styleFrom(
                      shape: LinearBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          top: LinearBorderEdge(size: 1)),
                      minimumSize:
                          Size(screenWidth * 0.5, screenHeight * 0.05)),
                ),
              ),
            ],
            // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
          );
        });
  }

  void showPaymentPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PaymentScreenFinal();
        });
  }

  void showBellBoyYN(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return BellBoyYNModalFinal();
        });
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
      buttonPositionWidth = [91, 561];
      buttonPositionHeight = [533, 533];

      buttonSize = [428, 584];

      buttonRadius = 50;
    } else if (widget.screens == 1) {
      // 키패드 화면
      buttonPositionWidth = [
        122,
        122,
        122,
        122,
      ];
      buttonPositionHeight = [
        423,
        749,
        1075,
        1401,
      ];

      buttonSize = [828, 275];

      buttonRadius = 50;
    } else if (widget.screens == 2) {
      // 목적지 리스트
      buttonPositionWidth = [104];
      buttonPositionHeight = [1547];

      buttonSize = [873, 160];

      buttonRadius = 50;
    } else if (widget.screens == 3) {
      // 도착 화면
      buttonPositionWidth = [552, 132];
      buttonPositionHeight = [1316, 1521];

      buttonSize1 = [390, 168];
      buttonSize2 = [811, 158];

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

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      // (currentNum == null && widget.screens == 1)
      //     ? Container()
      //     : Positioned(
      //         top: 290 * 0.75,
      //         left: 551 * 0.75,
      //         width: 270,
      //         height: 180,
      //         child: Text(
      //           '$currentNum',
      //           style: TextStyle(
      //               fontFamily: 'kor',
      //               fontSize: 150,
      //               fontWeight: FontWeight.bold,
      //               color: Color(0xffffffff)),
      //         ),
      //       ),
      // widget.screens == 1
      //     ? Positioned(
      //         left: 1213 * 0.75,
      //         top: 451 * 0.75,
      //         child: Container(
      //           width: 60,
      //           height: 60,
      //           color: Colors.transparent,
      //           child: FilledButton(
      //             style: FilledButton.styleFrom(
      //                 backgroundColor: Colors.transparent,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(0),
      //                   // side: BorderSide(width: 1, color: Colors.white)
      //                 )),
      //             onPressed: () {
      //               setState(() {
      //                 currentNum = "";
      //               });
      //             },
      //             child: null,
      //           ),
      //         ))
      //     : Container(),
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
                fixedSize:
                    // Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
                    widget.screens == 3
                        ? i == 0
                            ? Size(buttonSize1[buttonWidth],
                                buttonSize1[buttonHeight])
                            : Size(buttonSize2[buttonWidth],
                                buttonSize2[buttonHeight])
                        : Size(
                            buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
                    if (i == 0) {
                      showBookingRoomWarn(context);
                    } else {
                      navPage(
                              context: context,
                              page: HotelCheckINRoomSelect(),
                              enablePop: true)
                          .navPageToPage();
                    }
                  }
                : widget.screens == 1
                    ? () {
                        if (i == 2) {
                          navPage(
                                  context: context,
                                  page: HotelRoomInfoNCart(),
                                  enablePop: true)
                              .navPageToPage();
                        } else {
                          showBookingNoRoomWarn(context);
                        }
                      }
                    : widget.screens == 2
                        ? () {
                            showPaymentPopup(context);
                          }
                        : widget.screens == 3
                            ? () {
              if(i==0){
                showBellBoyYN(context);
              }else{
                navPage(context: context, page: HotelServiceMenu(), enablePop: false).navPageToPage();
              }
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