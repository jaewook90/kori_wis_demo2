import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';

class BellboyDestinationScreenFinal extends StatefulWidget {
  const BellboyDestinationScreenFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<BellboyDestinationScreenFinal> createState() =>
      _BellboyDestinationScreenFinalState();
}

class _BellboyDestinationScreenFinalState
    extends State<BellboyDestinationScreenFinal> {
  String shippingKeyPadIMG =
      "assets/screens/Hotel/BellBoy/koriZFinalBellBoyRoomSelect.png";

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
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
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
            BellboyModuleButtonsFinal(
              screens: 1,
            )
          ],
        ),
      ),
    );
  }
}
