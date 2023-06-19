import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? serviceState;
  bool? playAd;
  String? testFire;

  MainStatusModel({
    this.serviceState,
    this.playAd,
  });

  // 서빙 이송 중 광고 재생 => 메인 프로바이더로 변경
  void playAD(){
    if(playAd == true){
      playAd = false;
    }else{
      playAd = true;
    }
    notifyListeners();
  }
// 서빙 이송 중 광고 재생

}