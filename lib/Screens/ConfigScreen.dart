import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

import 'MainScreenFinal.dart';

part 'ConfigScreen.g.dart';
//ignore_for_file: annotate_overrides

class ConfigScreenDeviceConnect extends StatelessWidget {
  final String deviceId;

  const ConfigScreenDeviceConnect({
    required this.deviceId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
        builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                __) =>
            ConfigScreen(
          viewModel: DeviceInteractionViewModel(
              deviceId: deviceId,
              connectionStatus: connectionStateUpdate.connectionState,
              deviceConnector: deviceConnector,
              discoverServices: () =>
                  serviceDiscoverer.discoverServices(deviceId)),
        ),
      );
}

@immutable
@FunctionalData()
class DeviceInteractionViewModel extends $DeviceInteractionViewModel {
  const DeviceInteractionViewModel({
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

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key, required this.viewModel}) : super(key: key);

  final DeviceInteractionViewModel viewModel;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) =>
      Consumer<BleStatus?>(builder: (_, status, __) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        print(widget.viewModel!.deviceConnected);

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
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ID: ${widget.viewModel.deviceId}"),
                Text(
                  "Status: ${widget.viewModel.deviceConnected}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: TextButton(
                      onPressed: () {
                        print(widget.viewModel);
                        if (widget.viewModel!.deviceConnected == false) {
                          setState(() {
                            widget.viewModel!.connect;
                          });
                        }
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
      });
}
