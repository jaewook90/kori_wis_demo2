import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:provider/provider.dart';

class GetApi{
  final String? url;
  final String? endadr;

  GetApi({this.url, this.endadr});

  Future<dynamic> Getting(BuildContext context) async {
    // String host = url!;
    // String endPoint = endadr!;
    // String apiAddress = host + endPoint;

    String apiAddress = "http://172.30.1.35/reeman/movebase_status";

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    // print('b: $getApiData');

    Provider.of<NetworkModel>((context), listen: false).APIGetData = getApiData;

    // return getApiData;
  }
}