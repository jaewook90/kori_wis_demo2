import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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


  // late Uuid huskyCharacteristicId;
  // late Uuid huskyServiceId;
  // late String huskyDeviceId;

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

    // huskyCharacteristicId = Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    // huskyServiceId = Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    // huskyDeviceId = 'F0:52:FD:5C:8D:73';

    screenList = [
      const ServiceScreenFinal(),
      const LinkConnectorScreen(),
      const AdminScreen(),
      const ConfigScreen(characteristic: null, subscribeToCharacteristic: null)
    ];
    // serviceList = [
    //   const ShippingMenuFinal(),
    //   // const TraySelectionFinal(
    //   //     characteristic: null, subscribeToCharacteristic: null),
    //   TrayEquipped(
    //     characteristic: QualifiedCharacteristic(
    //         characteristicId: _bleProvider.huskyCharacteristicId!,
    //         serviceId: _bleProvider.huskyServiceId!,
    //         deviceId: _bleProvider.huskyDeviceId!),
    //   ),
    //   const HotelServiceMenu()
    // ];
  }

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    QualifiedCharacteristic trayDetectorInform = QualifiedCharacteristic(
      characteristicId: _bleProvider.trayDetectorCharacteristicId!,
      serviceId: _bleProvider.trayDetectorServiceId!,
      deviceId: _bleProvider.trayDetectorDeviceId!
    );

    QualifiedCharacteristic huskyInform = QualifiedCharacteristic(
        characteristicId: _bleProvider.trayDetectorCharacteristicId!,
        serviceId: _bleProvider.trayDetectorServiceId!,
        deviceId: _bleProvider.trayDetectorDeviceId!
    );

    serviceList = [
      const ShippingMenuFinal(),
      // const TraySelectionFinal(
      //     characteristic: null, subscribeToCharacteristic: null),
      // TrayEquipped(
      //   characteristic: QualifiedCharacteristic(
      //       characteristicId: _bleProvider.huskyCharacteristicId!,
      //       serviceId: _bleProvider.huskyServiceId!,
      //       deviceId: _bleProvider.huskyDeviceId!),
      // ),
      TrayEquipped(
              characteristic: QualifiedCharacteristic(
                  characteristicId: _bleProvider.trayDetectorCharacteristicId!,
                  serviceId: _bleProvider.trayDetectorServiceId!,
                  deviceId: _bleProvider.trayDetectorDeviceId!),
            ),
      const HotelServiceMenu()
    ];

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
                            page: screenList[i],
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
