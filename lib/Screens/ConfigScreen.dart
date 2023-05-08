import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(
                0, screenHeight * 0.0015, screenWidth * 0.05, 0),
            onPressed: () {
              navPage(context: context, page: const MainScreenFinal(), enablePop: false).navPageToPage();
            },
            icon: const Icon(
              Icons.home_outlined,
            ),
            color: const Color(0xffB7B7B7),
            iconSize: screenHeight * 0.05,
          )
        ],
        toolbarHeight: screenHeight * 0.08,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/KoriBackgroundImage_v1.png"),
        //         fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
