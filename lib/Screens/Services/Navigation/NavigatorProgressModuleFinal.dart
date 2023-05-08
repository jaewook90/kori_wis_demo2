import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
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

  late String backgroundImageServ;

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    if (_networkProvider.serviceState == 0) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalShipProgNav.png";
    } else if (_networkProvider.serviceState == 1) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";
    } else if (_networkProvider.serviceState == 2) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalBellProgNav.png";
    } else if (_networkProvider.serviceState == 3) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalRoomProgNav.png";
    }

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: (){
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
                                fit: BoxFit.fill)),)
                  )
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
                        if (_networkProvider.serviceState == 0) {
                          navPage(
                              context: context,
                              page: const ShippingDoneFinal(),
                              enablePop: false)
                              .navPageToPage();
                        } else if (_networkProvider.serviceState == 1) {
                          navPage(
                              context: context,
                              page: const ServingProgressFinal(),
                              enablePop: false)
                              .navPageToPage();
                        } else if (_networkProvider.serviceState == 2) {
                          navPage(
                              context: context,
                              page: const BellboyProgressFinal(),
                              enablePop: false)
                              .navPageToPage();
                        }else if (_networkProvider.serviceState == 3) {
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
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.transparent, width: 1))))),
                ),
                const NavModuleButtonsFinal(
                  screens: 0,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}