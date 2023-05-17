
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/HotelModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:provider/provider.dart';

//BLE 모듈 헤더
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_logger.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_scanner.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_status_monitor.dart';

//허가 유틸 헤더
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await initializeDateFormatting();

  final _ble = FlutterReactiveBle();
  final _bleLogger = BleLogger(ble: _ble);
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );

  Permission.bluetooth.request();
  Permission.location.request();

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
        ChangeNotifierProvider(create: (context)=>MainStatusModel(
          serviceState: 0,
          playAd: false,
        )),
        ChangeNotifierProvider(create: (context)=>NetworkModel(
            startUrl: '172.30.1.22'

        )),
        ChangeNotifierProvider(
            create: (context) => HotelModel(
                trayDebug: false,
                receiptModeOn: false,
                attachedTray1: false,
                attachedTray2: false,
                attachedTray3: false,
                servedItem1: true,
                servedItem2: true,
                servedItem3: true,
                tray1Select: false,
                tray2Select: false,
                tray3Select: false,
                item1: '',
                item2: '',
                item3: '',
                room1: "",
                room2: "",
                room3: "",
                itemImageList: ['a', 'b', 'c'],
                menuItem: "미지정",
                roomNumber: "10"
            )),
        ChangeNotifierProvider(
            create: (context) => ServingModel(
              trayDebug: false,
              receiptModeOn: false,
              attachedTray1: true,
              attachedTray2: true,
              attachedTray3: true,
              servedItem1: true,
              servedItem2: true,
              servedItem3: true,
              tray1Select: false,
              tray2Select: false,
              tray3Select: false,
              item1: '',
              item2: '',
              item3: '',
              table1: "",
              table2: "",
              table3: "",
              itemImageList: ['a', 'b', 'c'],
              menuItem: "미지정",
            )),
        ChangeNotifierProvider(create: (context) => OrderModel(
            orderedChickenPrice: 0,
            orderedChickenQT: 0,
            orderedHamburgerPrice: 0,
            orderedHamburgerQT: 0,
            orderedHotdogPrice: 0,
            orderedHotdogQT: 0,
            orderedRamyeonPrice: 0,
            orderedRamyeonQT: 0,
            orderedTotalPrice: 0
        )),
        ChangeNotifierProvider(create: (context) => BLEModel(
          characteristicId: '6e400002-b5a3-f393-e0a9-e50e24dcca9e',
          deviceId1: 'DF:75:E4:D6:32:63',
        ))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KORi-Z Robot App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff191919),
          // fontFamily: 'kor',
          textTheme: TextTheme(
            //영어폰트용
            titleLarge:
            GoogleFonts.roboto(color: const Color(0xffF0F0F0), fontSize: 45),
            titleMedium:
            GoogleFonts.roboto(color: const Color(0xffB7B7B7), fontSize: 32),
            bodyLarge:
            GoogleFonts.roboto(color: const Color(0xffB7B7B7), fontSize: 28),
            bodyMedium:
            GoogleFonts.roboto(color: const Color(0xffB7B7B7), fontSize: 24),
            bodySmall:
            GoogleFonts.roboto(color: const Color(0xffB7B7B7), fontSize: 20),

            //한글폰트용
            displayLarge: const TextStyle(
              fontFamily: 'kor',
              fontWeight: FontWeight.bold,
              fontSize: 90,
              color: Color(0xffF0F0F0),
            ),

            displayMedium: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 85,
                color: Color(0xffF0F0F0)),

            displaySmall: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 65,
                color: Color(0xffF0F0F0)),
            // 네비게이션모듈 : 배경 글씨, 목적지명

            headlineLarge: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color(0xffF0F0F0)),

            headlineMedium: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xffF0F0F0)),

            headlineSmall: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xffF0F0F0)),
          ),
        ),
        home: IntroScreen(),
      ),
    ),
  );
}
