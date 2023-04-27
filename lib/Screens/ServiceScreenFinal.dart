import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';

class ServiceScreenFinal extends StatefulWidget {
  const ServiceScreenFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ServiceScreenFinal> createState() => _ServiceScreenFinalState();
}

class _ServiceScreenFinalState extends State<ServiceScreenFinal>
    with TickerProviderStateMixin {

  String? currentGoal;

  final String _shipping = "assets/images/Service_menu_img/koriZFinalShipBanner.png";
  final String _serving = "assets/images/Service_menu_img/koriZFinalServBanner.png";
  final String _hotel = "assets/images/Service_menu_img/koriZFinalHotelBanner.png";

  late var shippingPose = List<String>.empty();

  late final AnimationController _textAniCon = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _textAniCon,
    curve: Curves.easeOut,
  );


  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // poseData = _networkProvider.getPoseData;

    return WillPopScope(
      onWillPop: () async {
        navPage(context: context, page: MainScreenFinal(), enablePop: false)
            .navPageToPage();
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
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: MainScreenFinal(),
                                enablePop: false)
                            .navPageToPage();
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          fixedSize: Size(80, 80),
                          shape: RoundedRectangleBorder(
                              // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                    ),
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
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: MainScreenFinal(),
                                enablePop: false)
                            .navPageToPage();
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          fixedSize: Size(80, 80),
                          shape: RoundedRectangleBorder(
                              // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                    ),
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
          margin: EdgeInsets.only(top: 110),
          height: 1810,
          decoration: BoxDecoration(
              color: Colors.transparent,),
          child: Stack(
            children: [
              Positioned(
                top: 15,
                child: Container(
                  height: 580,
                  width: 1080,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(_shipping)),
                      color: Colors.transparent,),
                  // child: ServiceScreenVideoFinal(videoName: _shipping)
                ),
              ),
              Positioned(
                top: 610,
                width: 1080,
                child: Container(
                  height: 580,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(_serving)),
                      color: Colors.transparent,),
                  // child:ServiceScreenVideoFinal(videoName: _serving)
                ),
              ),
              Positioned(
                top: 1205,
                width: 1080,
                child: Container(
                    height: 580,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(_hotel)),
                        color: Colors.transparent,),
                  // child:ServiceScreenVideoFinal(videoName: _hotel)
                ),
              ),
              MainScreenButtonsFinal(screens: 1),
            ],
          ),
        ),
      ),
    );
  }
}
