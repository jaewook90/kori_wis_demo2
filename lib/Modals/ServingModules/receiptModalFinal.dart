import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

import '../../Providers/ServingModel.dart';

class SelectReceiptModalFinal extends StatefulWidget {
  const SelectReceiptModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectReceiptModalFinal> createState() => _SelectReceiptModalFinalState();
}

class _SelectReceiptModalFinalState extends State<SelectReceiptModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? tableNumber;
  String? itemName;

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> testItems = ['햄버거', '라면', '치킨', '핫도그', '미주문'];

  // 배경 화면
  String receiptSelectBG = 'assets/screens/Serving/koriZFinalReceiptSelect.png';

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
  //
  // void showCheckingPopup(context) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return TrayCheckingModal();
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;
    tableNumber = _servingProvider.tableNumber;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.4;
    double textButtonHeight = screenHeight * 0.15;

    goalPosition = _networkProvider.goalPosition;

    TextStyle? tableButtonFont = Theme.of(context).textTheme.headlineLarge;

    // if (orderedItems.length == 0) {
    //   for (int i = 0; i < _networkProvider.goalPosition.length; i++) {
    //     orderedItems.add(testItems[Random().nextInt(testItems.length)]);
    //     print(orderedItems);
    //   }
    // }

    return Container(
      child: Dialog(
        backgroundColor: Color(0xff000000),
        child: Stack(children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              border: Border.fromBorderSide((BorderSide(
                color: Colors.white,
                width: 1
              ))),
                image: DecorationImage(
                    image: AssetImage(receiptSelectBG), fit: BoxFit.cover)),
          ),
          Positioned(
              left: 1176 * 0.75,
              top: 307 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                // color: Colors.white,
                // decoration: BoxDecoration(
                //   border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))
                // ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
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
          Positioned(
              left: 290 * 0.75,
              top: 170 * 0.75,
              child: Container(
                width: 600,
                height: 80,
                // color: Colors.white,
                // decoration: BoxDecoration(
                //   border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))
                // ),
                child: Text('주문서를 선택 해 주세요', style: TextStyle(fontFamily: 'kor', color: Color(0xffffffff), fontSize: 60, fontWeight: FontWeight.bold),)
              )),
          Positioned(
            child: ServingModuleButtonsFinal(screens: 3,),)
        ]),
      ),
    );
  }
}