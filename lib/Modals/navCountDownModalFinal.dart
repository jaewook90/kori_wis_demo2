import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class NavCountDownModalFinal extends StatefulWidget {
  final String? goalPosition;

  const NavCountDownModalFinal({Key? key, this.goalPosition}) : super(key: key);

  @override
  State<NavCountDownModalFinal> createState() => _NavCountDownModalFinalState();
}

class _NavCountDownModalFinalState extends State<NavCountDownModalFinal> {
  late MainStatusModel _statusProvider;
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  late int tableQT;

  late String targetTableNum;

  bool? goalChecker;

  late bool apiCallFlag;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
    goalChecker = false;
    tableQT = 8;
    apiCallFlag = false;
  }

  @override
  Widget build(BuildContext context) {
    final CountdownController controller = CountdownController(autoStart: true);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (_statusProvider.serviceState == 0) {
      countDownPopup = 'assets/screens/Shipping/koriZFinalShipCountdown.png';
      currentGoal = widget.goalPosition;
    } else if (_statusProvider.serviceState == 1) {
      countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
      if(_servingProvider.trayCheckAll == true){
        targetTableNum = _servingProvider.allTable!;
      }else{
        if (_servingProvider.table1 != "") {
          targetTableNum = _servingProvider.table1!;
        }else{
          if (_servingProvider.table2 != "") {
            targetTableNum = _servingProvider.table2!;
          } else{
            if (_servingProvider.table3 != "") {
              targetTableNum = _servingProvider.table3!;
            }
          }
        }
      }
      _servingProvider.targetTableNum = targetTableNum;
    } else if (_statusProvider.serviceState == 2) {
      countDownPopup =
          'assets/screens/Hotel/BellBoy/koriZFinalBellCountDown.png';
    } else if (_statusProvider.serviceState == 3) {
      countDownPopup =
          'assets/screens/Hotel/RoomService/koriZFinalRoomCountDown.png';
    }

    return Container(
        padding: const EdgeInsets.only(top: 607),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 740,
              height: 362,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(countDownPopup), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(130, 10, 0, 0),
                child: Countdown(
                  controller: controller,
                  seconds: 5,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 80,
                        fontWeight: FontWeight.bold),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    if (_statusProvider.serviceState == 0){
                      if (currentGoal != 'chargint_pile') {
                        PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: currentGoal)
                            .Posting(context);
                        navPage(
                            context: context,
                            page: NavigatorProgressModuleFinal(),
                            enablePop: true)
                            .navPageToPage();
                      } else {
                        PostApi(
                            url: startUrl,
                            endadr: chgUrl,
                            keyBody: 'charging_pile')
                            .Posting(context);
                        navPage(
                            context: context,
                            page: NavigatorProgressModuleFinal(),
                            enablePop: true)
                            .navPageToPage();
                      }
                    } else if (_statusProvider.serviceState == 1) {
                      if (apiCallFlag == false) {
                          for (int i = 0; i < tableQT; i++) {
                            if (targetTableNum == "$i") {
                              print('8888');
                              print(_networkProvider.getPoseData);
                              print(_networkProvider.getPoseData[i]);
                              currentGoal = _networkProvider.getPoseData[i];
                            }
                          }
                            PostApi(
                                    url: startUrl,
                                    endadr: navUrl,
                                    keyBody: currentGoal)
                                .Posting(context);
                            navPage(
                                    context: context,
                                    page: NavigatorProgressModuleFinal(
                                      servGoalPose: currentGoal,
                                    ),
                                    enablePop: true)
                                .navPageToPage();
                            apiCallFlag = true;

                      }
                    }
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  _networkProvider.servingPosition = [];
                  Navigator.pop(context);
                },
                child: null,
              ),
            ),
            Positioned(
              left: 370,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  if (_statusProvider.serviceState == 0){
                    if (currentGoal != 'chargint_pile') {
                      PostApi(
                          url: startUrl,
                          endadr: navUrl,
                          keyBody: currentGoal)
                          .Posting(context);
                      navPage(
                          context: context,
                          page: NavigatorProgressModuleFinal(),
                          enablePop: true)
                          .navPageToPage();
                    } else {
                      PostApi(
                          url: startUrl,
                          endadr: chgUrl,
                          keyBody: 'charging_pile')
                          .Posting(context);
                      navPage(
                          context: context,
                          page: NavigatorProgressModuleFinal(),
                          enablePop: true)
                          .navPageToPage();
                    }
                  } else if (_statusProvider.serviceState == 1) {
                    if (apiCallFlag == false) {
                        for (int i = 0; i < tableQT+1; i++) {
                          if (targetTableNum == "$i") {
                            print('8888');
                            print(_networkProvider.getPoseData);
                            print(_networkProvider.getPoseData[i]);
                            currentGoal = _networkProvider.getPoseData[i];
                          }
                        }
                        PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: currentGoal)
                            .Posting(context);
                        navPage(
                            context: context,
                            page: NavigatorProgressModuleFinal(
                              servGoalPose: currentGoal,
                            ),
                            enablePop: true)
                            .navPageToPage();
                        apiCallFlag = true;

                    }
                  }
                },
                child: null,
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
