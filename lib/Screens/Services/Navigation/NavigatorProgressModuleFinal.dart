import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class NavigatorProgressModuleFinal extends StatefulWidget {
  final String? servGoalPose;

  const NavigatorProgressModuleFinal({
    this.servGoalPose,
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorProgressModuleFinal> createState() =>
      _NavigatorProgressModuleFinalState();
}

class _NavigatorProgressModuleFinalState
    extends State<NavigatorProgressModuleFinal> {
  late MainStatusModel _statusProvider;
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late String backgroundImageServ;

  late String targetTableNum;

  late String servTableNum;

  String? startUrl;
  String? navUrl;

  late int navStatus;

  Future<dynamic> Getting() async {
    NetworkGet network =
        NetworkGet("http://172.30.1.22/reeman/movebase_status");

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>((context), listen: false).APIGetData = getApiData;

    setState(() {
      navStatus = Provider.of<NetworkModel>((context), listen: false)
          .APIGetData['status'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navStatus = 0;
    servTableNum = "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    if(widget.servGoalPose != null){
      servTableNum = widget.servGoalPose!;
    }

    print('form navCount');
    print(widget.servGoalPose);
    print('form navCount');

    if (_statusProvider.serviceState == 0) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalShipProgNav.png";
    } else if (_statusProvider.serviceState == 1) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";
    } else if (_statusProvider.serviceState == 2) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalBellProgNav.png";
    } else if (_statusProvider.serviceState == 3) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalRoomProgNav.png";
    }

    if (_servingProvider.targetTableNum != null) {
      targetTableNum = _servingProvider.targetTableNum!;
    }

    setState(() {
      if (targetTableNum == _servingProvider.table1) {
        print('table1');
        _servingProvider.table1 = "";
      } else if (targetTableNum == _servingProvider.table2) {
        print('table2');
        _servingProvider.table2 = "";
      } else if (targetTableNum == _servingProvider.table3) {
        print('table3');
        _servingProvider.table3 = "";
      }
    });
    if (_servingProvider.trayChange == true) {
      if (_servingProvider.table1 != "" &&
          _servingProvider.trayChange == true) {
        print('aaa');
        targetTableNum = _servingProvider.table1!;
        _servingProvider.trayChange = false;
      } else {
        if (_servingProvider.table2 != "" &&
            _servingProvider.trayChange == true) {
          print('bbb');
          print(_servingProvider.table2);
          targetTableNum = _servingProvider.table2!;
          _servingProvider.trayChange = false;
        } else {
          if (_servingProvider.table3 != "" &&
              _servingProvider.trayChange == true) {
            print('ccc');
            targetTableNum = _servingProvider.table3!;
            _servingProvider.trayChange = false;
          } else {
            targetTableNum = 'none';
            _servingProvider.trayChange = false;
          }
        }
      }
    }
    _servingProvider.targetTableNum = targetTableNum;
    print('48465435');
    print(targetTableNum);

    Getting();

    if (navStatus == 0) {
      PostApi(url: startUrl, endadr: navUrl, keyBody: targetTableNum)
          .Posting(context);
      print(Provider.of<NetworkModel>((context), listen: false).APIPostData);
    }

    if (navStatus == 3) {
      if (_statusProvider.serviceState == 0) {
        navPage(
                context: context,
                page: const ShippingDoneFinal(),
                enablePop: false)
            .navPageToPage();
      } else if (_statusProvider.serviceState == 1) {
        navPage(
                context: context,
                page: const ServingProgressFinal(),
                enablePop: false)
            .navPageToPage();
      } else if (_statusProvider.serviceState == 2) {
        navPage(
                context: context,
                page: const BellboyProgressFinal(),
                enablePop: false)
            .navPageToPage();
      } else if (_statusProvider.serviceState == 3) {
        navPage(
                context: context,
                page: const RoomServiceProgressFinal(),
                enablePop: false)
            .navPageToPage();
      }
    }
    print('navStatus');
    print(navStatus);

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

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
                        if (_statusProvider.serviceState == 0) {
                          navPage(
                                  context: context,
                                  page: const ShippingDoneFinal(),
                                  enablePop: false)
                              .navPageToPage();
                        } else if (_statusProvider.serviceState == 1) {
                          navPage(
                                  context: context,
                                  page: const ServingProgressFinal(),
                                  enablePop: false)
                              .navPageToPage();
                        } else if (_statusProvider.serviceState == 2) {
                          navPage(
                                  context: context,
                                  page: const BellboyProgressFinal(),
                                  enablePop: false)
                              .navPageToPage();
                        } else if (_statusProvider.serviceState == 3) {
                          navPage(
                                  context: context,
                                  page: const RoomServiceProgressFinal(),
                                  enablePop: false)
                              .navPageToPage();
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
                      // decoration: BoxDecoration(
                      //     border: Border.fromBorderSide(
                      //         BorderSide(color: Colors.white, width: 1))),
                      child: Text(
                        servTableNum == 'charging_pile'
                            ? '충전스테이션'
                            : servTableNum == 'wait'
                                ? '대기장소'
                                : '$servTableNum번 테이블',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                // Positioned(
                //   top: 150,
                //   left: 100,
                //     child: Text(
                //   '$navStatus',
                //   style: TextStyle(fontSize: 30),
                // )),
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
