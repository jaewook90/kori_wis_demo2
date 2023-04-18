import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NavigatorPauseModuleFinal extends StatefulWidget {
  NavigatorPauseModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorPauseModuleFinal> createState() =>
      _NavigatorPauseModuleFinalState();
}

class _NavigatorPauseModuleFinalState extends State<NavigatorPauseModuleFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  int? shipping;
  int? serving;
  int? bellboy;
  int? roomService;

  String? currentGoal;

  bool? pauseCheck;

  int? serviceState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pauseCheck = false;

    shipping = 0;
    serving = 1;
    bellboy = 2;
    roomService = 3;
  }

  late String backgroundImage;

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    if (_networkProvider.serviceState == 0) {
      backgroundImage = "assets/screens/Nav/koriZFinalShipPauseNav.png";
    } else if (_networkProvider.serviceState == 1) {
      backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";
    } else if (_networkProvider.serviceState == 2) {
      backgroundImage = "assets/screens/Nav/koriZFinalBellPauseNav.png";
    } else if (_networkProvider.serviceState == 3) {
      backgroundImage = "assets/screens/Nav/koriZFinalRoomPauseNav.png";
    }

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;
    currentGoal = _networkProvider.currentGoal;

    serviceState = _networkProvider.serviceState;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          // leading:
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
                      decoration: BoxDecoration(
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
            // SizedBox(width: screenWidth * 0.03)
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Container(
              child: Stack(
                children: [
                  Positioned(
                    top: 500,
                    left: 0,
                    child: GestureDetector(
                        onTap: () {
                          print('tapped');
                          if (_networkProvider.serviceState == 0) {
                            navPage(
                                    context: context,
                                    page: ShippingDoneFinal(),
                                    enablePop: false)
                                .navPageToPage();
                            // showShippingDone(context);
                          } else if (_networkProvider.serviceState == 1) {
                            navPage(
                                    context: context,
                                    page: ServingProgressFinal(),
                                    enablePop: false)
                                .navPageToPage();
                          } else if (_networkProvider.serviceState == 2) {
                            navPage(
                                    context: context,
                                    page: BellboyProgressFinal(),
                                    enablePop: false)
                                .navPageToPage();
                          } else if (_networkProvider.serviceState == 3) {
                            navPage(
                                    context: context,
                                    page: RoomServiceProgressFinal(),
                                    enablePop: false)
                                .navPageToPage();
                          }
                        },
                        child: Container(
                            height: 800,
                            width: 1080,
                            decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    color: Colors.transparent, width: 1))))),
                  ),
                  NavModuleButtonsFinal(screens: 1),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
