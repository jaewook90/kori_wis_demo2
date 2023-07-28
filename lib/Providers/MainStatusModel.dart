import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  bool? playAd;
  String? testFire;
  dynamic pwrInfo;
  dynamic batInfo;
  dynamic dockingState;

  bool? debugMode;

  MainStatusModel({
    this.playAd,
    this.debugMode
  });

  // 서빙 이송 중 광고 재생 => 메인 프로바이더로 변경
  void playAD() {
    if (playAd == true) {
      playAd = false;
    } else {
      playAd = true;
    }
    notifyListeners();
  }
// 서빙 이송 중 광고 재생
}
