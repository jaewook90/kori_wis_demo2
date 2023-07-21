import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ChangingCountDownModalFinal extends StatefulWidget {
  final String? modeState;

  const ChangingCountDownModalFinal({Key? key, this.modeState})
      : super(key: key);

  @override
  State<ChangingCountDownModalFinal> createState() =>
      _ChangingCountDownModalFinalState();
}

class _ChangingCountDownModalFinalState
    extends State<ChangingCountDownModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  final CountdownController _controller =
      CountdownController(autoStart: true);

  late bool countDownNav;

  late String countDownPopup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownNav = true;
  }

  String? startUrl;
  String? navUrl;

  @override
  Widget build(BuildContext context) {
    countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';

    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

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
                padding: const EdgeInsets.fromLTRB(85, 20, 555, 240),
                child: Countdown(
                  controller: _controller,
                  seconds: 30,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 80,
                        fontWeight: FontWeight.bold),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    if (_servingProvider.targetTableNum != 'none') {
                      setState(() {
                        _servingProvider.trayChange = true;
                        _networkProvider.servTable =
                            _servingProvider.targetTableNum;
                      });
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.targetTableNum)
                          .Posting(context);
                      navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                              enablePop: true)
                          .navPageToPage();
                    } else {
                      _servingProvider.clearAllTray();
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.waitingPoint)
                          .Posting(context);
                      navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                              enablePop: false)
                          .navPageToPage();
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
                  _controller.pause();
                  _networkProvider.servingPosition = [];
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
                  if (widget.modeState == 'return') {
                    PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: _servingProvider.waitingPoint)
                        .Posting(context);
                    navPage(
                            context: context,
                            page: const TraySelectionFinal(),
                            enablePop: false)
                        .navPageToPage();
                  } else if (widget.modeState == 'serving') {
                    if (_servingProvider.targetTableNum != 'none') {
                      setState(() {
                        _servingProvider.trayChange = true;
                        _networkProvider.servTable =
                            _servingProvider.targetTableNum;
                      });
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.targetTableNum)
                          .Posting(context);
                      navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                              enablePop: true)
                          .navPageToPage();
                    } else {
                      _servingProvider.clearAllTray();
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: _servingProvider.waitingPoint)
                          .Posting(context);
                      navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                              enablePop: false)
                          .navPageToPage();
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
