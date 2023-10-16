import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class pathFindingTest extends StatefulWidget {
  const pathFindingTest({Key? key}) : super(key: key);

  @override
  State<pathFindingTest> createState() => _pathFindingTestState();
}

class _pathFindingTestState extends State<pathFindingTest> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;

  // 배경 화면
  late String backgroundImage;

  late bool _debugTray;

  String? startUrl;
  String? chgUrl;
  String? navUrl;

  late double buttonWidth;
  late double buttonHeight;

  late List<double> poseX;
  late List<double> poseY;

  late List<double> mapOrigin;
  late List<double> originMove;

  late double canvasX;
  late double canvasY;

  late double mapX;
  late double mapY;

  dynamic newPoseData;
  dynamic poseData;
  dynamic newCordData;
  dynamic cordData;

  late List<String> positioningList;
  late List<String> positionList;
  late List<String> positioningCordList;
  late List<String> positioningSeparatedCordList;
  late List<List<String>> positionCordList;

  late List<double> editCord;
  late List<List<double>> editCordList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('-----------------path draw screen-----------------');

    officeQTY = 0;

    backgroundImage = "assets/screens/Facility/FacilityMain.png";

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    positioningList = [];
    positionList = [];
    positioningSeparatedCordList = [];
    positioningCordList = [];
    positionCordList = [];

    officeNum = [];
    officeName = [];

    canvasX = 972;
    canvasY = 1344;

    buttonWidth = 100;
    buttonHeight = 30;

    poseX = [];
    poseY = [];
    originMove = [];

    mapX = 44.8;
    mapY = 100.5;

    mapOrigin = [3.1, 63.36];

    originMove.add(mapOrigin[0] / mapX);
    originMove.add(mapOrigin[1] / mapY);

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }
  }

  cordOffice(String axis, int num) {
    if (axis == 'x') {
      double cordX =
          (canvasX * (((poseX[num]) / mapX) + ((mapOrigin[0] / mapX)))) + 5;
      return cordX;
    } else if (axis == 'y') {
      double cordY =
          (canvasY * (((poseY[num]) / mapY) + ((mapOrigin[1] / mapY)))) - 10;
      return cordY;
    }
  }

  cordLinePainter(String axis, int num) {
    if (axis == 'x') {
      double cordX =
         972*((((poseX[num]) / mapX) + ((mapOrigin[0] / mapX)))) + 10;
      return cordX;
    } else if (axis == 'y') {
      double cordY =
          1374*(1-(((poseY[num]) / mapY) + ((mapOrigin[1] / mapY)))) - 20;
      return cordY;
    }
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {
      positionList = [];
      positionCordList = [];
      poseDataUpdate();
    });
  }

  void poseDataUpdate() {
    newPoseData = Provider.of<NetworkModel>(context, listen: false).getApiData;
    if (newPoseData != null) {
      poseData = newPoseData;
      cordData = newPoseData;
      String editPoseData = poseData.toString();

      editPoseData = editPoseData.replaceAll('{', "");
      editPoseData = editPoseData.replaceAll('}', "");

      List<String> positionWithCordList = editPoseData.split("], ");

      String editCordData = cordData.toString();

      editCordData = editCordData.replaceAll('{', "");
      editCordData = editCordData.replaceAll('}', "");
      List<String> cordWithNumList = editCordData.split("]");

      for (int i = 0; i < positionWithCordList.length; i++) {
        positioningList = positionWithCordList[i].split(":");
        for (int j = 0; j < positioningList.length; j++) {
          if (j == 0) {
            if (!positioningList[j].contains('[')) {
              poseData = positioningList[j];
              positionList.add(poseData);
            }
          }
        }
      }
      for (int h = 0; h < cordWithNumList.length - 1; h++) {
        positioningCordList = cordWithNumList[h].split(": [");
        positioningSeparatedCordList = positioningCordList[1].split(', ');
        positioningSeparatedCordList.removeAt(2);
        if (positionList[h] != 'charging_pile') {
          positionCordList.add(positioningSeparatedCordList);
        }
      }
      positionList.sort();
    } else {
      positionList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (positionList.isEmpty) {
      positionList = _networkProvider.getPoseData!;
      positionCordList = _mainStatusProvider.cordList!;
    } else {
      _networkProvider.getPoseData = positionList;
      _mainStatusProvider.cordList = positionCordList;
    }

    _debugTray = _mainStatusProvider.debugMode!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      officeQTY =
          Provider.of<MainStatusModel>(context, listen: false).cordList!.length;

      print(officeQTY);

      if (poseX.isEmpty || poseY.isEmpty) {
        for (int h = 0; h < officeQTY; h++) {
          poseX.add(double.parse(
              Provider.of<MainStatusModel>(context, listen: false).cordList![h]
              [0]));
          poseY.add(double.parse(
              Provider.of<MainStatusModel>(context, listen: false).cordList![h]
              [1]));
        }
      }
    });

    // print(originMove);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            // 수동 위치 입력
            Positioned(
                top: 150,
                left: 835,
                child: GestureDetector(
                  child: Container(
                    width: 180,
                    height: 320,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 480,
                left: 850,
                child: GestureDetector(
                  child: Container(
                    width: 170,
                    height: 275,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 770,
                left: 850,
                child: GestureDetector(
                  child: Container(
                    width: 165,
                    height: 75,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 855,
                left: 850,
                child: GestureDetector(
                  child: Container(
                    width: 165,
                    height: 70,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 935,
                left: 860,
                child: GestureDetector(
                  child: Container(
                    width: 160,
                    height: 165,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 1110,
                left: 875,
                child: GestureDetector(
                  child: Container(
                    width: 145,
                    height: 360,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 1220,
                left: 60,
                child: GestureDetector(
                  child: Container(
                    width: 395,
                    height: 250,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 1050,
                left: 60,
                child: GestureDetector(
                  child: Container(
                    width: 500,
                    height: 160,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 745,
                left: 60,
                child: GestureDetector(
                  child: Container(
                    width: 440,
                    height: 295,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 655,
                left: 325,
                child: GestureDetector(
                  child: Container(
                    width: 175,
                    height: 80,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 520,
                left: 60,
                child: GestureDetector(
                  child: Container(
                    width: 215,
                    height: 215,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 150,
                left: 60,
                child: GestureDetector(
                  child: Container(
                    width: 435,
                    height: 320,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 150,
                left: 515,
                child: GestureDetector(
                  child: Container(
                    width: 245,
                    height: 320,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 520,
                left: 362,
                child: GestureDetector(
                  child: Container(
                    width: 140,
                    height: 90,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 800,
                left: 575,
                child: GestureDetector(
                  child: Container(
                    width: 215,
                    height: 60,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 520,
                left: 565,
                child: GestureDetector(
                  child: Container(
                    width: 210,
                    height: 95,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 1270,
                left: 655,
                child: GestureDetector(
                  child: Container(
                    width: 150,
                    height: 60,
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.transparent))),
                  ),
                  onTap: () {},
                )),
            Positioned(
                top: 145,
                left: (1080 * 0.1) / 2,
                child: Container(
                    width: 972,
                    height: 1344,
                    decoration: BoxDecoration(
                      border: const Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 2)),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i < officeQTY; i++)
                          Positioned(
                              bottom: cordOffice('y', i),
                              left: cordOffice('x', i),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Colors.tealAccent,
                                  ),
                                  Text(
                                    i.toString(),
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  )
                                ],
                              )),
                      ],
                    ))),
            Positioned(
              top: 145,
              left: (1080 * 0.1) / 2,
              child: Stack(
                  children: [
                    CustomPaint(
                      painter: LinePainter(startPoint: Offset(cordLinePainter('x', 0), cordLinePainter('y', 0)), endPoint:Offset(cordLinePainter('x', 1), cordLinePainter('y', 1))),
                      size: Size(972, 1344),
                    ),
                  ]
              ),
            ),
            Positioned(
              top: 145,
              left: (1080 * 0.1) / 2,
              child: Stack(
                children: [
                  officeQTY != null?
                  CustomPaint(
                  painter: LinePainter(startPoint: Offset(cordLinePainter('x', 0), cordLinePainter('y', 0)), endPoint:Offset(cordLinePainter('x', 12), cordLinePainter('y', 12))),
                  size: Size(972, 1344),
                ) : Container(),
                ]
              ),
            ),
            Positioned(
                top: 45,
                left: 450,
                child: IconButton(
                  icon: Icon(Icons.home),
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: () {
                    navPage(context: context, page: FacilityScreen())
                        .navPageToPage();
                  },
                ))
          ],
        ),
      ),
    );
  }
}

// class LinePainter extends CustomPainter {
//   List<Offset> points;
//
//   LinePainter({required this.points})
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p1 = Offset(50, 50);
//     final p2 = Offset(250, 150);
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4;
//     canvas.drawLine(p1, p2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class LinePainter extends CustomPainter {
  Offset endPoint;
  Offset startPoint;

  LinePainter({required this.startPoint, required this.endPoint});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 15;

    Offset start = startPoint;
    Offset end = endPoint;

    print('start : $start');
    print('end : $end');

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
