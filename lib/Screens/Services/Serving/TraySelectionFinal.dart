import 'dart:async';
import 'dart:convert' show utf8;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/ConfigScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/AdvertisementScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDish.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

part 'TraySelectionFinal.g.dart';

//ignore_for_file: annotate_overrides
// 트레이 반응형 UI

class TrayEquipped extends StatelessWidget {
  const TrayEquipped({
    this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic? characteristic;

  @override
  Widget build(BuildContext context) {
    return Consumer3<BleDeviceInteractor, BleDeviceConnector,
            ConnectionStateUpdate>(
        builder: (_, interactor, deviceConnector, connectionStateUpdate, __) =>
            TraySelectionFinal(
              characteristic: characteristic,
              subscribeToCharacteristic: interactor.subScribeToCharacteristic,
              viewModel: TrayEquippedViewModel(
                  deviceId: characteristic!.deviceId,
                  connectionStatus: connectionStateUpdate.connectionState,
                  deviceConnector: deviceConnector,
                  discoverServices: () =>
                      interactor.discoverServices(characteristic!.deviceId)),
            ));
  }
}

class TrayEquippedViewModel extends $TrayEquippedViewModel {
  const TrayEquippedViewModel({
    required this.deviceId,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.discoverServices,
  });

  final String deviceId;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  @CustomEquality(Ignore())
  final Future<List<DiscoveredService>> Function() discoverServices;

  bool get deviceConnected =>
      connectionStatus == DeviceConnectionState.connected;

  void connect() {
    deviceConnector.connect(deviceId);
  }

  void disconnect() {
    deviceConnector.disconnect(deviceId);
  }
}

class TraySelectionFinal extends StatefulWidget {
  const TraySelectionFinal(
      {this.characteristic,
      this.subscribeToCharacteristic,
      this.viewModel,
      Key? key})
      : super(key: key);

  final QualifiedCharacteristic? characteristic;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
      subscribeToCharacteristic;

  final TrayEquippedViewModel? viewModel;

  @override
  State<TraySelectionFinal> createState() => _TraySelectionFinalState();
}

class _TraySelectionFinalState extends State<TraySelectionFinal>
    with TickerProviderStateMixin {
  late ServingModel _servingProvider;
  late BLEModel _bleProvider;
  late NetworkModel _networkProvider;

  FirebaseFirestore robotDb = FirebaseFirestore.instance;

  late Timer _timer;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> PositioningList;
  late List<String> PositionList;

  late String subscribeOutput;
  late StreamSubscription<List<int>>? subscribeStream;

  late String targetTableNum;

  String? startUrl;
  String? navUrl;

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

  late int serviceState;

  // late bool receiptModeOn;

  DateTime? currentBackPressTime;

  FToast? fToast;

  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fToast = FToast();
    fToast?.init(context);

    PositioningList = [];
    PositionList = [];

    serviceState = 0;

    backgroundImage = "assets/screens/Serving/koriZFinalServing.png";

    table1 = "";
    table2 = "";
    table3 = "";

    tray1BLE = "";
    tray2BLE = "";
    tray3BLE = "";

    subscribeOutput = 'init';

    Provider.of<BLEModel>(context, listen: false).onTraySelectionScreen = true;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    print(startUrl);
    print(navUrl);;

    if (widget.characteristic == null) {
      subscribeStream = null;
    }

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }
  }

  void getStarted_readData() async {
    // [START get_started_read_data]
    await robotDb.collection("servingBot1").get().then((event) {
      for (var doc in event.docs) {
        if(doc.id == "robotState"){
          Provider.of<ServingModel>(context, listen: false).servingState = doc.data()['serviceState'];
          targetTableNum = doc.data()['returnTable'];
          if(doc.data()['serviceState'] == 1){
            // 퇴식 화면 제작 후 이동 함수 추가
            print('a');
            print(startUrl);
            print(navUrl);;
            PostApi(
                url: startUrl,
                endadr: navUrl,
                keyBody: targetTableNum)
                .Posting(context);
            navPage(context: context, page: const ReturnProgressModuleFinal(), enablePop: true).navPageToPage();
          }else if(doc.data()['serviceState'] == 2){
            navPage(context: context, page: const ADScreen(), enablePop: true).navPageToPage();
          }
        }
      }
    });
    // [END get_started_read_data]
  }

  void poseDataUpdate() {
    newPoseData = Provider.of<NetworkModel>(context, listen: false).getApiData;
    if (newPoseData != null) {
      poseData = newPoseData;
      String editPoseData = poseData.toString();

      editPoseData = editPoseData.replaceAll('{', "");
      editPoseData = editPoseData.replaceAll('}', "");
      List<String> PositionWithCordList = editPoseData.split("], ");

      for (int i = 0; i < PositionWithCordList.length; i++) {
        PositioningList = PositionWithCordList[i].split(":");
        for (int j = 0; j < PositioningList.length; j++) {
          if (j == 0) {
            if (!PositioningList[j].contains('[')) {
              poseData = PositioningList[j];
              PositionList.add(poseData);
            }
          }
        }
      }
      PositionList.sort();
    } else {
      PositionList = [];
    }
  }

  // 트레이 디텍팅

  Future<void> subscribeCharacteristic() async {
    _timer = Timer(Duration(milliseconds: 500), () {
      subscribeStream = widget.subscribeToCharacteristic!
              (widget.characteristic!)
          .listen((event) {
        if (mounted) {
          setState(() {
            subscribeOutput = utf8.decode(event);
            tray1BLE = subscribeOutput.split('')[0];
            tray2BLE = subscribeOutput.split('')[1];
            tray3BLE = subscribeOutput.split('')[2];
            if (subscribeOutput != 'Notification set') {
              subscribeStream!.cancel();
            }
            _timer.cancel();
          });
        }
      });
      if (mounted) {
        setState(() {
          subscribeOutput = 'Notification set';
          _timer.cancel();
        });
      }
    });
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
    subscribeStream!.cancel();

  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    _debugTray = _servingProvider.trayDebug!;

    // 서버에서 로봇 스테이트 읽기
    WidgetsBinding.instance.addPostFrameCallback((_){getStarted_readData();});

    serviceState = Provider.of<ServingModel>(context, listen: false).servingState!;
    //0: 일반 1: 퇴식 2: 광고 재생

    // if(Provider.of<ServingModel>(context, listen: false).servingState == 3) {
    //   const int newState = 0;
    //   final data = {"serviceState": newState};
    //   robotDb
    //       .collection("servingBot1")
    //       .doc("robotState")
    //       .set(data, SetOptions(merge: true));
    // }

    print(serviceState);

    // 트레이 디텍터에 따른 트레이 표시

    if (widget.viewModel!.deviceConnected == false) {
      widget.viewModel!.connect();
    }

    if (PositionList.isEmpty) {
      PositionList = _networkProvider.getPoseData!;
    } else {
      _networkProvider.getPoseData = PositionList;
    }

    if (widget.viewModel!.deviceConnected == false) {
      widget.viewModel!.connect();
    }

    if (mounted) {
      if (_bleProvider.onTraySelectionScreen == true) {
        subscribeCharacteristic();
      }
    } else {
      subscribeStream!.cancel();
    }

    if (tray1BLE == "1") {
      _servingProvider.attachedTray1 = false;
    } else if (tray1BLE == "0") {
      _servingProvider.attachedTray1 = true;
      if (table1 != "") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _servingProvider.clearTray1();
        });
      }
    }
    if (tray2BLE == "1") {
      _servingProvider.attachedTray2 = false;
    } else if (tray2BLE == "0") {
      _servingProvider.attachedTray2 = true;
      if (table2 != "") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _servingProvider.clearTray2();
        });
        // print('t2');
      }
    }
    if (tray3BLE == "1") {
      _servingProvider.attachedTray3 = false;
    } else if (tray3BLE == "0") {
      _servingProvider.attachedTray3 = true;
      if (table3 != "") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _servingProvider.clearTray3();
        });
        // print('t3');
      }
    }

    offStageTray1 = _servingProvider.attachedTray1;
    offStageTray2 = _servingProvider.attachedTray2;
    offStageTray3 = _servingProvider.attachedTray3;

    servedItem1 = _servingProvider.servedItem1;
    servedItem2 = _servingProvider.servedItem2;
    servedItem3 = _servingProvider.servedItem3;

    table1 = _servingProvider.table1;
    table2 = _servingProvider.table2;
    table3 = _servingProvider.table3;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(milliseconds: 1300)) {
          currentBackPressTime = now;
          fToast?.showToast(
              toastDuration: const Duration(milliseconds: 1300),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageIcon(
                          AssetImage('assets/icons/ExaIcon.png'),
                          size: 35,
                          color: Color(0xffB7B7B7),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          _text,
                          style: TextStyle(fontFamily: 'kor', fontSize: 35),
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    )
                  ],
                ),
              ),
              gravity: ToastGravity.BOTTOM);
          return Future.value(false);
        }

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
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: WillPopScope(
          onWillPop: () async {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(milliseconds: 1300)) {
              currentBackPressTime = now;
              fToast?.showToast(
                  toastDuration: const Duration(milliseconds: 1300),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ImageIcon(
                              AssetImage('assets/icons/ExaIcon.png'),
                              size: 35,
                              color: Color(0xffB7B7B7),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              _text,
                              style: TextStyle(fontFamily: 'kor', fontSize: 35),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        )
                      ],
                    ),
                  ),
                  gravity: ToastGravity.BOTTOM);
              return Future.value(false);
            }
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
                            foregroundColor: Colors.transparent,
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
                            foregroundColor: Colors.transparent,
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
                            foregroundColor: Colors.transparent,
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
                                  _bleProvider.onTraySelectionScreen = false;
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
                                  _bleProvider.onTraySelectionScreen = false;
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
                                  _bleProvider.onTraySelectionScreen = false;
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
