import 'package:flutter/material.dart';

class NetworkModel with ChangeNotifier {
  String? startUrl;
  String navUrl = "cmd/nav_point";
  String chgUrl = "cmd/charge";
  String stpUrl = "cmd/cancel_goal";
  String rsmUrl = "cmd/resume_nav";
  String positionURL = "reeman/android_target";
  List<String>? getPoseData;
  List<String> goalPosition = [];
  List<String> servingPosition = [];
  String? currentGoal;
  int? serviceState;
  bool? servingDone;
  bool? shippingDone;

  dynamic getApiData;

  String? servTable;

  dynamic APIGetData;
  dynamic APIPostData;

  NetworkModel({
    this.serviceState,
    this.getPoseData,
    this.currentGoal,
    this.servingDone,
    this.shippingDone,
    this.startUrl
  });

  void hostIP(){
    startUrl = "http://$startUrl/";
    notifyListeners();
  }

}