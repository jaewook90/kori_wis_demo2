import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/receiptModalFinal.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// 트레이 반응형 UI

class TraySelectionFinal extends StatefulWidget {
  const TraySelectionFinal({Key? key}) : super(key: key);

  @override
  State<TraySelectionFinal> createState() => _TraySelectionFinalState();
}

class _TraySelectionFinalState extends State<TraySelectionFinal> {
  late ServingModel _servingProvider;

  String? tableNumber;
  String? itemName;

  late var goalPosition = List<String>.empty();
  List<String> orderedItems = [];

  List<String> testItems = ['햄버거', '라면', '치킨', '핫도그', '미주문'];

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

    backgroundImage = "assets/screens/Serving/koriZFinalServing.png";
    resetIcon = "assets/icons/trayReset.png";
    downArrowIcon1 = 'assets/icons/decoration/DownArrow1.png';
    downArrowIcon2 = 'assets/icons/decoration/DownArrow2.png';
    downArrowIcon3 = 'assets/icons/decoration/DownArrow3.png';
  }

  void showReceiptSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          if (receiptModeOn == true) {
            return SelectReceiptModalFinal();
          } else {
            return SelectItemModalFinal();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;
    tableNumber = _servingProvider.tableNumber;

    offStageTray1 = _servingProvider.attachedTray1;
    offStageTray2 = _servingProvider.attachedTray2;
    offStageTray3 = _servingProvider.attachedTray3;

    servedItem1 = _servingProvider.servedItem1;
    servedItem2 = _servingProvider.servedItem2;
    servedItem3 = _servingProvider.servedItem3;

    receiptModeOn = _servingProvider.receiptModeOn!;

    table1 = _servingProvider.table1;
    table2 = _servingProvider.table2;
    table3 = _servingProvider.table3;

    item1 = _servingProvider.item1;
    item2 = _servingProvider.item2;
    item3 = _servingProvider.item3;

    // startUrl = _networkProvider.startUrl;
    // navUrl = _networkProvider.navUrl;

    print(_servingProvider.itemImageList);

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

    print('item :: ${itemName}');
    print(itemNumber);
    print(tableNumber);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            navPage(
                    context: context,
                    page: ServiceScreenFinal(),
                    enablePop: false)
                .navPageToPage();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Color(0xffB7B7B7),
          iconSize: screenHeight * 0.03,
          alignment: Alignment.centerRight,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            onPressed: () {
              _servingProvider.clearAllTray();
              // _servingProvider.initServing();
              navPage(
                      context: context,
                      page: ServiceScreenFinal(),
                      enablePop: false)
                  .navPageToPage();
            },
            icon: Icon(
              Icons.home_outlined,
            ),
            color: Color(0xffB7B7B7),
            iconSize: screenHeight * 0.03,
            alignment: Alignment.center,
          ),
          Icon(Icons.battery_charging_full,
              color: Colors.teal, size: screenHeight * 0.03),
          SizedBox(width: screenWidth * 0.03)
        ],
        toolbarHeight: screenHeight * 0.045,
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
              ServingModuleButtonsFinal(
                screens: 0,
              ),
              // 디버그 버튼
              Column(
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
                                  _servingProvider.receiptModeOn = false;
                                } else {
                                  _servingProvider.receiptModeOn = true;
                                }
                              });
                            },
                            child: _servingProvider.receiptModeOn == true
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
                                _servingProvider.stickTray1();
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
                                _servingProvider.stickTray2();
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
                                _servingProvider.stickTray3();
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
              // 초기화 버튼
              Positioned(
                  left: 1148 * 0.75,
                  top: 1010 * 0.75,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _servingProvider.clearTray1();
                      });
                    },
                    icon: Image.asset(resetIcon),
                    iconSize: 77 * 0.75,
                  )),
              Positioned(
                  left: 1148 * 0.75,
                  top: 1261 * 0.75,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _servingProvider.clearTray2();
                      });
                    },
                    icon: Image.asset(resetIcon),
                    iconSize: 77 * 0.75,
                  )),
              Positioned(
                  left: 1148 * 0.75,
                  top: 1544 * 0.75,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _servingProvider.clearTray3();
                      });
                    },
                    icon: Image.asset(resetIcon),
                    iconSize: 77 * 0.75,
                  )),
              //트레이1
              Positioned(
                top: 944*0.75,
                left: 570*0.75,
                child: Offstage(
                  offstage: offStageTray1!,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 52*0.75,
                        top: 140*0.75,
                        child: Container(
                          width: 65 * 0.75,
                          height: 50 * 0.75,
                          child: Offstage(
                              offstage: servedItem1!,
                              child: Text(
                                '$table1 번',
                                style: buttonFont,
                              )),
                        ),
                      ),
                      Positioned(
                        left: 140*0.75,
                        top: 35*0.75,
                        child: Offstage(
                          offstage: servedItem1!,
                          child: Container(
                              width: 320 * 0.75,
                              height: 160 * 0.75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        _servingProvider.itemImageList![0]),
                                    fit: BoxFit.fill),
                              )),
                        ),
                      ),
                      Container(
                        width: 518 * 0.75,
                        height: 229 * 0.75,
                        child: TextButton(
                            onPressed: () {
                              print("tapped");
                              _servingProvider.tray1Select = true;
                              _servingProvider.trayCheckAll = false;
                              showReceiptSelectPopup(context);
                            },
                            child: Container(),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(20)))),
                      ),
                    ],
                  ),
                ),
              ),
              //트레이2
              Positioned(
                top: 1195*0.75,
                left: 570*0.75,
                child: Offstage(
                  offstage: offStageTray2!,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 55*0.75,
                        top: 140*0.75,
                        child: Container(
                          width: 65 * 0.75,
                          height: 50 * 0.75,
                          child: Offstage(
                              offstage: servedItem2!,
                              child: Text(
                                '$table2 번',
                                style: buttonFont,
                              )),
                        ),
                      ),
                      Positioned(
                        left: 140*0.75,
                        top: 35*0.75,
                        child: Offstage(
                          offstage: servedItem2!,
                          child: Container(
                              width: 320 * 0.75,
                              height: 160 * 0.75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        _servingProvider.itemImageList![1]),
                                    fit: BoxFit.fill),
                              )),
                        ),
                      ),
                      Container(
                        width: 518 * 0.75,
                        height: 229 * 0.75,
                        child: TextButton(
                            onPressed: () {
                              print("tapped");
                              _servingProvider.tray2Select = true;
                              _servingProvider.trayCheckAll = false;
                              showReceiptSelectPopup(context);
                            },
                            child: Container(),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.green, width: 1),
                                    borderRadius: BorderRadius.circular(20))))
                      ),
                    ],
                  ),
                ),
              ),
              //트레이3
              Positioned(
                top: 1446*0.75,
                left: 570*0.75,
                child: Offstage(
                  offstage: offStageTray3!,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 52*0.75,
                        top: 172*0.75,
                        child: Container(
                          width: 65 * 0.75,
                          height: 50 * 0.75,
                          child: Offstage(
                              offstage: servedItem3!,
                              child: Text(
                                '$table3 번',
                                style: buttonFont,
                              )),
                        ),
                      ),
                      Positioned(
                        left: 140*0.75,
                        top: 105*0.75,
                        child: Offstage(
                          offstage: servedItem3!,
                          child: Container(
                              width: 320 * 0.75,
                              height: 160 * 0.75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        _servingProvider.itemImageList![2]),
                                    fit: BoxFit.fill),
                              )),
                        ),
                      ),
                      Container(
                        width: 518 * 0.75,
                        height: 293 * 0.75,
                        child: TextButton(
                            onPressed: () {
                              print("tapped");
                              _servingProvider.tray3Select = true;
                              _servingProvider.trayCheckAll = false;
                              showReceiptSelectPopup(context);
                            },
                            child: Container(),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.green, width: 1),
                                    borderRadius: BorderRadius.circular(20))))
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  left: 470*0.75,
                  top: 470*0.75,
                  child:Text('선반을 고른 후 상품을 선택해주세요.'),
              ),
              Positioned(
                left: 657*0.75,
                  top: 590*0.75,
                  child: Container(
                    width: 120*0.75,
                    height: 50*0.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(downArrowIcon1), fit: BoxFit.cover)
                    ),
                  )),
              Positioned(
                  left: 657*0.75,
                  top: 560*0.75,
                  child: Container(
                    width: 120*0.75,
                    height: 50*0.75,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(downArrowIcon2), fit: BoxFit.cover)
                    ),
                  )),
              Positioned(
                  left: 657*0.75,
                  top: 530*0.75,
                  child: Container(
                    width: 120*0.75,
                    height: 50*0.75,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(downArrowIcon3), fit: BoxFit.cover)
                    ),
                  ))
            ]),
          ],
        ),
        // ),
      ),
    );
  }
}
