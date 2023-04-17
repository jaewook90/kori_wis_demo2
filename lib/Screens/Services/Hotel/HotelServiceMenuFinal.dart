import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/MenuButtons.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelServiceMenu extends StatefulWidget {
  HotelServiceMenu({Key? key}) : super(key: key);

  @override
  State<HotelServiceMenu> createState() => _HotelServiceMenuState();
}

class _HotelServiceMenuState extends State<HotelServiceMenu> {

  String backgroundImage = "assets/screens/Hotel/koriZFinalHotelMain.png";

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double textButtonWidth = screenWidth * 0.85;
    double textButtonHeight = screenHeight * 0.15;

    TextStyle? buttonFont2 = Theme.of(context).textTheme.displaySmall;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Color(0xffB7B7B7),
          iconSize: screenHeight * 0.03,
          alignment: Alignment.centerRight,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 600, 0),
            child: TextButton(
              onPressed: () {

              },
              child: Text(
                'RoomS',
                style: TextStyle(
                    fontFamily: 'kok',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff)),
              ),
              style: TextButton.styleFrom(
                fixedSize: Size(100, 0),
                backgroundColor: Colors.transparent,
                // shape: RoundedRectangleBorder(
                //     side: BorderSide(width: 1, color: Colors.white)
                // )
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            onPressed: () {
              navPage(context: context, page: ServiceScreenFinal(), enablePop: false)
                  .navPageToPage();
            },
            icon: Icon(
              Icons.home_outlined,
            ),
            color: Color(0xffB7B7B7),
            iconSize: screenHeight * 0.03,
            alignment: Alignment.center,
          ),
          Icon(Icons.battery_charging_full,
              color: Colors.teal, size: screenHeight * 0.03),
          SizedBox(width: screenWidth * 0.03)
        ],
        toolbarHeight: screenHeight * 0.045,
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
    );
  }
}
