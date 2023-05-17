import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
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
  late MainStatusModel _statusProvider;
  late NetworkModel _networkProvider;

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  bool? goalChecker;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
    goalChecker = false;
  }

  @override
  Widget build(BuildContext context) {
    final CountdownController controller = CountdownController(autoStart: true);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    currentGoal = widget.goalPosition;

    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (_statusProvider.serviceState == 0) {
      countDownPopup = 'assets/screens/Shipping/koriZFinalShipCountdown.png';
    } else if (_statusProvider.serviceState == 1) {
      countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
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
                    if (currentGoal != 'chargint_pile') {
                      PostApi(
                          url: startUrl,
                          endadr: navUrl,
                          keyBody: currentGoal).Posting();
                      // _networkProvider.currentGoal = currentGoal;

                      navPage(context: context, page: NavigatorProgressModuleFinal(), enablePop: true).navPageToPage();
                    } else {
                      PostApi(
                          url: startUrl,
                          endadr: chgUrl,
                          keyBody: 'charging_pile').Posting();
                      // _networkProvider.currentGoal = '충전스테이션';

                      navPage(context: context, page: NavigatorProgressModuleFinal(), enablePop: true).navPageToPage();
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
                  if (currentGoal != 'chargint_pile') {
                    PostApi(
                        url: startUrl,
                        endadr: navUrl,
                        keyBody: currentGoal).Posting();
                    _networkProvider.currentGoal = currentGoal;

                    navPage(context: context, page: NavigatorProgressModuleFinal(), enablePop: true).navPageToPage();
                  } else {
                    PostApi(
                        url: startUrl,
                        endadr: chgUrl,
                        keyBody: 'charging_pile').Posting();
                    _networkProvider.currentGoal = '충전스테이션';

                    navPage(context: context, page: NavigatorProgressModuleFinal(), enablePop: true).navPageToPage();
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
