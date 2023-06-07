import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';

class ShippingDoneFinal extends StatefulWidget {
  const ShippingDoneFinal({Key? key}) : super(key: key);

  @override
  State<ShippingDoneFinal> createState() => _ShippingDoneFinalState();
}

class _ShippingDoneFinalState extends State<ShippingDoneFinal> {

  String backgroundImage = "assets/screens/Shipping/koriZFinalShippingDone.png";

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
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const MainScreenBLEAutoConnect(),
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
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage), fit: BoxFit.cover)),
              child: Stack(children: [
                Positioned(
                  top: 450,
                  left: 0,
                  child: GestureDetector(
                    // 화면 터치로 화면 이동
                      onTap: () {
                        navPage(
                            context: context,
                            page: const ShippingMenuFinal(),
                            enablePop: false)
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
                  screens: 3,
                )
              ])),
        ));
  }
}