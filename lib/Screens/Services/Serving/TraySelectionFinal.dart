import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// 트레이 반응형 UI

class TrayEquipped extends StatelessWidget {
  const TrayEquipped({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
      builder: (context, interactor, _) => TraySelectionFinal(
        characteristic: characteristic,
        // characteristic: Provider.of<BLEModel>(context, listen: false).characteristic,
        subscribeToCharacteristic: interactor.subScribeToCharacteristic,
      ));
}

class TraySelectionFinal extends StatefulWidget {
  const TraySelectionFinal({
    this.characteristic,
    this.subscribeToCharacteristic,
    Key? key}) : super(key: key);

  final QualifiedCharacteristic? characteristic;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
      subscribeToCharacteristic;

  @override
  State<TraySelectionFinal> createState() => _TraySelectionFinalState();
}

class _TraySelectionFinalState extends State<TraySelectionFinal> {
  late ServingModel _servingProvider;
  // late QualifiedCharacteristic? characteristic;

  late String subscribeOutput;
  late TextEditingController textEditingController;
  late StreamSubscription<List<int>>? subscribeStream;

  // 배경 화면
  late String backgroundImage;
  late String resetIcon;

  // 트레이 하이드 앤 쇼
  bool? offStageTray1;
  bool? offStageTray2;
  bool? offStageTray3;

  // 음식 하이드 앤 쇼
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;

  //트레이별 선택 테이블 넘버
  String? table1;
  String? table2;
  String? table3;

  //트레이 BLE시그널
  // late bool trayDetecting;
  late String tray1BLE;
  late String tray2BLE;
  late String tray3BLE;

  //디버그
  late bool _debugTray;

  int testtest = 1;

  // late bool receiptModeOn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    backgroundImage = "assets/screens/Serving/koriZFinalServing.png";

    table1 = "";
    table2 = "";
    table3 = "";

    tray1BLE = "";
    tray2BLE = "";
    tray3BLE = "";

    // trayDetecting = true;

    subscribeOutput = '';
    if(widget.characteristic == null){
      subscribeStream = null;
    }
    textEditingController = TextEditingController();
  }

  // 트레이 디텍팅
  Future<void> subscribeCharacteristic() async {
    subscribeStream =
        widget.subscribeToCharacteristic!(widget.characteristic!).listen((event) {
          if(utf8.decode(event) != subscribeOutput){
            setState(() {
              subscribeOutput = utf8.decode(event);
              tray1BLE = subscribeOutput.split('')[0];
              tray2BLE = subscribeOutput.split('')[1];
              tray3BLE = subscribeOutput.split('')[2];
              print(subscribeOutput);
              if(subscribeOutput != 'Notification set'){
                subscribeStream!.cancel();
              }
            });
          }
        });
    setState(() {
      subscribeOutput = 'Notification set';
      // subscribeCharacteristic();
    });
    // if(characteristic == null){
    //   traySubscribeStream = null;
    // }else{
    //   traySubscribeStream =
    //       widget.subscribeToCharacteristic!(characteristic).listen((event) {
    //         setState(() {
    //           traySubscribeOutput = utf8.decode(event);
    //           // tray1BLE = traySubscribeOutput.split('')[0];
    //           // tray2BLE = traySubscribeOutput.split('')[1];
    //           // tray3BLE = traySubscribeOutput.split('')[2];
    //           print(traySubscribeOutput);
    //         });
    //       });
    //   setState(() {
    //     traySubscribeOutput = 'Notification set';
    //     // subscribeCharacteristic();
    //   });
    // }
    // print('123123');
    // print(traySubscribeOutput);
    // print(characteristic);
  }

  void showTraySetPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectItemModalFinal();
        });
  }

  @override
  void dispose() {
    super.dispose();
    subscribeStream?.cancel();
  }

//QualifiedCharacteristic(characteristicId: 6e400002-b5a3-f393-e0a9-e50e24dcca9e, serviceId: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, deviceId: DF:75:E4:D6:32:63)

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    _debugTray = _servingProvider.trayDebug!;

    // 트레이 디텍터에 따른 트레이 표시
    if (tray1BLE == "1") {
      _servingProvider.attachedTray1 = false;
    } else if (tray1BLE == "0") {
      _servingProvider.attachedTray1 = true;
    }
    if (tray2BLE == "1") {
      _servingProvider.attachedTray2 = false;
    } else if (tray2BLE == "0") {
      _servingProvider.attachedTray2 = true;
    }
    if (tray3BLE == "1") {
      _servingProvider.attachedTray3 = false;
    } else if (tray3BLE == "0") {
      _servingProvider.attachedTray3 = true;
    }

    offStageTray1 = _servingProvider.attachedTray1;
    offStageTray2 = _servingProvider.attachedTray2;
    offStageTray3 = _servingProvider.attachedTray3;

    servedItem1 = _servingProvider.servedItem1;
    servedItem2 = _servingProvider.servedItem2;
    servedItem3 = _servingProvider.servedItem3;

    // receiptModeOn = _servingProvider.receiptModeOn!;

    table1 = _servingProvider.table1;
    table2 = _servingProvider.table2;
    table3 = _servingProvider.table3;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    subscribeCharacteristic();

    return WillPopScope(
      onWillPop: () {
        navPage(
                context: context,
                page: const ServiceScreenFinal(),
                enablePop: false)
            .navPageToPage();
        return Future.value(false);
      },
      child: Scaffold(
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
                        navPage(
                                context: context,
                                page: const ServiceScreenFinal(),
                                enablePop: false)
                            .navPageToPage();
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
                        navPage(
                                context: context,
                                page: const MainScreenBLEAutoConnect(),
                                enablePop: false)
                            .navPageToPage();
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
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  Positioned(
                    right: 150,
                    top: 10,
                    child: IconButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: const DeviceListScreen(),
                                enablePop: true)
                            .navPageToPage();
                      },
                      icon: Icon(Icons.bluetooth),
                      iconSize: 70,
                    ),
                  ),
                  Positioned(
                    right: 300,
                    top: 10,
                    child: TextButton(
                      onPressed: () {
                        subscribeCharacteristic();
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(90, 90),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                      child: Text(subscribeOutput),
                      // child: Text(traySubscribeOutput),
                    ),
                  ),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: WillPopScope(
          onWillPop: () {
            navPage(
                    context: context,
                    page: const ServiceScreenFinal(),
                    enablePop: false)
                .navPageToPage();
            return Future.value(false);
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                //기능적 부분
                Stack(children: [
                  // 상단 2버튼
                  const ServingModuleButtonsFinal(
                    screens: 0,
                  ),
                  // 디버그 버튼
                  Opacity(
                    opacity: 0.02,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 디버그 버튼 트레이 활성화용
                        Offstage(
                          offstage: _debugTray,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _servingProvider.stickTray1();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray1', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _servingProvider.stickTray2();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray2', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _servingProvider.stickTray3();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray3', style: buttonFont)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 초기화 버튼
                  Positioned(
                      right: 188,
                      top: 812,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray1();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 188,
                      top: 1030,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray2();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 188,
                      top: 1296,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray3();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  //트레이1
                  Positioned(
                    top: 757,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray1!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              width: 50,
                              height: 30,
                              child: Offstage(
                                  offstage: servedItem1!,
                                  child: Center(
                                    child: Text(
                                      '$table1 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 25.9,
                            child: Offstage(
                              offstage: servedItem1!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          _servingProvider.itemImageList![0]),
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 388.5,
                            height: 171.8,
                            child: TextButton(
                                onPressed: () {
                                  _servingProvider.tray1Select = true;
                                  _servingProvider.tray2Select = false;
                                  _servingProvider.tray3Select = false;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //트레이2
                  Positioned(
                    top: 975.8,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray2!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 120,
                            child: Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Offstage(
                                  offstage: servedItem2!,
                                  child: Center(
                                    child: Text(
                                      '$table2 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 25.9,
                            child: Offstage(
                              offstage: servedItem2!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(_servingProvider
                                            .itemImageList![1])),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 388.5,
                            height: 171.8,
                            child: TextButton(
                                onPressed: () {
                                  _servingProvider.tray1Select = false;
                                  _servingProvider.tray2Select = true;
                                  _servingProvider.tray3Select = false;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //트레이3
                  Positioned(
                    top: 1217.6,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray3!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 145,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              width: 50,
                              height: 30,
                              child: Offstage(
                                  offstage: servedItem3!,
                                  child: Center(
                                    child: Text(
                                      '$table3 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 51,
                            child: Offstage(
                              offstage: servedItem3!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(_servingProvider
                                            .itemImageList![2])),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 518 * 0.75,
                            height: 293 * 0.75,
                            child: TextButton(
                                onPressed: () {
                                  _servingProvider.tray1Select = false;
                                  _servingProvider.tray2Select = false;
                                  _servingProvider.tray3Select = true;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
