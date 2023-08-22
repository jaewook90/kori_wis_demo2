import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/saveDataTest.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class TestPagesScreen extends StatefulWidget {
  const TestPagesScreen({Key? key}) : super(key: key);

  @override
  State<TestPagesScreen> createState() => _TestPagesScreenState();
}

class _TestPagesScreenState extends State<TestPagesScreen> {
  late ServingModel _servingProvider;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _servingProvider.mainInit = true;
                      });
                      navPage(
                              context: context,
                              page: const TraySelectionSec(),)
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
        iconTheme: const IconThemeData(size: 70, color: Color(0xfffefeff)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: 1080,
        height: 1920,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      navPage(context: context, page: const DataSavingTest(), ).navPageToPage();
                    },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(30),
                  side: const BorderSide(
                    color: Colors.white, width: 3
                  )
                ),
                    child: const Text(
                      '데이터 저장 테스트',
                      style: TextStyle(
                          fontFamily: 'kor', fontSize: 40, color: Colors.white),
                    ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
