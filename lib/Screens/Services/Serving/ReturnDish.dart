// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDoneFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class ReturnProgressModuleFinal extends StatefulWidget {
  const ReturnProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<ReturnProgressModuleFinal> createState() =>
      _ReturnProgressModuleFinalState();
}

class _ReturnProgressModuleFinalState extends State<ReturnProgressModuleFinal> {
  late NetworkModel _networkProvider;

  // late ServingModel _servingProvider;

  FirebaseFirestore robotDb = FirebaseFirestore.instance;

  late String backgroundImageServ;

  late String targetTableNum;

  late bool arrivedReturnTable;

  late String currentTargetTable;

  // late String servTableNum;

  String? startUrl;
  String? navUrl;

  late int navStatus;
  late bool initNavStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arrivedReturnTable = false;
    navStatus = 0;
    initNavStatus = true;

    currentTargetTable =
        Provider.of<ServingModel>(context, listen: false).returnTargetTable!;

    if (Provider.of<ServingModel>(context, listen: false).servingState == 1) {
      const int newState = 0;
      final data = {"serviceState": newState};
      const String returnTable = 'hall';
      final data2 = {"returnTable": returnTable};
      robotDb
          .collection("servingBot1")
          .doc("robotState")
          .set(data, SetOptions(merge: true));
      robotDb
          .collection("servingBot1")
          .doc("robotState")
          .set(data2, SetOptions(merge: true));
    }
  }

  // void getStarted_readData() async {
  //   // [START get_started_read_data]
  //   await robotDb.collection("servingBot1").get().then((event) {
  //     for (var doc in event.docs) {
  //       if(doc.id == "robotState"){
  //         print(doc.data()['serviceState']);
  //         print(doc.data()['returnTable']);
  //         setState(() {
  //           Provider.of<ServingModel>(context, listen: false).servingState = doc.data()['serviceState'];
  //         });
  //         if(doc.data()['serviceState']==3){
  //           const int newState = 0;
  //           const String returnTable = 'hall';
  //           final data1 = {"serviceState": newState};
  //           final data2 = {"returnTable": returnTable};
  //           robotDb
  //               .collection("servingBot1")
  //               .doc("robotState")
  //               .set(data1, SetOptions(merge: true));
  //           robotDb
  //               .collection("servingBot1")
  //               .doc("robotState")
  //               .set(data2, SetOptions(merge: true));
  //           Navigator.pop(context);
  //         }
  //       }
  //     }
  //   });
  //   // [END get_started_read_data]
  // }

  Future<dynamic> Getting() async {
    NetworkGet network =
        NetworkGet("http://192.168.0.155/reeman/movebase_status");

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      if (getApiData == 3) {
        while (getApiData != 3) {
          if (mounted) {
            Provider.of<NetworkModel>((context), listen: false).APIGetData =
                getApiData;
            setState(() {
              navStatus = Provider.of<NetworkModel>((context), listen: false)
                  .APIGetData['status'];
              initNavStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          Provider.of<NetworkModel>((context), listen: false).APIGetData =
              getApiData;
          setState(() {
            navStatus = Provider.of<NetworkModel>((context), listen: false)
                .APIGetData['status'];
            initNavStatus = false;
          });
        }
      }
    } else {
      if (mounted) {
        Provider.of<NetworkModel>((context), listen: false).APIGetData =
            getApiData;
        setState(() {
          navStatus = Provider.of<NetworkModel>((context), listen: false)
              .APIGetData['status'];
          initNavStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    backgroundImageServ = "assets/screens/Nav/koriZFinalReturnProgNav.png";

    // WidgetsBinding.instance.addPostFrameCallback((_){getStarted_readData();});

    // double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = 1080;
    // double screenHeight = 1920;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), (){
        Getting();
      });
      if (navStatus == 3 && arrivedReturnTable == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('nav Return Done');
          setState(() {
            navStatus = 0;
            arrivedReturnTable = true;
          });
          navPage(
                  context: context,
                  page: const ReturnDoneScreen(),
                  enablePop: false)
              .navPageToPage();
        });
        // navPage(
        //         context: context,
        //         page: const ReturnDoneScreen(),
        //         enablePop: false)
        //     .navPageToPage();
      }
    });
    // Getting();

    // if (navStatus == 3 && arrivedReturnTable == false) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     print('nav Return Done');
    //     setState(() {
    //       arrivedReturnTable = true;
    //     });
    //     navPage(
    //             context: context,
    //             page: const ReturnDoneScreen(),
    //             enablePop: false)
    //         .navPageToPage();
    //   });
    //   // navPage(
    //   //         context: context,
    //   //         page: const ReturnDoneScreen(),
    //   //         enablePop: false)
    //   //     .navPageToPage();
    // }

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
                      ))
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
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                    top: 400,
                    left: 350,
                    child: Container(
                      width: 380,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 70,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '$currentTargetTable번 테이블',
                            style: TextStyle(fontSize: 48, color: Colors.white),
                          )
                        ],
                      ),
                    )),
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
                NavModuleButtonsFinal(
                  screens: 2,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
