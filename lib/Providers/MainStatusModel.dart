import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? batBal;
  int? chargeFlag;
  int? emgButton;

  bool? mainSoundMute;

  bool? restartService;

  bool? debugMode;

  MainStatusModel({
    this.debugMode,
    this.batBal,
    this.chargeFlag,
    this.emgButton,
    this.mainSoundMute
  });
// 서빙 이송 중 광고 재생
}
