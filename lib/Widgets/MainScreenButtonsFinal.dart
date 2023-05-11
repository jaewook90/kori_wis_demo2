import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/AdminScreen.dart';
import 'package:kori_wis_demo/Screens/ConfigScreen.dart';
import 'package:kori_wis_demo/Screens/LinkConnectorScreen.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class MainScreenButtonsFinal extends StatefulWidget {
  final int? screens;

  const MainScreenButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<MainScreenButtonsFinal> createState() => _MainScreenButtonsFinalState();
}

class _MainScreenButtonsFinalState extends State<MainScreenButtonsFinal> {
  late MainStatusModel _statusProvider;
  late BLEModel _bleProvider;

  late var screenList = List<Widget>.empty();
  late var serviceList = List<Widget>.empty();

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screenList = [
      const ServiceScreenFinal(),
      const LinkConnectorScreen(),
      const AdminScreen(),
      // const ConfigScreenDeviceConnect()
    ];
    serviceList = [
      const ShippingMenuFinal(),
      const TraySelectionFinal(
          characteristic: null, subscribeToCharacteristic: null),
      const HotelServiceMenu()
    ];
  }

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    if (widget.screens == 0) {
      // 메인 화면 ( 서비스, 커넥터, 관리자 설정 버튼 )
      buttonPositionWidth = [90, 560, 90, 560];
      buttonPositionHeight = [300, 300, 770, 770];

      buttonSize = [430, 425];

      buttonRadius = 30;
    } else if (widget.screens == 1) {
      // 서비스 선택화면
      buttonPositionWidth = [0, 0, 0];
      buttonPositionHeight = [15, 610, 1205];

      buttonSize = [1080, 580];

      buttonRadius = 0;
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
                    borderRadius: BorderRadius.circular(buttonRadius)),
                fixedSize:
                    Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0 // 메인 스크린
                ? () {
                    navPage(
                            context: context,
                            page: i==3?ConfigScreenDeviceConnect(deviceId: _bleProvider.deviceId1) : screenList[i],
                            enablePop: true)
                        .navPageToPage();
                  }
                : widget.screens == 1 // 서비스 선택 스크린
                    ? () {
                        if (i == 0) {
                          setState(() {
                            _statusProvider.serviceState = 0;
                          });
                          navPage(
                                  context: context,
                                  page: serviceList[i],
                                  enablePop: true)
                              .navPageToPage();
                        } else if (i == 1) {
                          setState(() {
                            _statusProvider.serviceState = 1;
                          });
                          navPage(
                                  context: context,
                                  page: serviceList[i],
                                  enablePop: true)
                              .navPageToPage();
                        } else {
                          setState(() {
                            _statusProvider.serviceState = 2;
                          });
                          navPage(
                                  context: context,
                                  page: serviceList[i],
                                  enablePop: true)
                              .navPageToPage();
                        }
                      }
                    : null,
            child: null,
          ),
        ),
    ]);
  }
}
