import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/MenuButtons.dart';
import 'package:provider/provider.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelServiceMenu extends StatefulWidget {
  HotelServiceMenu({Key? key}) : super(key: key);

  @override
  State<HotelServiceMenu> createState() => _HotelServiceMenuState();
}

class _HotelServiceMenuState extends State<HotelServiceMenu> {
  late NetworkModel _networkProvider;

  String backgroundImage = "assets/screens/Hotel/koriZFinalHotelServiceMain.png";

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double textButtonWidth = screenWidth * 0.85;
    double textButtonHeight = screenHeight * 0.15;

    TextStyle? buttonFont2 = Theme.of(context).textTheme.displaySmall;

    return WillPopScope(
      onWillPop: (){
        navPage(context: context, page: ServiceScreenFinal(), enablePop: false).navPageToPage();
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
                      left: 30,
                      top: 25,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Backward.png',
                                ),
                                fit: BoxFit.fill)),
                      )),
                  Positioned(
                    left: 20,
                    top: 18,
                    child: FilledButton(onPressed: () {
                      navPage(context: context, page: ServiceScreenFinal(), enablePop: false).navPageToPage();
                    }, child: null, style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)
                        ),
                        backgroundColor: Colors.transparent
                    ),),
                  ),
                  Positioned(
                    left: 130,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Home.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 18,
                    child: FilledButton(onPressed: () {
                      navPage(context: context, page: MainScreenFinal(), enablePop: false).navPageToPage();
                    }, child: null, style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)
                        ),
                        backgroundColor: Colors.transparent
                    ),),
                  ),
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
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Stack(
            children: [
              HotelModuleButtonsFinal(screens: 0,)
            ],
          ),
        ),
      ),
    );
  }
}
