import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


class BLEModel with ChangeNotifier {
  String? huskyDeviceId;
  Uuid? huskyCharacteristicId;
  Uuid? huskyServiceId;
  String? trayDetectorDeviceId;
  Uuid? trayDetectorCharacteristicId;
  Uuid? trayDetectorServiceId;

  String? trayDetectorTray1;
  String? trayDetectorTray2;
  String? trayDetectorTray3;

  // BLEModel(
  //     {required this.huskyCharacteristicId,
  //     required this.huskyServiceId,
  //     required this.trayDetectorCharacteristicId,
  //     required this.trayDetectorServiceId});
}
