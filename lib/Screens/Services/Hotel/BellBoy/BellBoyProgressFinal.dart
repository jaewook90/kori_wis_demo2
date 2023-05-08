import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/HotelModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyReturn.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';
import 'package:provider/provider.dart';


class BellboyProgressFinal extends StatefulWidget {
  const BellboyProgressFinal({Key? key}) : super(key: key);

  @override
  State<BellboyProgressFinal> createState() => _BellboyProgressFinalState();
}

class _BellboyProgressFinalState extends State<BellboyProgressFinal> {
  late HotelModel _hotelProvider;

  String backgroundImage = "assets/screens/Hotel/BellBoy/koriZFinalBellBoyDone.png";



  @override
  Widget build(BuildContext context) {
    _hotelProvider = Provider.of<HotelModel>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: (){
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
                      image: AssetImage(backgroundImage), fit: BoxFit.cover)),
              child: Stack(children: [
                Positioned(
                  top: 420,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _hotelProvider.bellboyTF = false;
                        });
                        navPage(
                            context: context,
                            page: const BellboyReturnModuleFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      child: Container(
                          height: 1200,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.transparent, width: 1))))),
                ),
                Container(
                  child: const BellboyModuleButtonsFinal(screens: 3),
                ),
              ]))),
    );
  }
}