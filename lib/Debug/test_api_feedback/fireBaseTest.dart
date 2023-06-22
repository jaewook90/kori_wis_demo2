import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Models/MicroBitModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:provider/provider.dart';

class FireBaseTestScreen extends StatefulWidget {
  const FireBaseTestScreen({Key? key}) : super(key: key);

  @override
  State<FireBaseTestScreen> createState() => _FireBaseTestScreenState();
}

class _FireBaseTestScreenState extends State<FireBaseTestScreen> {
  FirebaseFirestore testDb = FirebaseFirestore.instance;

  late String deviceId;

  final TextEditingController tdController = TextEditingController();

  void getStarted_readData() async {
    // [START get_started_read_data]
    await testDb.collection("microBit").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        if (doc.data()['id'] == '2') {
          print(doc.data()['id']);
          Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId =
              doc.data()['trayDetector'];
        }
      }
    });
    // [END get_started_read_data]
  }

  // void getDataOnce_getADocument() {
  //   // [START get_data_once_get_a_document]
  //   final docRef = testDb.collection("cities").doc("SF");
  //   docRef.get().then(
  //     (DocumentSnapshot doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       // ...
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  //   // [END get_data_once_get_a_document]
  // }

  @override
  Widget build(BuildContext context) {
    getStarted_readData();
    deviceId =
        Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId!;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 120),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 540,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        SizedBox(
                            width: 500,
                            child: Text(
                              'trayDetectorId: $deviceId',
                              style: TextStyle(
                                  fontFamily: 'kor', fontSize: 20, color: Colors.white),
                            )),
                        SizedBox(
                          width: 500,
                          child: TextField(
                            controller: tdController,
                            decoration: InputDecoration(
                                labelText: 'trayDetector',
                                labelStyle: TextStyle(
                                    fontFamily: 'kor',
                                    fontSize: 20,
                                    color: Colors.white),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 540,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: TextButton(
                        onPressed: () {
                          final String trayDetector = tdController.text;
                          final data = {"trayDetector": trayDetector};
                          testDb
                              .collection("microBit")
                              .doc("servingBot2")
                              .set(data, SetOptions(merge: true));
                          Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId = tdController.text;
                          setState(() {
                          });
                        },
                        child: Text(
                          '적용',
                          style: TextStyle(
                              fontFamily: 'kor', fontSize: 20, color: Colors.white),
                        ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
