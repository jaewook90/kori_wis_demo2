import 'dart:convert';

import 'package:kori_wis_demo/Utills/callApi.dart';

class PostApi{
  final String? url;
  final String? endadr;
  final String? keyBody;

  PostApi({this.url, this.endadr, this.keyBody});

  void Posting() async {
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
      postData = {"type": 0, "point": apiKeyBody};
    }

    var postBody = json.encode(postData);

    NetworkPost network = NetworkPost(apiAddress, postBody);

    var postResponse = await network.postAPI();

    print("postResponse : $postResponse");
  }

}