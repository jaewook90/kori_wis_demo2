import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class ShippingDoneFinal extends StatefulWidget {
  const ShippingDoneFinal({Key? key}) : super(key: key);

  @override
  State<ShippingDoneFinal> createState() => _ShippingDoneFinalState();
}

class _ShippingDoneFinalState extends State<ShippingDoneFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  String backgroundImage = "assets/screens/Shipping/koriZFinalShippingDone.png";

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    chgUrl = _networkProvider.chgUrl;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  Center(
                    child: Text(
                      "시간",
                      style: TextStyle(fontFamily: 'kor', fontSize: 60),
                    ),
                  )
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
                  ShippingModuleButtonsFinal(screens: 3,)
                ])));
  }
}





















// 복귀 버튼
//Positioned(
//                 left: screenWidth * 0.325,
//                 top: screenHeight * 0.55,
//                 child: ServingButtons(
//                   onPressed: () {
//                     PostApi(
//                             url: startUrl,
//                             endadr: chgUrl,
//                             keyBody: 'charging_pile')
//                         .Posting();
//                     _networkProvider.currentGoal = '충전스테이션';
//                     navPage(
//                             context: context,
//                             page: NavigatorModule(),
//                             enablePop: true)
//                         .navPageToPage();
//                     // navPage(context: context, page: ServingMenu(), enablePop: true).navPageToPage();
//                     _networkProvider.shippingDone = true;
//                   },
//                   buttonWidth: buttonWidth,
//                   buttonHeight: buttonHeight,
//                   buttonText: '확인',
//                   buttonFont: buttonFont,
//                   buttonColor: Color.fromRGBO(45, 45, 45, 45),
//                   screenWidth: screenWidth,
//                   screenHeight: screenHeight,
//                 ),
//               )

