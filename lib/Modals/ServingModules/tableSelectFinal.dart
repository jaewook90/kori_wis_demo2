import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

import 'tableSelectModalFinal.dart';

class TableSelectImgFinal extends StatefulWidget {
  const TableSelectImgFinal({Key? key}) : super(key: key);

  @override
  State<TableSelectImgFinal> createState() => _TableSelectImgFinalState();
}

class _TableSelectImgFinalState extends State<TableSelectImgFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String tableSelectBG = 'assets/screens/Serving/koriZFinalTableSelect.png';

  String? tableNumber;

  String? table1;
  String? table2;
  String? table3;

  String? tableAll;

  String? itemName;

  String? item1;
  String? item2;
  String? item3;

  int itemNumber = 0;

  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  String? startUrl;
  String? navUrl;

  late List<List> itemImagesList;
  late List<String> itemImages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hamburger = "assets/images/serving_item_imgs/hamburger.png";
    hotDog = "assets/images/serving_item_imgs/hotDog.png";
    chicken = "assets/images/serving_item_imgs/chicken.png";
    ramyeon = "assets/images/serving_item_imgs/ramyeon.png";

    itemImages = [hamburger, hotDog, chicken, ramyeon];
    itemImagesList = [itemImages, itemImages, itemImages];
  }

  void uploadTableNumberNItemImg() {
    if (_servingProvider.tray1Select == true) {
      _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _servingProvider.servedItem1 = false;
      });
    } else if (_servingProvider.tray2Select == true) {
      _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _servingProvider.servedItem2 = false;
      });
    } else if (_servingProvider.tray3Select == true) {
      _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _servingProvider.servedItem3 = false;
      });
    }
  }

  void showTableSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SelectTableModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextStyle? tableButtonFont = Theme.of(context).textTheme.headlineMedium;

    tableNumber = _servingProvider.tableNumber;
    itemName = _servingProvider.menuItem;

    if (_servingProvider.trayCheckAll == false) {
      if (itemName == '햄버거') {
        itemNumber = 0;
      } else if (itemName == '핫도그') {
        itemNumber = 1;
      } else if (itemName == '치킨') {
        itemNumber = 2;
      } else if (itemName == '라면') {
        itemNumber = 3;
      } else {
        itemNumber.isNaN;
      }
    }

    return Stack(children: [
      Container(
        height: 1920*0.8,
        decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.white)),
          image: DecorationImage(
              image: AssetImage(tableSelectBG), fit: BoxFit.cover),
        ),
      ),
      Positioned(
          left: 1140 * 0.75,
          top: 195 * 0.75,
          child: Container(
            width: 48,
            height: 48,
            color: Colors.transparent,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(width: 1, color: Colors.white)
                  )),
              onPressed: () {
                Navigator.pop(context);
                _servingProvider.item1 = "";
                _servingProvider.item2 = "";
                _servingProvider.item3 = "";

                print(_servingProvider.item1);
                print(_servingProvider.item2);
                print(_servingProvider.item3);
              },
              child: null,
            ),
          )),
      ServingModuleButtonsFinal(screens: 2,),
    ]);
  }
}





//      Column(
//         children: [
//           Container(
//             margin: EdgeInsets.fromLTRB(190, 145, 0, 0),
//             height: 102,
//             width: 218,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 print(_servingProvider.trayCheckAll);
//                 setState(() {
//                   _servingProvider.tableNumber = "1";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "1";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "1";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "1";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "1";
//                   }
//                 });
//                 print(_servingProvider.tableNumber);
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '1번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(190, 197, 0, 0),
//             height: 102,
//             width: 218,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "2";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "2";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "2";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "2";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "2";
//                   }
//                 });
//                 print(_servingProvider.tableNumber);
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '2번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(190, 205, 0, 0),
//             height: 102,
//             width: 218,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "3";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "3";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "3";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "3";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "3";
//                   }
//                 });
//                 print(_servingProvider.tableNumber);
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '3번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(190, 225, 0, 0),
//             height: 102,
//             width: 218,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "4";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "4";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "4";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "4";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                   }
//                 });
//                 print(_servingProvider.tableNumber);
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '4번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           )
//         ],
//       ),
//       Column(
//         children: [
//           Container(
//             margin: EdgeInsets.fromLTRB(632, 84, 0, 0),
//             height: 330,
//             width: 137,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "5";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "5";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "5";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "5";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "5";
//                   }
//                 });
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '5번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(632, 133, 0, 0),
//             height: 330,
//             width: 137,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "6";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "6";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "6";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "6";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "6";
//                   }
//                 });
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '6번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(632, 120, 0, 0),
//             height: 330,
//             width: 137,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(0),
//                 border: Border.fromBorderSide(BorderSide(
//                     color: Color(0xFF11ffFF),
//                     style: BorderStyle.solid,
//                     width: 5))),
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   _servingProvider.tableNumber = "7";
//                   if (_servingProvider.trayCheckAll == false) {
//                     if (_servingProvider.tray1Select == true) {
//                       _servingProvider.table1 = "7";
//                     } else if (_servingProvider.tray2Select == true) {
//                       _servingProvider.table2 = "7";
//                     } else if (_servingProvider.tray3Select == true) {
//                       _servingProvider.table3 = "7";
//                     }
//                   } else {
//                     _servingProvider.setTrayAll();
//                     _servingProvider.tableNumber = "7";
//                   }
//                 });
//                 uploadTableNumberNItemImg();
//                 showCheckingStartServing(context);
//               },
//               child: Text(
//                 '7번 테이블',
//                 style: tableButtonFont,
//               ),
//             ),
//           ),
//         ],
//       ),