import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class NavigatorProgressModuleFinal extends StatefulWidget {
  const NavigatorProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorProgressModuleFinal> createState() =>
      _NavigatorProgressModuleFinalState();
}

class _NavigatorProgressModuleFinalState
    extends State<NavigatorProgressModuleFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late String backgroundImageServ;

  late String targetTableNum;

  late String servTableNum;

  late bool arrivedServingTable;

  String? startUrl;
  String? navUrl;
  String? moveBaseStatusUrl;

  late int navStatus;

  late bool initNavStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNavStatus = true;
    navStatus = 0;
    arrivedServingTable = false;
    targetTableNum = "";
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      if (getApiData == 3) {
        while (getApiData != 3) {
          if (mounted) {
            Provider.of<NetworkModel>((context), listen: false).APIGetData =
                getApiData;
            setState(() {
              navStatus = Provider.of<NetworkModel>((context), listen: false)
                  .APIGetData['status'];
              initNavStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          Provider.of<NetworkModel>((context), listen: false).APIGetData =
              getApiData;
          setState(() {
            navStatus = Provider.of<NetworkModel>((context), listen: false)
                .APIGetData['status'];
            initNavStatus = false;
          });
        }
      }
    } else {
      if (mounted) {
        Provider.of<NetworkModel>((context), listen: false).APIGetData =
            getApiData;
        setState(() {
          navStatus = Provider.of<NetworkModel>((context), listen: false)
              .APIGetData['status'];
          initNavStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    servTableNum = _networkProvider.servTable!;

    backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";

    if (_servingProvider.targetTableNum != null) {
      targetTableNum = _servingProvider.targetTableNum!;
    }

    setState(() {
      if (targetTableNum == _servingProvider.table1) {
        _servingProvider.table1 = "";
        _servingProvider.item1 = '';
      } else if (targetTableNum == _servingProvider.table2) {
        _servingProvider.table2 = "";
      } else if (targetTableNum == _servingProvider.table3) {
        _servingProvider.table3 = "";
      }
    });
    if (_servingProvider.trayChange == true) {
      if (_servingProvider.table1 != "" &&
          _servingProvider.trayChange == true) {
        targetTableNum = _servingProvider.table1!;
        _servingProvider.trayChange = false;
      } else {
        if (_servingProvider.table2 != "" &&
            _servingProvider.trayChange == true) {
          targetTableNum = _servingProvider.table2!;
          _servingProvider.trayChange = false;
        } else {
          if (_servingProvider.table3 != "" &&
              _servingProvider.trayChange == true) {
            targetTableNum = _servingProvider.table3!;
            _servingProvider.trayChange = false;
          } else {
            if (targetTableNum == 'wait') {
              targetTableNum = 'none';
              _servingProvider.trayChange = false;
            } else {
              targetTableNum = 'wait';
              _servingProvider.trayChange = false;
            }
          }
        }
      }
    }
    _servingProvider.targetTableNum = targetTableNum;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Getting(startUrl!, moveBaseStatusUrl!);
      });
      if (navStatus == 3 && arrivedServingTable == false) {
        setState(() {
          arrivedServingTable = true;
          navStatus = 0;
        });
        if (servTableNum != 'wait' && servTableNum != 'charging_pile') {
          navPage(
                  context: context,
                  page: const ServingProgressFinal(),
                  enablePop: false)
              .navPageToPage();
        } else if (servTableNum == 'wait') {
          _servingProvider.clearAllTray();
          navPage(
                  context: context,
                  page: const TraySelectionFinal(),
                  enablePop: false)
              .navPageToPage();
        } else if (servTableNum == 'charging_pile') {
          navPage(
                  context: context,
                  page: const TraySelectionFinal(),
                  enablePop: false)
              .navPageToPage();
        }
      }
    });

    double screenWidth = 1080;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
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
                      ))
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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                  top: 500,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        if (arrivedServingTable == false) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              arrivedServingTable = true;
                            });
                            if (servTableNum != 'wait' &&
                                servTableNum != 'charging_pile') {
                              navPage(
                                      context: context,
                                      page: const ServingProgressFinal(),
                                      enablePop: false)
                                  .navPageToPage();
                            } else if (servTableNum == 'wait') {
                              _servingProvider.clearAllTray();
                              navPage(
                                      context: context,
                                      page: const TraySelectionFinal(),
                                      enablePop: false)
                                  .navPageToPage();
                            } else if (servTableNum == 'charging_pile') {
                              navPage(
                                      context: context,
                                      page: const TraySelectionFinal(),
                                      enablePop: false)
                                  .navPageToPage();
                            }
                          });
                        }
                      },
                      child: Container(
                          height: 800,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.transparent, width: 1))))),
                ),
                Positioned(
                    top: 372,
                    left: 460,
                    child: Container(
                      width: 300,
                      height: 90,
                      child: Text(
                        servTableNum == 'charging_pile'
                            ? '충전스테이션'
                            : servTableNum == 'wait'
                                ? '대기장소'
                                : '$servTableNum번 테이블',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                NavModuleButtonsFinal(
                  screens: 0,
                  servGoalPose: servTableNum,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
