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

class _ServiceScreenFinalState extends State<ServiceScreenFinal> with TickerProviderStateMixin {
  // late NetworkModel _networkProvider;

  String? currentGoal;

  // dynamic poseData;

  final String _wallpape = "assets/screens/koriZFinalService.png";
  final String _fingerIcon = "assets/icons/pushIcon.png";

  double pixelRatio = 0.75;

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
  void dispose() {
    // TODO: implement dispose
    _textAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // poseData = _networkProvider.getPoseData;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
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
        body: Stack(
          children: [
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(_wallpape))),
              child: Container(),
            ),
            MainScreenButtonsFinal(screens: 1),
            Positioned(
                left: 670 * pixelRatio,
                top: 1829 * pixelRatio,
                child: FadeTransition(
                  opacity: _animation,
                  child: SizedBox(
                    child: ImageIcon(
                      AssetImage(_fingerIcon),
                      color: Color(0xffB7B7B7),
                      size: 100,
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 1970 * pixelRatio),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '서비스를 선택해주세요.',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        color: Color(0xfff0f0f0)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}