import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellboyDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// ------------------------------ 보류 ---------------------------------------

class BellBoyServiceMenu extends StatefulWidget {
  BellBoyServiceMenu({Key? key}) : super(key: key);

  @override
  State<BellBoyServiceMenu> createState() => _BellBoyServiceMenuState();
}

class _BellBoyServiceMenuState extends State<BellBoyServiceMenu> {
  late NetworkModel _networkProvider;

  String backgroundImage = "assets/screens/Hotel/BellBoy/koriZFinalBellBoyBegin.png";

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
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
                    Navigator.pop(context);
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
            Positioned(
              top: 420,
              left: 0,
              child: GestureDetector(
                  onTap: () {
                    if (_networkProvider.bellboyTF == true) {
                      showCountDownPopup(context);
                    } else {
                      navPage(
                          context: context,
                          page: BellboyDestinationScreenFinal(),
                          enablePop: true)
                          .navPageToPage();
                    }
                  },
                  child: Container(
                      height: 1200,
                      width: 1080,
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.transparent, width: 1))))),
            ),
            BellboyModuleButtonsFinal(screens: 0,)
          ],
        ),
      ),
    );
  }
}
