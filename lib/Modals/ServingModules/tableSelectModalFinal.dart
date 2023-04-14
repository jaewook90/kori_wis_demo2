import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/tableSelectFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/trayCheckingModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:provider/provider.dart';

import '../../Providers/ServingModel.dart';

class SelectTableModalFinal extends StatefulWidget {
  const SelectTableModalFinal({Key? key})
      : super(key: key);

  @override
  State<SelectTableModalFinal> createState() => _SelectTableModalFinalState();
}

class _SelectTableModalFinalState extends State<SelectTableModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? tableNumber;
  String? itemName;

  String tableImg = 'assets/screens/Serving/koriZFinalTableSelect.png';

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> testItems = ['햄버거', '라면', '치킨', '핫도그', '미주문'];

  // 배경 화면
  late String backgroundImage;

  // 코리 바디 및 트레이 사진
  late String koriBody;
  late String servingTray1;
  late String servingTray2;
  late String servingTray3;

  // 상품 사진
  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  // 상품 구분 번호
  // late int itemNumber;
  int itemNumber = 0;

  // 상품 목록
  late List<List> itemImagesList; // 트레이 1, 2, 3 다발 리스트
  late List<String> itemImages;
  late int trayNumber;

  // 트레이 하이드 앤 쇼
  bool? offStageTray1;
  bool? offStageTray2;
  bool? offStageTray3;

  // 음식 하이드 앤 쇼
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;

  //트레이별 선택 테이블 넘버
  String? table1;
  String? table2;
  String? table3;

  //트레이별 선택 메뉴
  String? item1;
  String? item2;
  String? item3;

  //restAPI url
  String? startUrl;
  String? navUrl;

  //디버그
  bool _debugTray = false;

  late bool receiptModeOn;

  // void showCheckingPopup(context){
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //     return TrayCheckingModalFinal();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;
    tableNumber = _servingProvider.tableNumber;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    goalPosition = _networkProvider.goalPosition;

    TextStyle? tableButtonFont = Theme.of(context).textTheme.headlineMedium;

    if (orderedItems.length == 0) {
      for (int i = 0; i < _networkProvider.goalPosition.length; i++) {
        orderedItems.add(testItems[Random().nextInt(testItems.length)]);
        print(orderedItems);
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 90),
      child: Dialog(
        backgroundColor: Color.fromRGBO(45, 45, 45, 45),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Color(0xFFB7B7B7),
              style: BorderStyle.solid,
              width: 1,
            )),
        child: TableSelectImgFinal()
      ),
    );
  }
}
