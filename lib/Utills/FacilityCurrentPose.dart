import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/currentPoseInform.dart';
import 'package:provider/provider.dart';

class FacilityCurrentPositionScreen extends StatefulWidget {
  const FacilityCurrentPositionScreen({Key? key}) : super(key: key);

  @override
  State<FacilityCurrentPositionScreen> createState() =>
      _FacilityCurrentPositionScreenState();
}

class _FacilityCurrentPositionScreenState
    extends State<FacilityCurrentPositionScreen> {

  String? startUrl;
  String? chgUrl;
  String? navUrl;

  late double buttonWidth;
  late double buttonHeight;

  late Timer _poseTimer;

  late double robotX;
  late double robotY;
  late double robotTheta;

  late List<double> poseX;
  late List<double> poseY;

  late List<double> mapOrigin;
  late List<double> originMove;

  late double canvasX;
  late double canvasY;

  late double mapX;
  late double mapY;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    robotX = Provider.of<MainStatusModel>(context, listen: false).robotX!;
    robotY = Provider.of<MainStatusModel>(context, listen: false).robotY!;
    robotTheta =
        Provider.of<MainStatusModel>(context, listen: false).robotTheta!;

    _poseTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      CurrentPoseInform(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if ((robotX !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .robotX! ||
              robotY !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .robotY!) ||
          robotTheta !=
              Provider.of<MainStatusModel>(context, listen: false)
                  .robotTheta!) {
        setState(() {});
      }
      robotX = double.parse(Provider.of<MainStatusModel>(context, listen: false)
          .robotX!
          .toStringAsFixed(2));
      robotY = double.parse(Provider.of<MainStatusModel>(context, listen: false)
          .robotY!
          .toStringAsFixed(2));
      robotTheta = double.parse(
          Provider.of<MainStatusModel>(context, listen: false)
              .robotTheta!
              .toStringAsFixed(2));
    });

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
  }

  cordOffice(String axis) {
    if (axis == 'x') {
      double cordX =
          (canvasX * (((robotX / mapX)) + ((mapOrigin[0] / mapX))) - 5);
      return cordX;
    } else if (axis == 'y') {
      double cordY =
          (canvasY * ((robotY / mapY) + ((mapOrigin[1] / mapY))) - 45);
      return cordY;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _poseTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {

    // print(originMove);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 110,
            left: (1080 * 0.1) / 2,
            child: Container(
              width: 972,
              height: 1344,
              child: Stack(children: [
                Positioned(
                    bottom: cordOffice('y'),
                    left: cordOffice('x'),
                    child: Transform.rotate(
                        angle: ((3.14 / 2) - robotTheta),
                        child: Icon(
                          Icons.navigation,
                          color: Colors.redAccent,
                          size: 30,
                        ))),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
