import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:provider/provider.dart';

class PostApi{
  final String? url;
  final String? endadr;
  final String? keyBody;

  PostApi({this.url, this.endadr, this.keyBody});

  void Posting(BuildContext context) async {
    String host = url!;
    String endPoint = endadr!;
    String apiAddress = host + endPoint;
    String apiKeyBody = keyBody!;
    Map postData;

    if (apiKeyBody != 'charging_pile') {
      postData = {"point": apiKeyBody};
      print(apiKeyBody);
      print('apiA');
    } else if (apiKeyBody == 'stop' || apiKeyBody == 'resume') {
      postData = {};
      print('apiB');
    } else {
      postData = {"type": 1, "point": apiKeyBody};
      print('apiC');
      print(apiAddress);
      print(postData);
    }

    var postBody = json.encode(postData);

    NetworkPost network = NetworkPost(apiAddress, postBody);

    Provider.of<NetworkModel>((context), listen: false).APIPostData = await network.postAPI();

    // var postResponse = await network.postAPI();

    // print('apiKeyBody : $apiKeyBody');
    // print('apiAddress : $apiAddress');

    // print("postResponse : $postResponse");
  }

}