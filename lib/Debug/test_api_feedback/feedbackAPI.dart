import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getAPI.dart';
import 'package:provider/provider.dart';

//api 통신용 라이브러리
import 'package:http/http.dart' as http;
import 'dart:convert';

class testAPIFeedback extends StatefulWidget {
  const testAPIFeedback({Key? key}) : super(key: key);

  @override
  State<testAPIFeedback> createState() => _testAPIFeedbackState();
}

class _testAPIFeedbackState extends State<testAPIFeedback> {
  dynamic testAPIData;
  dynamic testAPIDataPost;

  dynamic getDataFlag = false;

  Future<dynamic> Getting() async {
    NetworkGet network =
        NetworkGet("http://172.30.1.35/reeman/movebase_status");

    dynamic getApiData = await network.getAPI();

    // print('b: $getApiData');

    Provider.of<NetworkModel>((context), listen: false).APIGetData = getApiData;

    // print('c: $getApiData');

    setState(() {});
    // return getApiData;
  }

  void Posting(url, String command) async {
    String apiAddress = url;
    Map postData;

    if (command == '출발') {
      postData = {"point": "3"};
    } else if (command == '정지') {
      postData = {};
    } else if (command == '충전') {
      postData = {"type": 0, "point": "charging_pile"};
    } else {
      postData = {};
    }

    print(postData);

    var postBody = json.encode(postData);

    NetworkPost network = NetworkPost(apiAddress, postBody);

    // var postResponse = await network.postAPI();

    Provider.of<NetworkModel>((context), listen: false).APIPostData =
        await network.postAPI();
  }

  @override
  Widget build(BuildContext context) {
    Getting();

    // status 0: 오류 1: 주행 2: 정지 3: 완료
    testAPIData =
        Provider.of<NetworkModel>((context), listen: false).APIGetData;

    testAPIDataPost =
        Provider.of<NetworkModel>((context), listen: false).APIPostData;

    // print(testAPIDataPost);

    return Scaffold(
      appBar: AppBar(
        title: Text('api 피드백 테스트'),
      ),
      body: Column(
        children: [
          Text(
            '${testAPIData}',
            style: TextStyle(fontSize: 150),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 출발
              FilledButton(
                  onPressed: () {
                    Posting('http://172.30.1.35/cmd/nav_point', '출발');
                  },
                  style: FilledButton.styleFrom(fixedSize: Size(150, 150)),
                  child: Text('출발')),
              // 정지
              FilledButton(
                  onPressed: () {
                    Posting('http://172.30.1.35/cmd/cancel_goal', '정지');
                  },
                  style: FilledButton.styleFrom(fixedSize: Size(150, 150)),
                  child: Text('정지')),
              FilledButton(
                  onPressed: () {
                    Posting('http://172.30.1.35/cmd/charge', '충전');
                  },
                  style: FilledButton.styleFrom(fixedSize: Size(150, 150)),
                  child: Text('충전'))
            ],
          ),
          Text(
            '${testAPIDataPost}',
            style: TextStyle(fontSize: 130),
          ),
        ],
      ),
    );
  }
}
