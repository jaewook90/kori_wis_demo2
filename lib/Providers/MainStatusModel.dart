import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? batBal;
  int? chargeFlag;
  int? emgButton;

  double? robotX;
  double? robotY;
  double? robotTheta;

  bool? robotReturning;

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
  String? lastFacilityNum;
  String? lastFacilityName;
  int? targetFacilityIndex;
  bool? facilityNavDone;

  bool? facilityOfficeSelected;

  List<List<String>>? cordList;

  MainStatusModel({
    this.facilityOfficeSelected,
    this.debugMode,
    this.batBal,
    this.chargeFlag,
    this.emgButton,
    this.restartService,
    this.mainSoundMute,
    this.autoCharge,
    this.facilityDetail,
    this.facilityName,
    this.facilityNum,
    this.facilityNavDone,
    this.lastFacilityNum,
    this.lastFacilityName,
    this.robotX,
    this.robotY,
    this.robotTheta
  });
// 서빙 이송 중 광고 재생
}
