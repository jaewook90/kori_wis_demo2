import 'package:flutter/material.dart';

class NetworkModel with ChangeNotifier {
  String? startUrl;
  String navUrl = "cmd/nav_point";
  String chgUrl = "cmd/charge";
  String stpUrl = "cmd/cancel_goal";
  String rsmUrl = "cmd/resume_nav";
  String positionURL = "reeman/android_target";
  String moveBaseStatusUrl = 'reeman/movebase_status';
  List<String>? getPoseData;
  String? currentGoal;

  dynamic getApiData;

  String? servTable;

  dynamic APIGetData;
  dynamic APIPostData;

  NetworkModel(
      {this.getPoseData,
      this.currentGoal,
      this.startUrl});

  void hostIP() {
    startUrl = "http://$startUrl/";
    notifyListeners();
  }
}
