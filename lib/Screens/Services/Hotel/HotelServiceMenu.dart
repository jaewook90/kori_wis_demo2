import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/MenuButtons.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelServiceMenu extends StatefulWidget {
  HotelServiceMenu({Key? key}) : super(key: key);

  @override
  State<HotelServiceMenu> createState() => _HotelServiceMenuState();
}

class _HotelServiceMenuState extends State<HotelServiceMenu> {
  // late NetworkModel _networkProvider;

  String backgroundImage = "assets/images/KoriBackgroundImage_v1.png";

  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double textButtonWidth = screenWidth * 0.85;
    double textButtonHeight = screenHeight * 0.15;

    // TextStyle? buttonFont = Theme.of(context).textTheme.displayLarge;
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
        padding: EdgeInsets.only(top: screenHeight * 0.05),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.1),
                  width: screenWidth,
                  height: screenHeight * 0.35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuButtons(
                        assetsBool: false,
                        onPressed: () {},
                        appIcon: Icons.luggage_outlined,
                        buttonIconSize: 120,
                        buttonText: '벨보이',
                        buttonColor: Color.fromRGBO(45, 45, 45, 45),
                        buttonFont: buttonFont2,
                        buttonWidth: textButtonWidth*0.5,
                        buttonHeight: textButtonHeight*0.8,
                      ),
                      MenuButtons(
                        assetsBool: false,
                        onPressed: () {},
                        appIcon: Icons.room_service_outlined,
                        buttonIconSize: 120,
                        buttonText: '룸서비스',
                        buttonColor: Color.fromRGBO(45, 45, 45, 45),
                        buttonFont: buttonFont2,
                        buttonWidth: textButtonWidth*0.5,
                        buttonHeight: textButtonHeight*0.8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
