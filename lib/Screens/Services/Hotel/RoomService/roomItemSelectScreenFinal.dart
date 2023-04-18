import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectRoomItemScreenFinal extends StatefulWidget {
  const SelectRoomItemScreenFinal({Key? key}) : super(key: key);

  @override
  State<SelectRoomItemScreenFinal> createState() =>
      _SelectRoomItemScreenFinalState();
}

class _SelectRoomItemScreenFinalState extends State<SelectRoomItemScreenFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String? tableNumber;
  String? itemName;

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> menuItems = ['수건', '헤어', '가운', '스킨'];

  String itemSelectBG =
      'assets/screens/Hotel/RoomService/koriZFinalRoomItemSelect.png';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;
    tableNumber = _servingProvider.tableNumber;

    goalPosition = _networkProvider.goalPosition;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // leading:
        actions: [
          Container(
            width: screenWidth,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                    left: 30,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    )),
                Positioned(
                  left: 20,
                  top: 18,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 25,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/icons/appBar/appBar_Home.png',
                            ),
                            fit: BoxFit.fill)),
                  ),
                ),
                Positioned(
                  left: 120,
                  top: 18,
                  child: FilledButton(
                    onPressed: () {
                      navPage(
                              context: context,
                              page: MainScreenFinal(),
                              enablePop: false)
                          .navPageToPage();
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                  ),
                ),
                Positioned(
                  right: 50,
                  top: 25,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/icons/appBar/appBar_Battery.png',
                            ),
                            fit: BoxFit.fill)),
                  ),
                ),
                Center(
                  child: Text(
                    "시간",
                    style: TextStyle(fontFamily: 'kor', fontSize: 60),
                  ),
                )
              ],
            ),
          )
          // SizedBox(width: screenWidth * 0.03)
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          decoration: BoxDecoration(
              // border: Border.fromBorderSide(BorderSide(color: Colors.white))
              ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                    image: DecorationImage(image: AssetImage(itemSelectBG))),
              ),
              Positioned(
                  left: 925.3,
                  top: 159.8,
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
              RoomServiceModuleButtonsFinal(
                screens: 1,
              ),
            ],
          )),
    );
  }
}
