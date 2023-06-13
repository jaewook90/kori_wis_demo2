import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEModel with ChangeNotifier {
  String? huskyDeviceId;
  Uuid? huskyCharacteristicId;
  Uuid? huskyServiceId;
  String? trayDetectorDeviceId;
  Uuid? trayDetectorCharacteristicId;
  Uuid? trayDetectorServiceId;



  bool? onTraySelectionScreen;

  String? subscribeOutput;

  BLEModel({this.subscribeOutput});

// BLEModel(
//     {required this.huskyCharacteristicId,
//     required this.huskyServiceId,
//     required this.trayDetectorCharacteristicId,
//     required this.trayDetectorServiceId});
}
