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
    extends State<FacilityCurrentPositionScreen> with TickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation _animation;

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

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0, end: 10.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

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

    canvasX = 978;
    canvasY = 447*3;

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
          (canvasX * (((robotX / mapX)) + ((mapOrigin[0] / mapX))) - 30);
      return cordX;
    } else if (axis == 'y') {
      double cordY =
          (canvasY * ((robotY / mapY) + ((mapOrigin[1] / mapY))) - 40);
      return cordY;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _poseTimer.cancel();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(originMove);
    return Container(

      // backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 978,
              height: 447*3,
              // decoration: BoxDecoration(
              //   border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 1))
              // ),
              child: Stack(children: [
                Positioned(
                    // bottom: 900,
                    // left: 300,
                    bottom: cordOffice('y'),
                    left: cordOffice('x'),
                    child: Container(
                        width: 100,
                        height: 100,
                        child: Transform.rotate(
                          angle: ((3.14 / 2) - robotTheta),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.teal.withOpacity(0.4),
                                            blurStyle: BlurStyle.solid,
                                            blurRadius: _animation.value,
                                            spreadRadius: _animation.value)
                                      ]),
                                ),
                              ),
                              Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                child:  Icon(
                                            Icons.navigation,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Colors.white, width: 2)
                                  ),
                                    shape: BoxShape.circle,
                                    color: Colors.tealAccent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.tealAccent.withOpacity(0.5),
                                          blurStyle: BlurStyle.solid,
                                          blurRadius: _animation.value,
                                          spreadRadius: (_animation.value+1))
                                    ]),
                              ),
                            ),
                            ]
                          ),
                        )
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
