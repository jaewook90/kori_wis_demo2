import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:provider/provider.dart';

class IsolateTestSub extends StatelessWidget {
  const IsolateTestSub({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
      builder: (context, interactor, _) => IsolateTestScreen(
        characteristic: characteristic,
        subscribeToCharacteristic: interactor.subScribeToCharacteristic,
      ));
}

class IsolateTestScreen extends StatefulWidget {
  const IsolateTestScreen(
      {this.characteristic, this.subscribeToCharacteristic, Key? key})
      : super(key: key);

  final QualifiedCharacteristic? characteristic;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
  subscribeToCharacteristic;

  @override
  State<IsolateTestScreen> createState() => _IsolateTestScreenState();
}

class _IsolateTestScreenState extends State<IsolateTestScreen> {
  late BLEModel _bleProvider;

  late String subscribeOutput;
  late TextEditingController textEditingController;
  late StreamSubscription<List<int>>? subscribeStream;

  //트레이 BLE시그널
  // late bool trayDetecting;
  late String tray1BLE;
  late String tray2BLE;
  late String tray3BLE;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tray1BLE = "";
    tray2BLE = "";
    tray3BLE = "";

    subscribeOutput = '';

    Provider.of<BLEModel>(context, listen: false).onTraySelectionScreen = true;

    if (widget.characteristic == null) {
      subscribeStream = null;
    }
    textEditingController = TextEditingController();
  }

  // 트레이 디텍팅

  Future<void> subscribeCharacteristic() async {
    subscribeStream = widget.subscribeToCharacteristic!(widget.characteristic!)
        .listen((event) {
      // if (utf8.decode(event) !=
      //     Provider.of<BLEModel>(context, listen: false).subscribeOutput) {
      setState(() {
        subscribeOutput = utf8.decode(event);
        tray1BLE = subscribeOutput.split('')[0];
        tray2BLE = subscribeOutput.split('')[1];
        tray3BLE = subscribeOutput.split('')[2];
        // Provider.of<BLEModel>(context, listen: false).subscribeOutput =
        //     subscribeOutput;
        print(subscribeOutput);
        // print(
        //     'c : ${Provider.of<BLEModel>(context, listen: false).subscribeOutput}');
        if (subscribeOutput != 'Notification set') {
          subscribeStream!.cancel();
        }
      });
      // }
    });
    setState(() {
      subscribeOutput = 'Notification set';
      // subscribeCharacteristic();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscribeStream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    if (tray1BLE == "1") {
    } else if (tray1BLE == "0") {
    }
    if (tray2BLE == "1") {
    } else if (tray2BLE == "0") {
    }
    if (tray3BLE == "1") {
    } else if (tray3BLE == "0") {
    }

    // double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = 1080;
    // double screenHeight = 1920;

    if (_bleProvider.onTraySelectionScreen == true) {
      subscribeCharacteristic();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: screenWidth,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      // navPage(
                      //     context: context,
                      //     page: const MainScreenBLEAutoConnect(),
                      //     enablePop: false)
                      //     .navPageToPage();
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(90, 90),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                Positioned(
                  left: 120,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      // navPage(
                      //     context: context,
                      //     page: const MainScreenBLEAutoConnect(),
                      //     enablePop: false)
                      //     .navPageToPage();
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(90, 90),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Home.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            Positioned(child: Text('데이터값', style: TextStyle(fontFamily: 'kor', fontSize: 60),)),
            Positioned(child: Text('1번', style: TextStyle(fontFamily: 'kor', fontSize: 60))),
            Positioned(child: Text('2번', style: TextStyle(fontFamily: 'kor', fontSize: 60))),
            Positioned(child: Text('3번', style: TextStyle(fontFamily: 'kor', fontSize: 60))),
          ],
        ),
      ),
    );
  }
}
