import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellBoyYNModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/RoomServiceModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomInfoNCartFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomSelectFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class HotelModuleButtonsFinal extends StatefulWidget {
  final int? screens;
  final String? roomPrice;

  const HotelModuleButtonsFinal({
    Key? key,
    this.screens,
    this.roomPrice,
  }) : super(key: key);

  @override
  State<HotelModuleButtonsFinal> createState() =>
      _HotelModuleButtonsFinalState();
}

class _HotelModuleButtonsFinalState extends State<HotelModuleButtonsFinal> {
  late NetworkModel _networkProvider;
  late RoomServiceModel _roomServiceProvider;
  late OrderModel _orderProvider;

  late var homeButtonName = List<String>.empty();
  late List<String> roomList;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late double buttonRadius1;
  late double buttonRadius2;

  late int buttonNumbers = 0;

  int buttonWidth = 0;
  int buttonHeight = 1;

  late String? roomKind;

  String? currentNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentNum = "";
    roomList = ['스탠다드 더블', '스탠다드 트윈', '디럭스 더블', '디럭스 트윈'];
  }

  void showPaymentPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const PaymentScreenFinal();
        });
  }

  void showBellBoyYN(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const BellBoyYNModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _roomServiceProvider =
        Provider.of<RoomServiceModel>(context, listen: false);

    if (widget.screens == 0) {
      // 호텔 서비스 선택 화면
      buttonPositionWidth = [91, 91, 91];
      buttonPositionHeight = [300, 540, 783];

      buttonSize = [900, 193];

      buttonRadius = 25;
    } else if (widget.screens == 1) {
      // 룸 종류 선택 화면
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

      buttonRadius = 40;
    } else if (widget.screens == 2) {
      // 결제 전 방 예약 정보 페이지
      buttonPositionWidth = [104];
      buttonPositionHeight = [1547];

      buttonSize = [873, 160];

      buttonRadius = 40;
    } else {
      // 도착 화면
      buttonPositionWidth = [558, 80];
      buttonPositionHeight = [1327, 1558];

      buttonSize1 = [440, 190];
      buttonSize2 = [922, 180];

      buttonRadius1 = 35;
      buttonRadius2 = 35;
    }

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      for (int i = 0; i < buttonNumbers; i++)
        Positioned(
          left: buttonPositionWidth[i],
          top: buttonPositionHeight[i],
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.screens == 3
                        ? i == 0
                        ? buttonRadius1
                        : buttonRadius2
                        : buttonRadius)),
                fixedSize: widget.screens == 3
                    ? i == 0
                    ? Size(
                    buttonSize1[buttonWidth], buttonSize1[buttonHeight])
                    : Size(
                    buttonSize2[buttonWidth], buttonSize2[buttonHeight])
                    : Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
              if (i == 0) {
                //체크인
                navPage(
                    context: context,
                    page: const HotelCheckINRoomSelect(),
                    enablePop: true)
                    .navPageToPage();
              } else if (i == 1) {
                //벨보이
                setState(() {
                  _networkProvider.serviceState = 2;
                });
                navPage(
                    context: context,
                    page: const BellBoyServiceMenu(),
                    enablePop: true)
                    .navPageToPage();
              } else {
                //룸서비스
                setState(() {
                  _roomServiceProvider.clearAllTray();
                  _networkProvider.serviceState = 3;
                });
                navPage(
                    context: context,
                    page: const RoomServiceMenu(),
                    enablePop: true)
                    .navPageToPage();
              }
            }
                : widget.screens == 1
                ? () {
              roomKind = roomList[i];
              navPage(
                  context: context,
                  page: HotelRoomInfoNCart(kindOfRoom: roomKind),
                  enablePop: true)
                  .navPageToPage();
            }
                : widget.screens == 2
                ? () {
              _orderProvider.orderedRoomPrice = widget.roomPrice;
              showPaymentPopup(context);
            }
                : widget.screens == 3
                ? () {
              if (i == 0) {
                showBellBoyYN(context);
              } else {
                navPage(
                    context: context,
                    page: const HotelServiceMenu(),
                    enablePop: false)
                    .navPageToPage();
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
