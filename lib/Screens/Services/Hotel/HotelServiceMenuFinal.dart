import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelServiceMenu extends StatefulWidget {
  const HotelServiceMenu({Key? key}) : super(key: key);

  @override
  State<HotelServiceMenu> createState() => _HotelServiceMenuState();
}

class _HotelServiceMenuState extends State<HotelServiceMenu> {

  String backgroundImage = "assets/screens/Hotel/koriZFinalHotelServiceMain.png";

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: (){
        navPage(context: context, page: const ServiceScreenFinal(), enablePop: false).navPageToPage();
        return Future.value(false);
      },
      child: Scaffold(
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
                    left: 20,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const ServiceScreenFinal(),
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
                                  'assets/icons/appBar/appBar_Backward.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const MainScreenFinal(),
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
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage),)),
          child: const Stack(
            children: [
              HotelModuleButtonsFinal(screens: 0,)
            ],
          ),
        ),
      ),
    );
  }
}
