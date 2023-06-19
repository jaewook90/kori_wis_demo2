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

  void getStarted_readData() async {
    // [START get_started_read_data]
    await testDb.collection("microBit").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        if(doc.data()['id'] == '121'){
          print(doc.data()['id']);
          Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId = doc.data()['id'];
        }
      }
    });
    // [END get_started_read_data]
  }

  void getDataOnce_getADocument() {
    // [START get_data_once_get_a_document]
    final docRef = testDb.collection("cities").doc("SF");
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // [END get_data_once_get_a_document]
  }
  // CollectionReference product =
  //     FirebaseFirestore.instance.collection('microBit');

  // final TextEditingController idController = TextEditingController();
  // final TextEditingController deviceIdController = TextEditingController();

  // Future<void> _update(DocumentSnapshot documentSnapshot) async {
  //   idController.text = documentSnapshot['id'];
  //   deviceIdController.text = documentSnapshot['trayDetector'];
  //
  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SizedBox(
  //           child: Padding(
  //             padding: EdgeInsets.fromLTRB(
  //                 20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextField(
  //                   controller: idController,
  //                   decoration: InputDecoration(labelText: 'id'),
  //                 ),
  //                 TextField(
  //                   controller: deviceIdController,
  //                   decoration: InputDecoration(labelText: 'trayDetector'),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 ElevatedButton(onPressed: () async {
  //                   final String id = idController.text;
  //                   final String deviceId = deviceIdController.text;
  //                   product.doc(documentSnapshot.id).update({"id": id, "trayDetector": deviceId});
  //                   idController.text = '';
  //                   deviceIdController.text = '';
  //                   Navigator.of(context).pop(context);
  //                 }, child: Text('update'))
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    print('a');
    getStarted_readData();
    print(Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId);
    print('b');
    return Scaffold(
      body: Container(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder(
  //     stream: product.snapshots(),
  //     builder:
  //         (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
  //       if (streamSnapShot.hasData) {
  //         return ListView.builder(
  //             itemCount: streamSnapShot.data!.docs.length,
  //             itemBuilder: (context, index) {
  //               final DocumentSnapshot documentSnapshot =
  //                   streamSnapShot.data!.docs[index];
  //               return Card(
  //                 color: Colors.red,
  //                 margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
  //                 child: ListTile(
  //                   title: Text(documentSnapshot['id']),
  //                   subtitle: Text(documentSnapshot['trayDetector']),
  //                   trailing: SizedBox(
  //                     width: 100,
  //                     child: Row(
  //                       children: [
  //                         IconButton(onPressed: () {
  //                           _update(documentSnapshot);
  //                         }, icon: Icon(Icons.edit))
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //       }
  //       return CircularProgressIndicator();
  //     },
  //   );
  // }
}
