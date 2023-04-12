import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkPost {
  final String apiAddress;
  final String keyBody;

  NetworkPost(this.apiAddress, this.keyBody);

  Future<dynamic> postAPI() async {
    var url = apiAddress;

    final String apiBody = keyBody;

    http.Response response = await http.post(Uri.parse(url), body: apiBody);

    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    } else {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      var status = response.statusCode;

      String Error = "$parsingData,\n\nStatus Code : {$status}";
      return Error;
    }
  }
}

class NetworkGet {

  final String apiAddress;

  NetworkGet(this.apiAddress);

  Future<dynamic> getAPI() async {
    var url = apiAddress;

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    } else {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      var status = response.statusCode;

      String Error = "$parsingData,\n\nStatus Code : {$status}";
      return Error;
    }
  }
}
