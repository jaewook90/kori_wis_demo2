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

  bool? facilityArrived;

  List<String>? facilityNum;
  List<String>? facilityName;
  List<String>? facilityDetail;
  String? lastFacilityNum;
  String? lastFacilityName;
  int? targetFacilityIndex;
  bool? facilityNavDone;
  bool? facilityNavDoneScroll;
  bool? facilityNavPause;

  bool? facilitySelectByBTN;

  bool? facilityOfficeSelected;

  bool? facilityOnSearchScreen;

  bool? EMGModalChange;

  bool? audioState;

  List<List<String>>? cordList;

  MainStatusModel({
    this.audioState,
    this.facilityArrived,
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
    this.facilityNavDoneScroll,
    this.facilityNavPause,
    this.lastFacilityNum,
    this.lastFacilityName,
    this.robotX,
    this.robotY,
    this.robotTheta,
    this.facilitySelectByBTN,
    this.facilityOnSearchScreen,
    this.EMGModalChange
  });
// 서빙 이송 중 광고 재생
}
