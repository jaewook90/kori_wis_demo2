import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';
import 'package:provider/provider.dart';

part 'MainScreenFinal.g.dart';
//ignore_for_file: annotate_overrides

class MainScreenBLEAutoConnect extends StatelessWidget {
  final dynamic parsePoseData;

  const MainScreenBLEAutoConnect({
    this.parsePoseData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiscoveredDevice device = DiscoveredDevice(
        id: 'DF:75:E4:D6:32:63',
        // F0:28:31:D5:10:D0 트레이 디텍터 / 서빙 봇
        // DF:75:E4:D6:32:63 트레이 디텍터 / 충전 봇
        // F0:52:FD:5C:8D:73 허스키렌즈
        // FA:BF:4C:CE:D5:F8 디버그용
        name: 'BBC micro:bit',
        serviceData: {},
        rssi: 0,
        serviceUuids: [],
        manufacturerData: Uint8List(0));
    return Consumer3<
        BleDeviceConnector,
        ConnectionStateUpdate,
        BleDeviceInteractor
        //, BleDeviceInteractor
        >(
      builder: (_,
              deviceConnector,
              connectionStateUpdate,
              serviceDiscoverer,
              // interactor,
              __) =>
          MainScreenFinal(
        // subscribeToCharacteristic: interactor.subScribeToCharacteristic,
        viewModel: MainScreenBLEAutoViewModel(
            deviceId: device.id,
            connectionStatus: connectionStateUpdate.connectionState,
            deviceConnector: deviceConnector,
            discoverServices: () =>
                serviceDiscoverer.discoverServices(device.id)),
        parsePoseData: parsePoseData,
      ),
    );
  }
}

@immutable
@FunctionalData()
class MainScreenBLEAutoViewModel extends $MainScreenBLEAutoViewModel {
  const MainScreenBLEAutoViewModel({
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

class MainScreenFinal extends StatefulWidget {
  const MainScreenFinal({
    Key? key,
    this.parsePoseData,
    this.viewModel,
  }) : super(key: key);
  final dynamic parsePoseData;
  final MainScreenBLEAutoViewModel? viewModel;

  @override
  State<MainScreenFinal> createState() => _MainScreenFinalState();
}

class _MainScreenFinalState extends State<MainScreenFinal>
    with TickerProviderStateMixin {
  // late List<DiscoveredService> discoveredServices;

  late NetworkModel _networkProvider;

  late List<DiscoveredService> discoveredServices;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> PositioningList;
  late List<String> PositionList;

  DateTime? currentBackPressTime;
  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";

  final String _wallpape = "assets/screens/koriZFinalHome.png";
  final String _fingerIcon = "assets/icons/pushIcon.png";

  late final AnimationController _textAniCon = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _textAniCon,
    curve: Curves.easeOut,
  );

  FToast? fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PositioningList = [];
    PositionList = [];

    discoveredServices = [];

    fToast = FToast();
    fToast?.init(context);

    poseDataUpdate(widget.parsePoseData);
  }

  void poseDataUpdate(dynamic parsePoseData) {
    newPoseData = parsePoseData;
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

  @override
  void dispose() {
    // TODO: implement dispose
    _textAniCon.dispose();
    // subscribeStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (PositionList.isEmpty) {
      PositionList = _networkProvider.getPoseData!;
    } else {
      _networkProvider.getPoseData = PositionList;
    }
    // print(PositionList);
    //
    // print("before : ${widget.viewModel!.deviceConnected}");

    if (widget.viewModel!.deviceConnected == false) {
      widget.viewModel!.connect();
    }

    // print("after : ${widget.viewModel!.deviceConnected}");

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
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ImageIcon(
                            AssetImage('assets/icons/ExaIcon.png'),
                            size: 35,
                            color: Color(0xffB7B7B7),
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          Text(
                            _text,
                            style: TextStyle(fontFamily: 'kor', fontSize: 35),
                          )
                        ],
                      ),
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
        return Future.value(true);
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
                  // Positioned(
                  //   left: 100,
                  //   top: 25,
                  //   child: Column(
                  //     children: [
                  //       Text("id: ${widget.viewModel!.deviceId}"),
                  //       Text("Status: ${widget.viewModel!.connectionStatus}"),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
            // SizedBox(width: screenWidth * 0.03)
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(_wallpape))),
            child: Container(),
          ),
          const MainScreenButtonsFinal(screens: 0),
          Positioned(
              left: 502.5,
              top: 1371.75,
              child: FadeTransition(
                opacity: _animation,
                child: SizedBox(
                  child: ImageIcon(
                    AssetImage(_fingerIcon),
                    color: const Color(0xffB7B7B7),
                    size: 100,
                  ),
                ),
              )),
          Container(
            margin: const EdgeInsets.only(top: 1477.5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '원하는 메뉴를 선택해주세요.',
                  style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 35,
                      color: Color(0xfff0f0f0)),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
