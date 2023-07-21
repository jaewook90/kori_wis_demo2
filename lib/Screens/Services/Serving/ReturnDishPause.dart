import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDoneFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class ReturnDishPauseScreen extends StatefulWidget {
  final String? servGoalPose;

  const ReturnDishPauseScreen({
    this.servGoalPose,
    Key? key,
  }) : super(key: key);

  @override
  State<ReturnDishPauseScreen> createState() => _ReturnDishPauseScreenState();
}

class _ReturnDishPauseScreenState extends State<ReturnDishPauseScreen> {
  late String backgroundImage;

  late String targetTable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    targetTable =
        Provider.of<ServingModel>(context, listen: false).returnTargetTable!;
  }

  @override
  Widget build(BuildContext context) {
    backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";

    double screenWidth = 1080;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
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
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                  top: 500,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        navPage(
                                context: context,
                                page: const ReturnDoneScreen(),
                                enablePop: false)
                            .navPageToPage();
                      },
                      child: Container(
                          height: 800,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.transparent, width: 1))))),
                ),
                Positioned(
                    top: 372,
                    left: 460,
                    child: Container(
                      width: 300,
                      height: 90,
                      child: Text(
                        '$targetTable번 테이블',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                const NavModuleButtonsFinal(screens: 1),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
