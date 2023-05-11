import 'package:flutter/material.dart';

class BLEModel with ChangeNotifier {
  String deviceId1;
  String? characteristicId;

  BLEModel({
    required this.deviceId1,
    this.characteristicId
  });
}