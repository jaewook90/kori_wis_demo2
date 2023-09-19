import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/unmovableCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityDoneFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/KoriZDocking.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
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
  late MainStatusModel _mainStatusProvider;

  late int hiddenCounter;

  late String backgroundImageServ;

  late String navSentence;
  late String destinationSentence;

  late String targetTableNum;

  late String servTableNum;

  late bool arrivedServingTable;

  late bool _debugMode;

  String? startUrl;
  String? navUrl;
  String? moveBaseStatusUrl;

  late int navStatus;

  late bool initNavStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hiddenCounter = 0;
    navSentence = '';
    destinationSentence = '';
    initNavStatus = true;
    navStatus = 99;
    arrivedServingTable = false;
    targetTableNum = "";

    _debugMode =
        Provider.of<MainStatusModel>((context), listen: false).debugMode!;
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      // 이동 화면 첫 진입 여부 확인
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

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const UnmovableCountDownModalFinal();
        });
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
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    servTableNum = _networkProvider.servTable!;

    if (servTableNum == 'charging_pile') {
      setState(() {
        navSentence = '[이동] 중 입니다';
        destinationSentence = '충전스테이션';
      });
    } else if (servTableNum == 'wait' || servTableNum == '716') {
      setState(() {
        navSentence = '[이동] 중 입니다';
        destinationSentence = '대기장소';
      });
    } else {
      if (_mainStatusProvider.robotServiceMode == 0) {
        setState(() {
          navSentence = '[서빙] 중 입니다';
          destinationSentence = '$servTableNum번 테이블';
        });
      } else if (_mainStatusProvider.robotServiceMode == 1) {
        setState(() {
          navSentence = '[배송] 중 입니다';
          destinationSentence = '${_mainStatusProvider.targetRoomNum} 호';
        });
      } else if (_mainStatusProvider.robotServiceMode == 2) {
        setState(() {
          navSentence = '[안내] 중 입니다';
          destinationSentence =
              '[${_mainStatusProvider.facilityNum![_mainStatusProvider.targetFacilityIndex!]} 호] ${_mainStatusProvider.facilityName![_mainStatusProvider.targetFacilityIndex!]}';
        });
      }
    }

    backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";

    if (_mainStatusProvider.robotServiceMode == 0) {
      if (_servingProvider.targetTableNum != null) {
        targetTableNum = _servingProvider.targetTableNum!;
      }
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
    if (_mainStatusProvider.robotServiceMode == 1) {
        targetTableNum = 'wait';
    }else if (_mainStatusProvider.robotServiceMode == 2) {
      targetTableNum = '716';
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
          Future.delayed(const Duration(milliseconds: 230), () {
            if (_mainStatusProvider.robotServiceMode == 0) {
              navPage(
                context: context,
                page: const ServingProgressFinal(),
              ).navPageToPage();
            } else if (_mainStatusProvider.robotServiceMode == 1) {
              navPage(context: context, page: ShippingDoneFinal())
                  .navPageToPage();
            } else if (_mainStatusProvider.robotServiceMode == 2) {
              // 테스트를 위하여 대기장소 시설1 에서 716으로 변경하여 점검 => 나갈땐 716을 다 시설1로 변경 필요(정지에서도)
              if(servTableNum != '716'){
                navPage(context: context, page: FacilityDoneScreen()).navPageToPage();
              }else{
                navPage(context: context, page: FacilityScreen()).navPageToPage();
              }
            }
          });
        } else if (servTableNum == 'wait') {
          _servingProvider.clearAllTray();
          Future.delayed(const Duration(milliseconds: 230), () {
            if (_mainStatusProvider.robotServiceMode == 0) {
              navPage(context: context, page: TraySelectionFinal())
                  .navPageToPage();
            } else if (_mainStatusProvider.robotServiceMode == 1) {
              navPage(context: context, page: ShippingMenuFinal())
                  .navPageToPage();
            }
          });
        } else if (servTableNum == 'charging_pile') {
          Future.delayed(const Duration(milliseconds: 230), () {
            navPage(
              context: context,
              page: const KoriDocking(),
            ).navPageToPage();
          });
        }
      }
      if (navStatus == 4 && arrivedServingTable == false) {
        setState(() {
          arrivedServingTable = true;
          navStatus = 0;
        });
        showCountDownPopup(context);
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
            SizedBox(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  const AppBarAction(
                    homeButton: false,
                    screenName: "NavigationProgress",
                  ),
                  const AppBarStatus(),
                  Positioned(
                    right: 30,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          hiddenCounter++;
                        });
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            hiddenCounter = 0;
                          });
                        });
                        if (hiddenCounter == 5) {
                          _servingProvider.clearAllTray();
                          if (_mainStatusProvider.robotServiceMode == 0) {
                            navPage(
                                    context: context,
                                    page: TraySelectionFinal())
                                .navPageToPage();
                          } else {
                            navPage(context: context, page: ShippingMenuFinal())
                                .navPageToPage();
                          }
                          if(_mainStatusProvider.robotServiceMode != 2){
                            PostApi(
                                url: startUrl,
                                endadr: navUrl,
                                keyBody: 'wait')
                                .Posting(context);
                          }else{
                            PostApi(
                                url: startUrl,
                                endadr: navUrl,
                                keyBody: '716')
                                .Posting(context);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          // side: BorderSide(color: Colors.white, width: 5),
                          surfaceTintColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledForegroundColor: Colors.transparent,
                          fixedSize: const Size(120, 60),
                          enableFeedback: false,
                          backgroundColor: Colors.transparent),
                      child: null,
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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                  top: 500,
                  left: 0,
                  child: Offstage(
                    offstage: _debugMode,
                    child: GestureDetector(
                        onTap: () {
                          if (arrivedServingTable == false) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                arrivedServingTable = true;
                              });
                              if (servTableNum != 'wait' &&
                                  servTableNum != 'charging_pile') {
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  if (_mainStatusProvider.robotServiceMode ==
                                      0) {
                                    navPage(
                                      context: context,
                                      page: const ServingProgressFinal(),
                                    ).navPageToPage();
                                  } else {
                                    navPage(
                                            context: context,
                                            page: ShippingDoneFinal())
                                        .navPageToPage();
                                  }
                                });
                              } else if (servTableNum == 'wait') {
                                _servingProvider.clearAllTray();
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  if (_mainStatusProvider.robotServiceMode ==
                                      0) {
                                    navPage(
                                            context: context,
                                            page: TraySelectionFinal())
                                        .navPageToPage();
                                  } else {
                                    navPage(
                                            context: context,
                                            page: ShippingMenuFinal())
                                        .navPageToPage();
                                  }
                                });
                              } else if (servTableNum == 'charging_pile') {
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  if (_mainStatusProvider.robotServiceMode ==
                                      0) {
                                    navPage(
                                            context: context,
                                            page: TraySelectionFinal())
                                        .navPageToPage();
                                  } else {
                                    navPage(
                                            context: context,
                                            page: ShippingMenuFinal())
                                        .navPageToPage();
                                  }
                                });
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
                ),
                Positioned(
                    top: 250,
                    child: SizedBox(
                      width: 1080,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            navSentence,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffffefe)),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    top: 372,
                    child: SizedBox(
                      width: 1080,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 65,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            destinationSentence,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'kor',
                                fontSize: 55,
                                color: Color(0xfffffefe)),
                          ),
                        ],
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
