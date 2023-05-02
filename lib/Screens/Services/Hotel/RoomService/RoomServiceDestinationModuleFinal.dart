import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class RoomServiceDestinationScreenFinal extends StatefulWidget {
  const RoomServiceDestinationScreenFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomServiceDestinationScreenFinal> createState() => _RoomServiceDestinationScreenFinalState();
}

class _RoomServiceDestinationScreenFinalState extends State<RoomServiceDestinationScreenFinal> {
  late NetworkModel _networkProvider;
  String? currentGoal;

  bool? goalChecker;

  late dynamic responsePostMSG;

  late var goalPosition = List<String>.empty();

  String shippingKeyPadIMG = "assets/screens/Hotel/RoomService/koriZFinalRoomSelect.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
    goalChecker = false;
  }

  void showGoalFalsePopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('목적지를 잘못 입력하였습니다.'),
                ],
              ),
            ),
            backgroundColor: const Color(0xff2C2C2C),
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color(0xFFB7B7B7),
                  style: BorderStyle.solid,
                  width: 1,
                )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        shape: const LinearBorder(
                            side: BorderSide(color: Colors.white, width: 2),
                            top: LinearBorderEdge(size: 0.9)),
                        minimumSize:
                        Size(screenWidth * 0.5, screenHeight * 0.04)),
                    child: Text(
                      '확인',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ],
              )
            ],
            // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    goalPosition = _networkProvider.goalPosition;

    return Scaffold(
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
                    left: 30,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
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
                      fixedSize: const Size(80, 80),
                      shape: RoundedRectangleBorder(
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
                    decoration: const BoxDecoration(
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
                    navPage(context: context, page: const MainScreenFinal(), enablePop: false).navPageToPage();
                  }, child: null, style: FilledButton.styleFrom(
                      fixedSize: const Size(80, 80),
                      shape: RoundedRectangleBorder(
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
              child: Text('호', style: TextStyle(
                fontFamily: 'kor',
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)
              ),),
            ),
            RoomServiceModuleButtonsFinal(screens: 2,),
          ],
        ),
      ),
    );
  }
}