import 'package:flutter/cupertino.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CurrentPoseInform {
  final BuildContext context;
  final String hostUrl;

  CurrentPoseInform(this.context, this.hostUrl);

  Future<dynamic> gettingPWRdata() async {
    String hostIP = hostUrl;
    String endPoint = 'reeman/pose';

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    // 배터리 잔량 퍼센트
    double robotX = getApiData['x'];
    //2: chargingPile 3: adapter 8: docking
    double robotY = getApiData['y'];
    //0: push, 1: pop
    double robotTheta = getApiData['theta'];

    if (!context.mounted) return;
    Provider.of<MainStatusModel>(context, listen: false).robotX = robotX;
    Provider.of<MainStatusModel>(context, listen: false).robotY = robotY;
    Provider.of<MainStatusModel>(context, listen: false).robotTheta = robotTheta;
  }
}
