import 'package:flutter/cupertino.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:provider/provider.dart';

class StatusManagements{
  final BuildContext context;
  final String hostUrl;

  StatusManagements(this.context, this.hostUrl);

  Future<dynamic> gettingPWRdata() async {
    String hostIP = hostUrl;
    String endPoint = 'reeman/base_encode';

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    // 배터리 잔량 퍼센트
    int batBalance = getApiData['battery'];
    //2: chargingPile 3: adapter 8: docking
    int chargeFlage = getApiData['chargeFlag'];
    //0: push, 1: pop
    int emgButtonState = getApiData['emergencyButton'];

    Provider.of<MainStatusModel>(context, listen: false).batBal = batBalance;
    Provider.of<MainStatusModel>(context, listen: false).chargeFlag =
        chargeFlage;
    Provider.of<MainStatusModel>(context, listen: false).emgButton =
        emgButtonState;

    // setState(() {
    // });
  }
}