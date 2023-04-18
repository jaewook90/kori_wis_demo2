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
      _servingProvider.setTray2();
      setState(() {
        _servingProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _servingProvider.servedItem2 = false;
      });
    } else if (_servingProvider.tray3Select == true) {
      _servingProvider.setTray3();
      setState(() {
        _servingProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _servingProvider.servedItem3 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

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
        height: 1536,
        decoration: BoxDecoration(
          // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
          image: DecorationImage(
              image: AssetImage(tableSelectBG), fit: BoxFit.cover),
        ),
      ),
      Positioned(
          left: 836,
          top: 18,
          child: Container(
            width: 48,
            height: 48,
            color: Colors.transparent,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      // side: BorderSide(width: 1, color: Colors.white)
                  )),
              onPressed: () {
                Navigator.pop(context);
                _servingProvider.item1 = "";
                _servingProvider.item2 = "";
                _servingProvider.item3 = "";
                setState(() {
                  if(_servingProvider.trayCheckAll==true){
                    _servingProvider.tray1=false;
                    _servingProvider.tray2=false;
                    _servingProvider.tray3=false;
                  }
                });
              },
              child: null,
            ),
          )),
      ServingModuleButtonsFinal(screens: 2,),
    ]);
  }
}