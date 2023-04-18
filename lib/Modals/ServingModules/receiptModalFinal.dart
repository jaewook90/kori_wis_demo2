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

    goalPosition = _networkProvider.goalPosition;

    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.white)),),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1514,
          width: 993,
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(receiptSelectBG))),
            ),
            Positioned(
                left: 886,
                top: 38,
                child: Container(
                  width: 48,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(width: 1, color: Colors.white),
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

            ServingModuleButtonsFinal(screens: 3,)
          ]),
        ),
      ),
    );
  }
}