import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:provider/provider.dart';

class PostApi {
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
    } else if (apiKeyBody == 'stop' || apiKeyBody == 'resume') {
      postData = {};
    } else {
      postData = {"type": 1, "point": apiKeyBody};
    }

    var postBody = json.encode(postData);

    NetworkPost network = NetworkPost(apiAddress, postBody);

    Provider.of<NetworkModel>((context), listen: false).APIPostData =
        await network.postAPI();
  }
}
