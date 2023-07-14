import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
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
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late BLEModel _bleProvider;

  final CountdownController _controller =
      new CountdownController(autoStart: true);

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  late int tableQT;

  late bool countDownNav;

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
    countDownNav = true;
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
    if (_servingProvider.trayCheckAll == true) {
      targetTableNum = _servingProvider.allTable!;
    } else {
      if (_servingProvider.table1 != "") {
        targetTableNum = _servingProvider.table1!;
      } else {
        if (_servingProvider.table2 != "") {
          targetTableNum = _servingProvider.table2!;
        } else {
          if (_servingProvider.table3 != "") {
            targetTableNum = _servingProvider.table3!;
          }
        }
      }
    }
    _servingProvider.targetTableNum = targetTableNum;

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
                  controller: _controller,
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
                    _servingProvider.trayChange = true;
                    _networkProvider.servTable =
                        _servingProvider.targetTableNum;
                    PostApi(
                        url: startUrl,
                        endadr: navUrl,
                        keyBody: targetTableNum)
                        .Posting(context);
                    print('타겟 : $targetTableNum');
                    navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(
                        ),
                        enablePop: true)
                        .navPageToPage();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      navPage(
                          context: context,
                          page: const NavigatorProgressModuleFinal(),
                          enablePop: true)
                          .navPageToPage();
                    });
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
                  _controller.pause();
                  _networkProvider.servingPosition = [];
                  setState(() {
                    _bleProvider.onTraySelectionScreen = true;
                  });
                  Navigator.pop(context);
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
                  _controller.pause();
                  _servingProvider.trayChange = true;
                  _networkProvider.servTable =
                      _servingProvider.targetTableNum;
                  PostApi(
                      url: startUrl,
                      endadr: navUrl,
                      keyBody: targetTableNum)
                      .Posting(context);
                  print('타겟 : $targetTableNum');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                        enablePop: true)
                        .navPageToPage();
                  });
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
