import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class NavigatorPauseModuleFinal extends StatefulWidget {
  const NavigatorPauseModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorPauseModuleFinal> createState() =>
      _NavigatorPauseModuleFinalState();
}

class _NavigatorPauseModuleFinalState extends State<NavigatorPauseModuleFinal> {
  late MainStatusModel _statusProvider;

  late String backgroundImage;

  late int navStatus;

  Future<dynamic> Getting() async {
    NetworkGet network =
    NetworkGet("http://172.30.1.22/reeman/movebase_status");

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>((context), listen: false).APIGetData = getApiData;

    setState(() {
      navStatus = Provider.of<NetworkModel>((context), listen: false).APIGetData['status'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if (_statusProvider.serviceState == 0) {
      backgroundImage = "assets/screens/Nav/koriZFinalShipPauseNav.png";
    } else if (_statusProvider.serviceState == 1) {
      backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";
    } else if (_statusProvider.serviceState == 2) {
      backgroundImage = "assets/screens/Nav/koriZFinalBellPauseNav.png";
    } else if (_statusProvider.serviceState == 3) {
      backgroundImage = "assets/screens/Nav/koriZFinalRoomPauseNav.png";
    }

    if(navStatus==3){
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
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
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
                const NavModuleButtonsFinal(screens: 1),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
