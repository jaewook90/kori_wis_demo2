import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';

// ------------------------------ 보류 ---------------------------------------

class ShippingMenuFinal extends StatefulWidget {
  const ShippingMenuFinal({Key? key}) : super(key: key);

  @override
  State<ShippingMenuFinal> createState() => _ShippingMenuFinalState();
}

class _ShippingMenuFinalState extends State<ShippingMenuFinal> {
  String backgroundImage = "assets/screens/Shipping/koriZFinalShipping.png";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  left: 22,
                  top: 17,
                  child: IconButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const ServiceScreenFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      icon: Image.asset(
                          'assets/icons/appBar/appBar_Backward.png'),
                      iconSize: 60),
                ),
                Positioned(
                  left: 122,
                  top: 17,
                  child: IconButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const MainScreenFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      icon: Image.asset(
                          'assets/icons/appBar/appBar_Home.png'),
                      iconSize: 60),
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
      body: WillPopScope(
        onWillPop: () {
          navPage(
              context: context,
              page: const ServiceScreenFinal(),
              enablePop: false)
              .navPageToPage();
          return Future.value(false);
        },
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Stack(
            children: [
              Positioned(
                top: 420,
                left: 0,
                child: GestureDetector(
                    onTap: () {
                      navPage(
                          context: context,
                          page: const ShippingDestinationNewFinal(),
                          enablePop: true)
                          .navPageToPage();
                    },
                    child: Container(
                        height: 1200,
                        width: 1080,
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                color: Colors.transparent, width: 1))))),
              ),
              const ShippingModuleButtonsFinal(
                screens: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
