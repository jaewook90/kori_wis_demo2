import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class ChargingStation extends StatefulWidget {
  const ChargingStation({Key? key}) : super(key: key);

  @override
  State<ChargingStation> createState() => _ChargingStationState();
}

class _ChargingStationState extends State<ChargingStation> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  late Timer _pwrTimer;
  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    batData = 0;
    CHGFlag = 8;
    EMGStatus = 1;

    Future.delayed(Duration(milliseconds: 1000),(){
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
          setState(() {
            batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
            CHGFlag =
            Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
            EMGStatus =
            Provider.of<MainStatusModel>(context, listen: false).emgButton!;
          });
        }
      });
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
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (CHGFlag == 1) {
        navPage(context: context, page: TraySelectionFinal()).navPageToPage();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                  right: 46,
                  top: 60,
                  child: Text(('${batData.toString()} %')),
                ),
                Positioned(
                  right: 50,
                  top: 20,
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
                    ? const Positioned(
                        right: 35,
                        top: 15,
                        child: Icon(Icons.block,
                            color: Colors.red,
                            size: 80,
                            grade: 200,
                            weight: 200),
                      )
                    : Container(),
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      _mainStatusProvider.restartService = true;
                      PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                          .Posting(context);
                      Future.delayed(Duration(milliseconds: 500), () {
                        navPage(
                          context: context,
                          page: const TraySelectionFinal(),
                        ).navPageToPage();
                      });
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(90, 90),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Home.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CHGFlag == 2
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.charging_station_outlined,
                          size: 350,
                          color: Colors.white,
                        ),
                        Text(
                          '$batData%',
                          style: TextStyle(
                              height: 1.25,
                              // letterSpacing: 10,
                              fontFamily: 'kor',
                              fontSize: 230,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 60,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            fixedSize: Size(500, 200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        onPressed: () {
                          _mainStatusProvider.restartService = true;
                          PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: 'wait')
                              .Posting(context);
                          Future.delayed(Duration(milliseconds: 500), () {
                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });
                        },
                        child: Text(
                          '서빙 재시작',
                          style: TextStyle(
                              height: 1.25,
                              letterSpacing: 5,
                              fontFamily: 'kor',
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ],
                )
              : CHGFlag == 8
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 400,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              '충전스테이션과 연결 중 입니다',
                              style: TextStyle(
                                  height: 1.25,
                                  letterSpacing: 5,
                                  fontFamily: 'kor',
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
        ],
      ),
    );
  }
}
