import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

import '../../Providers/ServingModel.dart';

class SelectItemModalFinal extends StatefulWidget {
  const SelectItemModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectItemModalFinal> createState() => _SelectItemModalFinalState();
}

class _SelectItemModalFinalState extends State<SelectItemModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? tableNumber;
  String? itemName;

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> menuItems = ['햄버거', '라면', '치킨', '핫도그'];

  String itemSelectBG = 'assets/screens/Serving/koriZFinalItemSelect.png';

  String downArrowIcon1 = 'assets/icons/decoration/DownArrow1.png';
  String downArrowIcon2 = 'assets/icons/decoration/DownArrow2.png';
  String downArrowIcon3 = 'assets/icons/decoration/DownArrow3.png';

  late List<String> menuImgItems;

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

  late bool receiptModeOn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;
    tableNumber = _servingProvider.tableNumber;

    goalPosition = _networkProvider.goalPosition;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 90, 0, 180),
      height: 1536,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Dialog(
        // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                height: 1536,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                    // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                    image: DecorationImage(
                        image: AssetImage(itemSelectBG))),
              ),
              Positioned(
                  left: 880,
                  top: 23,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.transparent,
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
              ServingModuleButtonsFinal(
                screens: 1,
              ),
            ],
          )),
    );
  }
}