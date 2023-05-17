import 'package:flutter/material.dart';

class NetworkModel with ChangeNotifier {
  String startUrl;
  String navUrl = "cmd/nav_point";
  String chgUrl = "cmd/charge";
  String stpUrl = "cmd/cancel_goal";
  String rsmUrl = "cmd/resume_nav";
  String positionURL = "reeman/android_target";
  dynamic getPoseData;
  List<String> goalPosition = [];
  String? currentGoal;
  int? serviceState;
  bool? servingDone;
  bool? shippingDone;

  NetworkModel({
    this.serviceState,
    this.getPoseData,
    this.currentGoal,
    this.servingDone,
    this.shippingDone,
    required this.startUrl
  });

  void hostIP(){
    startUrl = "http://$startUrl/";
    notifyListeners();
  }

}