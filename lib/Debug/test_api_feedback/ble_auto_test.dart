import 'dart:async';
import 'dart:typed_data';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

part 'ble_auto_test.g.dart';
//ignore_for_file: annotate_overrides

class BLEAutoConnect extends StatelessWidget {
  const BLEAutoConnect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiscoveredDevice device = DiscoveredDevice(
        id: 'F0:28:31:D5:10:D0',
        name: 'BBC micro:bit',
        serviceData: {},
        rssi: 0,
        serviceUuids: [],
        manufacturerData: Uint8List(0));
    return Consumer3<BleDeviceConnector,
        ConnectionStateUpdate,
        BleDeviceInteractor>(
      builder:
          (_, deviceConnector, connectionStateUpdate, serviceDiscoverer, __) =>
          BLEAutoTest(
            viewModel: BLEAutoViewModel(
                deviceId: device.id,
                connectionStatus: connectionStateUpdate.connectionState,
                deviceConnector: deviceConnector,
                discoverServices: () =>
                    serviceDiscoverer.discoverServices(device.id)),
          ),
    );
  }
}

@immutable
@FunctionalData()
class BLEAutoViewModel extends $BLEAutoViewModel {
  const BLEAutoViewModel({
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

class BLEAutoTest extends StatefulWidget {
  const BLEAutoTest({this.viewModel,
    // this.subscribeToCharacteristic,
    Key? key}) : super(key: key);

  final BLEAutoViewModel? viewModel;
  // final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
  // subscribeToCharacteristic;

  @override
  State<BLEAutoTest> createState() => _BLEAutoTestState();
}

class _BLEAutoTestState extends State<BLEAutoTest> {
  late List<DiscoveredService> discoveredServices;
  // late final QualifiedCharacteristic? characteristic;

  // late final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
  // subscribeToCharacteristic;

  // late StreamSubscription<List<int>>? subscribeStream;
  // late String subscribeOutput;


  @override
  void initState() {
    discoveredServices = [];
    super.initState();

    // subscribeOutput = '';
    // if(characteristic == null){
    //   subscribeStream = null;
    // }
  }
  //
  // Future<void> discoverServices1() async {
  //   final result = await widget.viewModel!.discoverServices();
  //   setState(() {
  //     discoveredServices = result;
  //   });
  // }

  // Future<void> subscribeCharacteristic() async {
  //   subscribeStream =
  //       widget.subscribeToCharacteristic!(characteristic!).listen((event) {
  //         if(utf8.decode(event) != subscribeOutput){
  //           setState(() {
  //             subscribeOutput = utf8.decode(event);
  //             // tray1BLE = subscribeOutput.split('')[0];
  //             // tray2BLE = subscribeOutput.split('')[1];
  //             // tray3BLE = subscribeOutput.split('')[2];
  //             print(subscribeOutput);
  //             if(subscribeOutput != 'Notification set'){
  //               subscribeStream!.cancel();
  //             }
  //           });
  //         }
  //       });
  //   setState(() {
  //     subscribeOutput = 'Notification set';
  //     // subscribeCharacteristic();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
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
                      Navigator.pop(context);
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
                          page: const MainScreenFinal(),
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
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Stack(
            children: [
              Positioned(
                  top: 200,
                  width: 980,
                  child: Text(widget.viewModel!.deviceId)),
              Positioned(
                  top: 600,
                  width: 980,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(300, 150),
                            side:
                            BorderSide(color: Colors.tealAccent, width: 3)),
                        child: Text('연결',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 80,
                                color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            widget.viewModel!.connect();
                          });
                        },
                      ),
                      Text("Status: ${widget.viewModel!.connectionStatus}")
                    ],
                  )),
              Positioned(
                  top: 850,
                  width: 980,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(300, 150),
                            side:
                            BorderSide(color: Colors.tealAccent, width: 3)),
                        child: Text('구독',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 80,
                                color: Colors.white)),
                        onPressed: () {
                          // setState(() {
                          //   characteristic = QualifiedCharacteristic(
                          //       characteristicId: Uuid.parse(
                          //           '6e400002-b5a3-f393-e0a9-e50e24dcca9e'),
                          //       serviceId: Uuid.parse(
                          //           '6e400002-b5a3-f393-e0a9-e50e24dcca9e'),
                          //       deviceId: widget.viewModel!.deviceId);
                          // });
                          // print(characteristic);
                          // subscribeCharacteristic();
                        },
                      ),
                      Text('data')
                    ],
                  )),
              Positioned(
                  top: 1100,
                  width: 980,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(300, 150),
                            side:
                            BorderSide(color: Colors.tealAccent, width: 3)),
                        child: Text('연결 및 구독',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 40,
                                color: Colors.white)),
                        onPressed: () {},
                      ),
                      Text('data')
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
