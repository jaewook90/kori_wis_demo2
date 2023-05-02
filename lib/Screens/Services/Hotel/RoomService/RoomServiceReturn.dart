import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class RoomServiceReturnModuleFinal extends StatefulWidget {
  const RoomServiceReturnModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomServiceReturnModuleFinal> createState() =>
      _RoomServiceReturnModuleFinalState();
}

class _RoomServiceReturnModuleFinalState
    extends State<RoomServiceReturnModuleFinal> {
  late NetworkModel _networkProvider;

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

  late String backgroundImageServ;

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    backgroundImageServ = "assets/screens/Nav/koriZFinalRoomReturnNav.png";

    currentGoal = _networkProvider.currentGoal;
    serviceState = _networkProvider.serviceState;


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
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Container(
              child: Stack(
                children: [
                  Positioned(
                    top: 400,
                    left: 0,
                    child: GestureDetector(
                        onTap: () {
                          navPage(
                              context: context,
                              page: const HotelServiceMenu(),
                              enablePop: false)
                              .navPageToPage();
                        },
                        child: Container(
                            height: 1000,
                            width: 1080,
                            decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                    BorderSide(color: Colors.transparent, width: 1))))),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}