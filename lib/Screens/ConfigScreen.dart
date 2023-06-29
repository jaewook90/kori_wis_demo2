import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/ble_auto_test.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/feedbackAPI.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/fireBaseTest.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_scanner.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class BLEdeviceList extends StatelessWidget {
  const BLEdeviceList({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
      builder: (_, interactor, __) => ConfigScreen(
            characteristic: characteristic,
            subscribeToCharacteristic: interactor.subScribeToCharacteristic,
          ));
}

class ConfigScreen extends StatefulWidget {
  const ConfigScreen(
      {this.characteristic,
      this.subscribeToCharacteristic,
      this.scannerState,
      Key? key})
      : super(key: key);

  final BleScannerState? scannerState;
  final QualifiedCharacteristic? characteristic;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
      subscribeToCharacteristic;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  FirebaseFirestore testDb = FirebaseFirestore.instance;

  final TextEditingController tdController = TextEditingController();

  void showTrayDetectorChange(context) {
    tdController.text = '';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 270),
            child: AlertDialog(
              content: SizedBox(
                width: 670,
                height: 310,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('BLE 주소를 입력하세요.'),
                    TextField(
                      controller: tdController,
                      decoration: const InputDecoration(
                          labelText: 'trayDetector',
                          labelStyle: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 20,
                              color: Colors.white),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          )),
                    )
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
                            top: LinearBorderEdge(size: 1),
                            end: LinearBorderEdge(size: 0.8),
                            // start:
                          ),
                          // shape: const LinearBorder(
                          //     side: BorderSide(color: Colors.white, width: 2),
                          //     top: LinearBorderEdge(size: 1)),
                          minimumSize: const Size(335, 120)),
                      child: Text(
                        '취소',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    //DF:75:E4:D6:32:63
                    TextButton(
                      onPressed: () {
                        final String trayDetector = tdController.text;
                        final data = {"trayDetector": trayDetector};
                        testDb
                            .collection("microBit")
                            .doc("servingBot2")
                            .set(data, SetOptions(merge: true));
                        Provider.of<BLEModel>(context, listen: false)
                            .trayDetectorDeviceId = tdController.text;
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xff797979),
                          shape: const LinearBorder(
                            side: BorderSide(color: Colors.white, width: 2),
                            top: LinearBorderEdge(size: 1),
                            // start:
                          ),
                          minimumSize: const Size(335, 120)),
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
                      page: const TrayEquipped(),
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
        padding: const EdgeInsets.only(top: 200),
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      navPage(
                              context: context,
                              page: const testAPIFeedback(),
                              enablePop: true)
                          .navPageToPage();
                    },
                    style: TextButton.styleFrom(
                        fixedSize: const Size(400, 100),
                        backgroundColor: const Color(0xff2d2d2d),
                        side: const BorderSide(
                            color: Color(0xffaaaaaa), width: 1)),
                    child: const Text('api디버그',
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 40,
                            color: Color(0xffdddddd)))),
                TextButton(
                  onPressed: () {
                navPage(
                        context: context,
                        page: const DeviceListScreen(),
                        enablePop: true)
                    .navPageToPage();
                  },
                  style: TextButton.styleFrom(
                  fixedSize: const Size(400, 100),
                  backgroundColor: const Color(0xff2d2d2d),
                  side:
                      const BorderSide(color: Color(0xffaaaaaa), width: 1)),
                  child: const Text(
                '블루투스 연결',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 40,
                    color: Color(0xffdddddd)),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                navPage(
                        context: context,
                        page: const BLEAutoConnect(),
                        enablePop: true)
                    .navPageToPage();
                  },
                  style: TextButton.styleFrom(
                  fixedSize: const Size(400, 100),
                  backgroundColor: const Color(0xff2d2d2d),
                  side:
                      const BorderSide(color: Color(0xffaaaaaa), width: 1)),
                  child: const Text(
                '블루투스 자동 연결',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 40,
                    color: Color(0xffdddddd)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                navPage(
                        context: context,
                        page: const FireBaseTestScreen(),
                        enablePop: true)
                    .navPageToPage();
                  },
                  style: TextButton.styleFrom(
                  fixedSize: const Size(400, 100),
                  backgroundColor: const Color(0xff2d2d2d),
                  side:
                      const BorderSide(color: Color(0xffaaaaaa), width: 1)),
                  child: const Text(
                '파이어베이스 테스트',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 40,
                    color: Color(0xffdddddd)),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                showTrayDetectorChange(context);
                  },
                  style: TextButton.styleFrom(
                  fixedSize: const Size(400, 100),
                  backgroundColor: const Color(0xff2d2d2d),
                  side:
                      const BorderSide(color: Color(0xffaaaaaa), width: 1)),
                  child: const Text(
                '트레이 디텍터 변경',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 40,
                    color: Color(0xffdddddd)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                navPage(
                        context: context,
                        page: const FireBaseTestScreen(),
                        enablePop: true)
                    .navPageToPage();
                  },
                  style: TextButton.styleFrom(
                fixedSize: const Size(400, 100),
                backgroundColor: Colors.transparent,
                // side: BorderSide(color: Color(0xffaaaaaa), width: 1)
                  ),
                  child: const Text('')
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
