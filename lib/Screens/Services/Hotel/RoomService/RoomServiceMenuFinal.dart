import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/roomItemSelectModalFinal.dart';
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

  // 배경 화면
  late String backgroundImage;
  late String resetIcon;

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

  //디버그
  late bool _debugTray;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    backgroundImage =
    "assets/screens/Hotel/RoomService/koriZFinalRoomBegin.png";

    table1 = "";
    table2 = "";
    table3 = "";
  }

  void showTraySetPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectRoomItemModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _roomServiceProvider =
        Provider.of<RoomServiceModel>(context, listen: false);

    _debugTray = _roomServiceProvider.trayDebug!;

    offStageTray1 = _roomServiceProvider.attachedTray1;
    offStageTray2 = _roomServiceProvider.attachedTray2;
    offStageTray3 = _roomServiceProvider.attachedTray3;

    servedItem1 = _roomServiceProvider.servedItem1;
    servedItem2 = _roomServiceProvider.servedItem2;
    servedItem3 = _roomServiceProvider.servedItem3;

    table1 = _roomServiceProvider.table1;
    table2 = _roomServiceProvider.table2;
    table3 = _roomServiceProvider.table3;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    return WillPopScope(
      onWillPop: () {
        navPage(
            context: context,
            page: const HotelServiceMenu(),
            enablePop: false)
            .navPageToPage();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(90, 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Backward.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const MainScreenFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(90, 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Home.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
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
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: WillPopScope(
          onWillPop: () {
            navPage(
                context: context,
                page: const HotelServiceMenu(),
                enablePop: false)
                .navPageToPage();
            return Future.value(false);
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                //기능적 부분
                Stack(children: [
                  const RoomServiceModuleButtonsFinal(
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
                                      _roomServiceProvider.stickTray1();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray1', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _roomServiceProvider.stickTray2();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray2', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _roomServiceProvider.stickTray3();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray3', style: buttonFont)),
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
                        onPressed: () {
                          setState(() {
                            _roomServiceProvider.clearTray1();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 180,
                      top: 1090,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _roomServiceProvider.clearTray2();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 180,
                      top: 1296,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _roomServiceProvider.clearTray3();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
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
                                      children: [
                                        Text(
                                          '$table1 호',
                                          style: buttonFont,
                                        ),
                                      ])),
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
                                          _roomServiceProvider.itemImageList![0]),
                                    ),
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
                                  navPage(
                                      context: context,
                                      page: const SelectRoomItemScreenFinal(),
                                      enablePop: true)
                                      .navPageToPage();
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 1),
                                        borderRadius: BorderRadius.circular(20))),
                                child: Container()),
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
                                      children: [
                                        Text(
                                          '$table2 호',
                                          style: buttonFont,
                                        ),
                                      ])),
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
                                        image: AssetImage(_roomServiceProvider
                                            .itemImageList![1])),
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
                                    navPage(
                                        context: context,
                                        page:
                                        const SelectRoomItemScreenFinal(),
                                        enablePop: true)
                                        .navPageToPage();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize:
                                      Size(textButtonWidth, textButtonHeight),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.green, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                  child: Container())),
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
                                      children: [
                                        Text(
                                          '$table3 호',
                                          style: buttonFont,
                                        ),
                                      ])),
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
                                        image: AssetImage(_roomServiceProvider
                                            .itemImageList![2])),
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
                                    navPage(
                                        context: context,
                                        page:
                                        const SelectRoomItemScreenFinal(),
                                        enablePop: true)
                                        .navPageToPage();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize:
                                      Size(textButtonWidth, textButtonHeight),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.green, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                  child: Container())),
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
      ),
    );
  }
}
