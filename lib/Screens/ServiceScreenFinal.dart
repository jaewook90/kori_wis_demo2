import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';
import 'package:provider/provider.dart';

class ServiceScreenFinal extends StatefulWidget {
  const ServiceScreenFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ServiceScreenFinal> createState() => _ServiceScreenFinalState();
}

class _ServiceScreenFinalState extends State<ServiceScreenFinal>
    with TickerProviderStateMixin {

  late NetworkModel _networkProvider;

  String? currentGoal;

  dynamic poseData;

  bool? shippingCheck;
  bool? navCheck;
  bool? pauseCheck;

  String? startUrl;
  String? navUrl;
  String? chgUrl;
  String? stpUrl;
  String? rsmUrl;

  List<String>? goalPosition;

  final String _shipping = "assets/images/Service_menu_img/koriZFinalShipBanner.png";
  final String _serving = "assets/images/Service_menu_img/koriZFinalServBanner.png";
  final String _hotel = "assets/images/Service_menu_img/koriZFinalHotelBanner.png";

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    poseData = _networkProvider.getPoseData;

    return WillPopScope(
      onWillPop: () async {
        navPage(context: context, page: const MainScreenFinal(), enablePop: false)
            .navPageToPage();
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
                            page: MainScreenFinal(),
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
          margin: const EdgeInsets.only(top: 110),
          height: 1810,
          decoration: const BoxDecoration(
            color: Colors.transparent,),
          child: Stack(
            children: [
              //택배
              Positioned(
                top: 15,
                child: Container(
                  height: 580,
                  width: 1080,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(_shipping)),
                    color: Colors.transparent,),
                ),
              ),
              //서빙
              Positioned(
                top: 610,
                width: 1080,
                child: Container(
                  height: 580,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(_serving)),
                    color: Colors.transparent,),
                ),
              ),
              //호텔
              Positioned(
                top: 1205,
                width: 1080,
                child: Container(
                  height: 580,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(_hotel)),
                    color: Colors.transparent,),
                ),
              ),
              const MainScreenButtonsFinal(screens: 1),
            ],
          ),
        ),
      ),
    );
  }
}
