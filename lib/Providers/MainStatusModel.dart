import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? batBal;
  int? chargeFlag;
  int? emgButton;

  int? autoCharge;

  bool? fromDocking;
  // int? movebaseStatus;

  // bool? initNavStatus;
  bool? mainSoundMute;

  bool? restartService;

  bool? debugMode;

  MainStatusModel({
    this.debugMode,
    this.batBal,
    this.chargeFlag,
    this.emgButton,
    this.restartService,
    // this.movebaseStatus,
    this.mainSoundMute,
    this.autoCharge,
    // this.initNavStatus
  });
// 서빙 이송 중 광고 재생
}
