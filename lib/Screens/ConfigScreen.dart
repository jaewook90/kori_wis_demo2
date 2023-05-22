import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/feedbackAPI.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

import 'MainScreenFinal.dart';

class BLEdeviceList extends StatelessWidget {
  const BLEdeviceList({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
      builder: (context, interactor, _) => ConfigScreen(
            characteristic: characteristic,
            subscribeToCharacteristic: interactor.subScribeToCharacteristic,
          ));
}

class ConfigScreen extends StatefulWidget {
  const ConfigScreen(
      {this.characteristic, this.subscribeToCharacteristic, Key? key})
      : super(key: key);

  final QualifiedCharacteristic? characteristic;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
      subscribeToCharacteristic;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(
                0, screenHeight * 0.0015, screenWidth * 0.05, 0),
            onPressed: () {
              navPage(
                      context: context,
                      page: const MainScreenFinal(),
                      enablePop: false)
                  .navPageToPage();
            },
            icon: const Icon(
              Icons.home_outlined,
            ),
            color: const Color(0xffB7B7B7),
            iconSize: screenHeight * 0.05,
          )
        ],
        toolbarHeight: screenHeight * 0.08,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.only(top: 200),
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  navPage(
                          context: context,
                          page: testAPIFeedback(),
                          enablePop: true)
                      .navPageToPage();
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(150, 150),
                  side: BorderSide(
                    width: 1,
                    color: Colors.white
                  )
                ),
                child: Text('api디버그')),
            SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: TextButton(
                  onPressed: () {
                    navPage(
                            context: context,
                            page: const DeviceListScreen(),
                            enablePop: true)
                        .navPageToPage();
                  },
                  child: Text(
                    '블루투스 연결',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 40,
                        color: Color(0xffdddddd)),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xff2d2d2d),
                      side: BorderSide(color: Color(0xffaaaaaa), width: 1)),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
