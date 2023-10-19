import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';

class AppBarStatus extends StatefulWidget {
  final double? iconPoseTop;
  final double? iconPoseSide;
  const AppBarStatus({Key? key, this.iconPoseSide, this.iconPoseTop}) : super(key: key);

  @override
  State<AppBarStatus> createState() => _AppBarStatusState();
}

class _AppBarStatusState extends State<AppBarStatus> {
  final String batteryIcon = 'assets/icons/appBar/icon_bettry.svg';

  late Timer _pwrTimer;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if ((EMGStatus !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .emgButton! ||
              CHGFlag !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .chargeFlag!) ||
          batData !=
              Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }
      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag =
          Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus =
          Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(
            left: widget.iconPoseSide == null ? 167*1 : widget.iconPoseSide!, top: widget.iconPoseTop == null ? 11*1 : widget.iconPoseTop!),
        child: Container(
          width: 88*3,
          height: 22*3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 51,
                height: 57.5,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      batteryIcon,
                      width: 42,
                      height: 31.5,
                    ),
                    Text(('${batData.toString()}%'),
                        style: const TextStyle(color: Color(0xff888888), fontSize: 18, letterSpacing: -0.04))
                  ],
                ),
              ),
              EMGStatus == 0
                  ? Stack(children: [
                  Icon(Icons.radio_button_checked,
                      color: Colors.red, size: 66, grade: 200, weight: 200),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 13),
                    child: Text(
                      'EMG',
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.yellow),
                    ),
                  )
                ])
                  : Container(),
              CHGFlag == 3
                  ? const Icon(Icons.bolt, color: Colors.yellow, size: 50)
                  : Container(),
              Container(
                width: 99,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 99,
                      height: 30,
                      child: Text(
                        '10월17일',
                        style: TextStyle(
                          fontSize: 20.5,
                          letterSpacing: -0.05,
                          color: Color(0xff888888),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Container(
                      width: 99,
                      height: 30,
                      child: Text(
                        '15:38',
                        style: TextStyle(
                          fontSize: 20.5,
                          letterSpacing: -0.05,
                          color: Color(0xff888888),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 591, top: 33),
      //   child: Container(
      //     width: 51,
      //     height: 57.5,
      //     child: Column(
      //       children: [
      //         SvgPicture.asset(
      //           batteryIcon,
      //           width: 42,
      //           height: 31.5,
      //         ),
      //         Text(('${batData.toString()}%'),
      //             style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: -0.04))
      //       ],
      //     ),
      //   ),
      // ),
      // Positioned(
      //   right: batteryTextPos,
      //   top: paddingTop+45,
      //   child: Text(('${batData.toString()} %'), style: TextStyle(color: Colors.white)),
      // ),
      // Positioned(
      //   right: batteryImgPos,
      //   top: paddingTop+5,
      //   child: Container(
      //     height: 45,
      //     width: 50,
      //     decoration: const BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage(
      //               'assets/icons/appBar/appBar_Battery.png',
      //             ),
      //             fit: BoxFit.fill)),
      //   ),
      // ),
      // EMGStatus == 0
      //     ? const Padding(
      //         padding: EdgeInsets.only(left: 501, top: 33),
      //         child: Stack(children: [
      //           Icon(Icons.radio_button_checked,
      //               color: Colors.red, size: 66, grade: 200, weight: 200),
      //           Padding(
      //             padding: EdgeInsets.only(top: 20, left: 13),
      //             child: Text(
      //               'EMG',
      //               style: TextStyle(
      //                   fontFamily: 'kor',
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 18,
      //                   color: Colors.yellow),
      //             ),
      //           )
      //         ]),
      //       )
      //     : Container(),
      // CHGFlag == 3
      //     ? const Icon(Icons.bolt, color: Colors.yellow, size: 50)
      //     : Container(),
      // Padding(
      //   padding: EdgeInsets.only(left: 666, top: 33),
      //   child: (Container(
      //     width: 99,
      //     height: 60,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Container(
      //           width: 99,
      //           height: 30,
      //           child: Text(
      //             '10월17일',
      //             style: TextStyle(
      //                 fontSize: 20.5,
      //                 letterSpacing: -0.05,
      //                 color: Color(0xff555555),
      //             ),
      //             textAlign: TextAlign.right,
      //           ),
      //         ),
      //         Container(
      //           width: 99,
      //           height: 30,
      //           child: Text(
      //             '15:38',
      //             style: TextStyle(
      //               fontSize: 20.5,
      //               letterSpacing: -0.05,
      //               color: Color(0xff555555),
      //             ),
      //             textAlign: TextAlign.right,
      //           ),
      //         ),
      //       ],
      //     ),
      //   )),
      // )
    ]);
  }
}
