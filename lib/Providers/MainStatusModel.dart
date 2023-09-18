import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? batBal;
  int? chargeFlag;
  int? emgButton;

  int? autoCharge;

  bool? fromDocking;

  bool? mainSoundMute;

  bool? restartService;

  bool? debugMode;

  int? robotServiceMode; // 0: 서빙, 1: 택배, 딜리버리

  String? targetRoomNum;

  List<String>? facilityNum;
  List<String>? facilityName;
  List<String>? facilityDetail;
  int? targetFacilityIndex;

  List<List<String>>? cordList;

  MainStatusModel({
    this.debugMode,
    this.batBal,
    this.chargeFlag,
    this.emgButton,
    this.restartService,
    this.mainSoundMute,
    this.autoCharge,
    this.facilityDetail,
    this.facilityName,
    this.facilityNum
  });
// 서빙 이송 중 광고 재생
}
