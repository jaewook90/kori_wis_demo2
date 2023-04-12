import 'package:kori_wis_demo/Utills/callApi.dart';

class GetApi{
  final String? url;
  final String? endadr;

  GetApi({this.url, this.endadr});

  Future<dynamic> Getting() async {
    String host = url!;
    String endPoint = endadr!;
    String apiAddress = host + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    print('b: $getApiData');

    return getApiData;
  }
}