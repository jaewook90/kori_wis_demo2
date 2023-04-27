import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/roomItemSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/receiptModalFinal.dart';
import 'package:kori_wis_demo/Providers/RoomServiceModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/roomItemSelectScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// 트레이 반응형 UI

class RoomServiceMenu extends StatefulWidget {
  const RoomServiceMenu({Key? key}) : super(key: key);

  @override
  State<RoomServiceMenu> createState() => _RoomServiceMenuState();
}

class _RoomServiceMenuState extends State<RoomServiceMenu> {
  late RoomServiceModel _roomServiceProvider;

  String? tableNumber;
  String? itemName;

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> testItems = ['수건', '헤어', '가운', '스킨', '미주문'];

  // 배경 화면
  late String backgroundImage;
  late String resetIcon;

  late String downArrowIcon1;
  late String downArrowIcon2;
  late String downArrowIcon3;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    backgroundImage = "assets/screens/Hotel/RoomService/koriZFinalRoomBegin.png";

    table1 = "";
    table2 = "";
    table3 = "";
  }

  void showTraySetPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          if (receiptModeOn == true) {
            return SelectReceiptModalFinal();
          } else {
            return SelectRoomItemModalFinal();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _roomServiceProvider = Provider.of<RoomServiceModel>(context, listen: false);

    itemName = _roomServiceProvider.menuItem;
    tableNumber = _roomServiceProvider.tableNumber;

    offStageTray1 = _roomServiceProvider.attachedTray1;
    offStageTray2 = _roomServiceProvider.attachedTray2;
    offStageTray3 = _roomServiceProvider.attachedTray3;

    servedItem1 = _roomServiceProvider.servedItem1;
    servedItem2 = _roomServiceProvider.servedItem2;
    servedItem3 = _roomServiceProvider.servedItem3;

    receiptModeOn = _roomServiceProvider.receiptModeOn!;

    table1 = _roomServiceProvider.table1;
    table2 = _roomServiceProvider.table2;
    table3 = _roomServiceProvider.table3;

    item1 = _roomServiceProvider.item1;
    item2 = _roomServiceProvider.item2;
    item3 = _roomServiceProvider.item3;

    if (itemName == '수건') {
      itemNumber = 0;
    } else if (itemName == '헤어') {
      itemNumber = 1;
    } else if (itemName == '가운') {
      itemNumber = 2;
    } else if (itemName == '스킨') {
      itemNumber = 3;
    } else {
      itemNumber.isNaN;
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    return WillPopScope(
      onWillPop: () {
        navPage(context: context, page: HotelServiceMenu(), enablePop: false).navPageToPage();
        return Future.value(false);
      },
      child: Scaffold(
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
                    child: FilledButton(onPressed: () {
                      navPage(context: context, page: HotelServiceMenu(), enablePop: false).navPageToPage();
                    }, child: null, style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)
                        ),
                        backgroundColor: Colors.transparent
                    ),),
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
                    child: FilledButton(onPressed: () {
                      navPage(context: context, page: MainScreenFinal(), enablePop: false).navPageToPage();
                    }, child: null, style: FilledButton.styleFrom(
                        fixedSize: Size(80, 80),
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)
                        ),
                        backgroundColor: Colors.transparent
                    ),),
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
                ],
              ),
            )
            // SizedBox(width: screenWidth * 0.03)
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Stack(
            children: [
              //기능적 부분
              Stack(children: [
                RoomServiceModuleButtonsFinal(
                  screens: 0,
                ),
                // 디버그 버튼
                Opacity(
                  opacity: 0.02,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 디버그 버튼 트레이 활성화용
                      Offstage(
                        offstage: _debugTray,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (receiptModeOn == true) {
                                      _roomServiceProvider.receiptModeOn = false;
                                    } else {
                                      _roomServiceProvider.receiptModeOn = true;
                                    }
                                  });
                                },
                                child: _roomServiceProvider.receiptModeOn == true
                                    ? Text(
                                  'Receipt Mode',
                                  style: buttonFont,
                                )
                                    : Text('Normal Mode', style: buttonFont),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: Size(textButtonWidth * 0.25,
                                        textButtonHeight * 0.5),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFB7B7B7),
                                            style: BorderStyle.solid,
                                            width: 10)))),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _roomServiceProvider.stickTray1();
                                  });
                                },
                                child: Text('Tray1', style: buttonFont),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: Size(textButtonWidth * 0.2,
                                        textButtonHeight * 0.5),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFB7B7B7),
                                            style: BorderStyle.solid,
                                            width: 10)))),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _roomServiceProvider.stickTray2();
                                  });
                                },
                                child: Text('Tray2', style: buttonFont),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: Size(textButtonWidth * 0.2,
                                        textButtonHeight * 0.5),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFB7B7B7),
                                            style: BorderStyle.solid,
                                            width: 10)))),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _roomServiceProvider.stickTray3();
                                  });
                                },
                                child: Text('Tray3', style: buttonFont),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize: Size(textButtonWidth * 0.2,
                                        textButtonHeight * 0.5),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFB7B7B7),
                                            style: BorderStyle.solid,
                                            width: 10)))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 초기화 버튼
                Positioned(
                    right: 180,
                    top: 885,
                    child: FilledButton(
                      onPressed: (){
                        setState(() {
                          _roomServiceProvider.clearTray1();
                        });
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          fixedSize: Size(64, 64),
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)
                          ),
                          backgroundColor: Colors.transparent
                      ),
                    )),
                Positioned(
                    right: 180,
                    top: 1090,
                    child: FilledButton(
                      onPressed: (){
                        setState(() {
                          _roomServiceProvider.clearTray2();
                        });
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          fixedSize: Size(64, 64),
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)
                          ),
                          backgroundColor: Colors.transparent
                      ),
                    )),
                Positioned(
                    right: 180,
                    top: 1296,
                    child: FilledButton(
                      onPressed: (){
                        setState(() {
                          _roomServiceProvider.clearTray3();
                        });
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                          fixedSize: Size(64, 64),
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)
                          ),
                          backgroundColor: Colors.transparent
                      ),
                    )),
                //트레이1
                Positioned(
                  top: 827,
                  left: 409,
                  child: Offstage(
                    offstage: offStageTray1!,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 24,
                          top: 120,
                          child: Container(
                            width: 70,
                            height: 30,
                            child: Offstage(
                                offstage: servedItem1!,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(
                                    // '$table1 번',
                                    '${table1} 호',
                                    style: buttonFont,
                                  ),]
                                )),
                          ),
                        ),
                        Positioned(
                          left: 145.5,
                          top: 32,
                          child: Offstage(
                            offstage: servedItem1!,
                            child: Container(
                                width: 146,
                                height: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        _roomServiceProvider.itemImageList![0]),),
                                )),
                          ),
                        ),
                        Container(
                          width: 388.5,
                          height: 180,
                          child: TextButton(
                              onPressed: () {
                                _roomServiceProvider.tray1Select = true;
                                _roomServiceProvider.tray2Select = false;
                                _roomServiceProvider.tray3Select = false;
                                _roomServiceProvider.trayCheckAll = false;
                                navPage(context: context, page: SelectRoomItemScreenFinal(), enablePop: true).navPageToPage();
                              },
                              child: Container(),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  fixedSize:
                                  Size(textButtonWidth, textButtonHeight),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.green, width: 1),
                                      borderRadius: BorderRadius.circular(20)))),
                        ),
                      ],
                    ),
                  ),
                ),
                //트레이2
                Positioned(
                  top: 1030.8,
                  left: 409,
                  child: Offstage(
                    offstage: offStageTray2!,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 24,
                          top: 120,
                          child: Container(
                            width: 70,
                            height: 30,
                            child: Offstage(
                                offstage: servedItem2!,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text(
                                      // '$table1 번',
                                      '${table2} 호',
                                      style: buttonFont,
                                    ),]
                                )),
                          ),
                        ),
                        Positioned(
                          left: 145.5,
                          top: 32,
                          child: Offstage(
                            offstage: servedItem2!,
                            child: Container(
                                width: 146,
                                height: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          _roomServiceProvider.itemImageList![1])),
                                )),
                          ),
                        ),
                        Container(
                            width: 388.5,
                            height: 180,
                            child: TextButton(
                                onPressed: () {
                                  _roomServiceProvider.tray1Select = false;
                                  _roomServiceProvider.tray2Select = true;
                                  _roomServiceProvider.tray3Select = false;
                                  _roomServiceProvider.trayCheckAll = false;
                                  navPage(context: context, page: SelectRoomItemScreenFinal(), enablePop: true).navPageToPage();
                                },
                                child: Container(),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.green, width: 1),
                                        borderRadius:
                                        BorderRadius.circular(20))))),
                      ],
                    ),
                  ),
                ),
                //트레이3
                Positioned(
                  top: 1237.6,
                  left: 409,
                  child: Offstage(
                    offstage: offStageTray3!,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 24,
                          top: 120,
                          child: Container(
                            width: 70,
                            height: 30,
                            child: Offstage(
                                offstage: servedItem3!,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text(
                                      // '$table1 번',
                                      '${table3} 호',
                                      style: buttonFont,
                                    ),]
                                )),
                          ),
                        ),
                        Positioned(
                          left: 145.5,
                          top: 35,
                          child: Offstage(
                            offstage: servedItem3!,
                            child: Container(
                                width: 146,
                                height: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          _roomServiceProvider.itemImageList![2])),
                                )),
                          ),
                        ),
                        Container(
                            width: 388.5,
                            height: 180,
                            child: TextButton(
                                onPressed: () {
                                  _roomServiceProvider.tray1Select = false;
                                  _roomServiceProvider.tray2Select = false;
                                  _roomServiceProvider.tray3Select = true;
                                  _roomServiceProvider.trayCheckAll = false;
                                  navPage(context: context, page: SelectRoomItemScreenFinal(), enablePop: true).navPageToPage();
                                },
                                child: Container(),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.green, width: 1),
                                        borderRadius:
                                        BorderRadius.circular(20))))),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
