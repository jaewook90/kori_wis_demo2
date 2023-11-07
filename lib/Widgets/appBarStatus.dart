import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kori_wis_demo/Modals/EmgStatusModal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';

class AppBarStatus extends StatefulWidget {
  final double? iconPoseTop;
  final double? iconPoseSide;

  const AppBarStatus({Key? key, this.iconPoseSide, this.iconPoseTop})
      : super(key: key);

  @override
  State<AppBarStatus> createState() => _AppBarStatusState();
}

class _AppBarStatusState extends State<AppBarStatus> {
  late MainStatusModel _mainStatusProvider;

  final String batteryFrameIcon = 'assets/icons/appBar/icon_bettry_frame.svg';
  final String batteryBalanceIcon =
      'assets/icons/appBar/icon_bettry_balance.svg';
  final String EMGIcon = 'assets/icons/appBar/emgicon.svg';

  late Timer _pwrTimer;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late bool EMGPushed;

  late bool EMGModalChange;

  late bool battery10;
  late bool battery25;
  late bool battery50;
  late bool battery100;

  late bool initFinish;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    battery10 = false;
    battery25 = false;
    battery50 = false;
    battery100 = false;

    EMGModalChange = false;
    EMGPushed = false;

    initFinish = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initFinish = true;
      });
    });
  }

  void showEMGStateModal(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const EMGStateModalScreen();
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
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if(batData < 100){
        battery100 = true;
      if(batData < 51){
        battery50 = true;
        if(batData < 26){
          battery25 = true;
          if(batData <10){
            battery10 = true;
          }else{
            battery10 = false;
          }
        }else{
          battery25 = false;
        }
      }else{
        battery50 = false;
      }
    }else{
      battery100 = false;
    }

    EMGModalChange = _mainStatusProvider.EMGModalChange!;
    if (initFinish == true) {
      if (EMGModalChange == false) {
        if (((EMGStatus == 0 && EMGPushed == false))) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _mainStatusProvider.EMGModalChange = true;
              EMGPushed = true;
            });
            showEMGStateModal(context);
          });
        }
        if ((EMGStatus == 1 && EMGPushed == true)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _mainStatusProvider.EMGModalChange = true;
              EMGPushed = false;
            });
            showEMGStateModal(context);
          });
        }
      }
    }
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(
            left: widget.iconPoseSide == null ? 167 * 1 : widget.iconPoseSide!,
            top: widget.iconPoseTop == null ? 11 * 1 : widget.iconPoseTop!),
        child: Container(
          width: 86 * 3,
          height: 25 * 3,
          // decoration: BoxDecoration(
          //   border: Border.fromBorderSide(BorderSide(color: Colors.teal, width: 1))
          // ),
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EMGStatus == 0
                    ? Container(
                        width: 24 * 3,
                        height: 23 * 3,
                        // decoration: BoxDecoration(
                        //   border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              EMGIcon,
                              width: 14 * 3,
                              height: 14 * 3,
                            ),
                            Text(('비상정지'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'kor',
                                    color: Color(0xffff453a),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.5 * 3,
                                    letterSpacing: -0.12))
                          ],
                        ),
                      )
                    : Container(
                        width: 24 * 3,
                        height: 23 * 3,
                        // decoration: BoxDecoration(
                        //     border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))
                        // ),
                      ),
                Container(
                  width: 15 * 3,
                  height: 21 * 3,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(BorderSide(color: Colors.blue, width: 2))
                  // ),
                  child: Stack(children: [
                    Column(
                      children: [
                        Stack(children: [
                          SvgPicture.asset(
                            batteryFrameIcon,
                            width: 42,
                            height: 31.5,
                          ),
                        ]),
                        Text(('${batData.toString()}'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xff888888),
                                fontSize: 7 * 3,
                                letterSpacing: -0.15))
                      ],
                    ),
                    Positioned(
                      top: 7,
                      left: 3.4,
                      child: Offstage(
                        offstage: battery10,
                        child: SvgPicture.asset(
                          batteryBalanceIcon,
                          width: 2 * 3,
                          height: 5 * 3,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 8.7,
                      child:Offstage(
                        offstage: battery25,
                        child: SvgPicture.asset(
                          batteryBalanceIcon,
                          width: 2 * 3,
                          height: 5 * 3,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 14,
                      child:Offstage(
                        offstage: battery50,
                        child: SvgPicture.asset(
                          batteryBalanceIcon,
                          width: 2 * 3,
                          height: 5 * 3,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 19.3,
                      child: Offstage(
                        offstage: battery100,
                        child: SvgPicture.asset(
                          batteryBalanceIcon,
                          width: 2 * 3,
                          height: 5 * 3,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5.4*3, left: 3.7*3),
                    //   child: SvgPicture.asset(
                    //     batteryBalanceIcon,
                    //     width: 1*3,
                    //     height: 3*3,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 7, left: 5*3),
                    //   child: SvgPicture.asset(
                    //     batteryBalanceIcon,
                    //     width: 2*3,
                    //     height: 5*3,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 2.2*3, left: 6.2*3),
                    //   child: SvgPicture.asset(
                    //     batteryBalanceIcon,
                    //     width: 1*3,
                    //     height: 3*3,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 2.2*3, left: 8.4*3),
                    //   child: SvgPicture.asset(
                    //     batteryBalanceIcon,
                    //     width: 1*3,
                    //     height: 3*3,
                    //   ),
                    // ),
                  ]),
                ),
                // CHGFlag == 3
                //     ? const Icon(Icons.bolt, color: Colors.yellow, size: 50)
                //     : Container(),
                Container(
                  width: 34 * 3,
                  height: 24 * 3,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(BorderSide(color: Colors.green, width: 2))
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 99,
                        height: 30,
                        child: Text(
                          '10월17일',
                          style: TextStyle(
                            fontSize: 8 * 3,
                            letterSpacing: -0.05 * 3,
                            color: Color(0xff555555),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        height: 1 * 3,
                      ),
                      Container(
                        width: 99,
                        height: 30,
                        child: Text(
                          '15:38',
                          style: TextStyle(
                            fontSize: 8 * 3,
                            letterSpacing: -0.05 * 3,
                            color: Color(0xff555555),
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
