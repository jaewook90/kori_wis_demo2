import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';

class ShippingDestinationNewFinal extends StatefulWidget {
  const ShippingDestinationNewFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ShippingDestinationNewFinal> createState() =>
      _ShippingDestinationNewFinalState();
}

class _ShippingDestinationNewFinalState
    extends State<ShippingDestinationNewFinal> {

  String shippingKeyPadIMG =
      "assets/screens/Shipping/koriZFinalShippingDestinations.png";

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

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
                        Navigator.pop(context);
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
                      icon: Image.asset('assets/icons/appBar/appBar_Home.png'),
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(shippingKeyPadIMG), fit: BoxFit.cover)),
        child: const Stack(
          children: [
            Positioned(
              top: 278,
              left: 700,
              child: Text(
                '호',
                style: TextStyle(
                    fontFamily: 'kor',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff)),
              ),
            ),
            ShippingModuleButtonsFinal(
              screens: 1,
            )
          ],
        ),
      ),
    );
  }
}