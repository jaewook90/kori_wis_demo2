import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/changingCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ServingProgressFinal extends StatefulWidget {
  const ServingProgressFinal({Key? key}) : super(key: key);

  @override
  State<ServingProgressFinal> createState() => _ServingProgressFinalState();
}

class _ServingProgressFinalState extends State<ServingProgressFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ChangingCountDownModalFinal(
            modeState: 'serving',
          );
        });
  }

  final CountdownController _controller =
      CountdownController(autoStart: true);

  String backgroundImage = "assets/screens/Serving/koriZFinalServingDone.png";
  String? startUrl;
  String? navUrl;

  late String targetTableNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.pause();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    double screenWidth = 1080;

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: const TraySelectionFinal(),
                                enablePop: false)
                            .navPageToPage();
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
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(children: [
              Countdown(
                controller: _controller,
                seconds: 15,
                build: (_, double time) {
                  return Container();
                },
                interval: const Duration(seconds: 1),
                onFinished: () {
                  showCountDownPopup(context);
                },
              ),
              Positioned(
                top: 450,
                left: 0,
                child: GestureDetector(
                    onTap: () {
                      _controller.pause();
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
                    child: Container(
                        height: 1200,
                        width: 1080,
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                color: Colors.transparent, width: 1))))),
              ),
              Container(
                child: Positioned(
                  left: 107.3,
                  top: 1372.5,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        fixedSize: const Size(866, 160)),
                    child: Container(),
                    onPressed: () {
                      _controller.pause();
                      if (_servingProvider.targetTableNum != 'none') {
                        _servingProvider.trayChange = true;
                        _networkProvider.servTable =
                            _servingProvider.targetTableNum;
                        PostApi(
                                url: startUrl,
                                endadr: navUrl,
                                keyBody: _servingProvider.targetTableNum)
                            .Posting(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          navPage(
                                  context: context,
                                  page: const NavigatorProgressModuleFinal(),
                                  enablePop: true)
                              .navPageToPage();
                        });
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
            ])));
  }
}
