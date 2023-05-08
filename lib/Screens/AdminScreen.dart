import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            // padding: EdgeInsets.only(right: screenWidth * 0.07),
            padding: EdgeInsets.fromLTRB(0, screenHeight*0.0015, screenWidth*0.05, 0),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return MainScreenFinal();}));
            },
            icon: Icon(
              Icons.home_outlined,
            ),
            color: Color(0xffB7B7B7),
            iconSize: screenHeight * 0.05,
          )
        ],
        toolbarHeight: screenHeight * 0.08,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints.expand(),
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
                Text('관리자 페이지', style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
