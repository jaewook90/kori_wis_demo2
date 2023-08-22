import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/PatrolProg.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class NavigationPatrol extends StatefulWidget {
  const NavigationPatrol({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationPatrol> createState() => _NavigationPatrolState();
}

class _NavigationPatrolState extends State<NavigationPatrol> {
  late ServingModel _servingProvider;

  late Timer _pwrTimer;
  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late int buttonNumbers;

  late String patrolPoints1;
  late String patrolPoints2;

  int buttonWidth = 0;
  int buttonHeight = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patrolPoints1 = '';
    patrolPoints2 = '';

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      if (batData !=
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
    _pwrTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    double screenWidth = 1080;

    buttonPositionWidth = [205, 205, 205, 205, 585, 585, 585, 585];
    buttonPositionHeight = [
      245.5,
      565.6,
      870.7,
      1178,
      245.5,
      565.6,
      870.7,
      1178
    ];

    buttonSize = [208, 118];

    buttonRadius = 0;

    buttonNumbers = buttonPositionHeight.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: screenWidth,
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
                      setState(() {
                        _servingProvider.mainInit = true;
                      });
                      navPage(
                        context: context,
                        page: const TraySelectionSec(),
                      ).navPageToPage();
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
                                'assets/icons/appBar/appBar_Backward.png',
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
      body: Stack(children: [
        Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xff191919),
          child: Stack(
            children: [
              Container(
                width: 1080,
                height: 170,
                margin: const EdgeInsets.only(top: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            patrolPoints1 = '';
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(220, 150),
                            side: const BorderSide(color: Colors.white, width: 1)),
                        child: Text(
                          patrolPoints1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'kor'),
                        )),
                    const SizedBox(
                        width: 120,
                        height: 120,
                        child: Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: 120,
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            patrolPoints2 = '';
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(220, 150),
                            side: const BorderSide(color: Colors.white, width: 1)),
                        child: Text(
                          patrolPoints2,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'kor'),
                        ))
                  ],
                ),
              ),
              Container(
                height: 330,
                width: 1080,
                margin: const EdgeInsets.only(top: 370),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: PatrolProgress(
                                    patrol1: patrolPoints1,
                                    patrol2: patrolPoints2))
                            .navPageToPage();
                      },
                      style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 1),
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(),
                          fixedSize: const Size(220, 150)),
                      child: const Text(
                        '출발',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'kor',
                            fontSize: 70),
                      ),
                    )
                  ],
                ),
              ),
              for (int i = 0; i < buttonNumbers; i++)
                Container(
                  margin: const EdgeInsets.only(top: 700),
                  padding: const EdgeInsets.only(bottom: 250, top: 10),
                  height: 1220,
                  width: 1080,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int j = 0; j < (buttonNumbers / 2); j++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int h = 0; h < 2; h++)
                              FilledButton(
                                  onPressed: () {
                                    if (patrolPoints1 == '') {
                                      setState(() {
                                        patrolPoints1 = '${2 * j + h + 1}';
                                      });
                                    } else if (patrolPoints2 == '') {
                                      setState(() {
                                        patrolPoints2 = '${2 * j + h + 1}';
                                      });
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(
                                              buttonRadius)),
                                      fixedSize: Size(buttonSize[buttonWidth],
                                          buttonSize[buttonHeight])),
                                  child: Text(
                                    '${2 * j + h + 1} 번',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'kor',
                                        fontSize: 40),
                                  ))
                          ],
                        )
                    ],
                  ),
                )
            ],
          ),
        ),
      ]),
    );
  }
}
