import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:provider/provider.dart';

class AppBarStatus extends StatefulWidget {
  final double? batteryTextPos;
  final double? batteryImgPos;
  final double? EMGImgPos;
  final double? paddingTop;

  const AppBarStatus(
      {Key? key, this.batteryTextPos, this.batteryImgPos, this.EMGImgPos, this.paddingTop})
      : super(key: key);

  @override
  State<AppBarStatus> createState() => _AppBarStatusState();
}

class _AppBarStatusState extends State<AppBarStatus> {
  late Timer _pwrTimer;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late double batteryTextPos;
  late double batteryImgPos;
  late double EMGImgPos;
  late double paddingTop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.batteryTextPos == null){
      batteryTextPos = 46;
    }else{
      batteryTextPos = widget.batteryTextPos!;
    }
    if(widget.batteryImgPos == null){
      batteryImgPos = 50;
    }else{
      batteryImgPos = widget.batteryImgPos!;
    }
    if(widget.EMGImgPos == null){
      EMGImgPos = 245;
    }else{
      EMGImgPos = widget.EMGImgPos!;
    }
    if(widget.paddingTop == null){
      paddingTop = 35;
    }else{
      paddingTop = widget.paddingTop!;
    }

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
      Positioned(
        right: batteryTextPos,
        top: paddingTop+45,
        child: Text(('${batData.toString()} %')),
      ),
      Positioned(
        right: batteryImgPos,
        top: paddingTop+5,
        child: Container(
          height: 45,
          width: 50,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/icons/appBar/appBar_Battery.png',
                  ),
                  fit: BoxFit.fill)),
        ),
      ),
      EMGStatus == 0
          ? Positioned(
              left: EMGImgPos,
              top: paddingTop,
              child: const Stack(children: [
                Icon(Icons.radio_button_checked,
                    color: Colors.red, size: 80, grade: 200, weight: 200),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 12),
                  child: Text(
                    'EMG',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.yellow),
                  ),
                )
              ]),
            )
          : Container(),
      CHGFlag == 3
          ? Positioned(
              right: batteryImgPos,
              top: paddingTop+5,
              child: const Icon(Icons.bolt, color: Colors.yellow, size: 50),
            )
          : Container(),
    ]);
  }
}
