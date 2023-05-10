import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Utills/ble/ui/ble_status_screen.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

import 'MainScreenFinal.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
  builder: (_, status, __) {
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
              navPage(context: context, page: const MainScreenFinal(), enablePop: false).navPageToPage();
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
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      if (status == BleStatus.ready) {
                        navPage(context: context, page: DeviceListScreen(), enablePop: false).navPageToPage();
                      } else {
                        navPage(context: context, page: BleStatusScreen(status: status ?? BleStatus.unknown), enablePop: false).navPageToPage();
                      }
                    },
                    child: Text('블루투스 설정', style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 40,
                      color: Color(0xffdddddd)
                    ),),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff2d2d2d),
                      side: BorderSide(color: Color(0xffaaaaaa), width: 1)
                    ),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  });
}
