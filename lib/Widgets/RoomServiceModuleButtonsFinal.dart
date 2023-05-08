import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/RoomServiceDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/HotelModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceReturn.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class RoomServiceModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const RoomServiceModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<RoomServiceModuleButtonsFinal> createState() =>
      _RoomServiceModuleButtonsFinalState();
}

class _RoomServiceModuleButtonsFinalState
    extends State<RoomServiceModuleButtonsFinal> {
  late HotelModel _hotelProvider;

  // 메뉴 및 호실 선택 요소
  List<String> menuItems = ['수건', '헤어', '가운', '스킨'];

  String? itemName;

  int itemNumber = 0;

  late String towel;
  late String shampoo;
  late String shower;
  late String skin;

  late List<List> itemImagesList;
  late List<String> itemImages;

  ////////////////////////////////////////////////////////////////////////////////

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late int buttonNumbers = 0;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String? currentNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentNum = "";

    shampoo = "assets/images/room_item_imgs/shampoo.png";
    shower = "assets/images/room_item_imgs/shower.png";
    skin = "assets/images/room_item_imgs/skin.png";
    towel = "assets/images/room_item_imgs/towel.png";

    itemImages = [towel, shampoo, shower, skin];
    itemImagesList = [itemImages, itemImages, itemImages];
  }

  void showDestinationListPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const RoomServiceDestinationListModalFinal();
        });
  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const NavCountDownModalFinal();
        });
  }

  void showNoDestinationWarn(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          // double screenWidth = MediaQuery.of(context).size.width;
          // double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: const SizedBox(
              width: 650,
              height: 192,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '목적지가 입력되지 않았습니다.',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 45,
                        color: Color(0xffF0F0F0)),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xff2C2C2C),
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color(0xFFB7B7B7),
                  style: BorderStyle.solid,
                  width: 1,
                )),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                      shape: const LinearBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          top: LinearBorderEdge(size: 0.8)),
                      minimumSize: const Size(680, 81)),
                  child: const Text(
                    '확 인',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 30,
                        color: Color(0xffF0F0F0)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void uploadRoomNumberNItemImg() {
    if (_hotelProvider.tray1Select == true) {
      setState(() {
        _hotelProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _hotelProvider.servedItem1 = false;
      });
    } else if (_hotelProvider.tray2Select == true) {
      setState(() {
        _hotelProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _hotelProvider.servedItem2 = false;
      });
    } else if (_hotelProvider.tray3Select == true) {
      setState(() {
        _hotelProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _hotelProvider.servedItem3 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _hotelProvider =
        Provider.of<HotelModel>(context, listen: false);

    itemName = _hotelProvider.menuItem;

    if (_hotelProvider.trayCheckAll == false) {
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
    }

    if (widget.screens == 0) {
      // 룸서비스 메인 화면
      buttonPositionWidth = [84];
      buttonPositionHeight = [155];

      buttonSize = [915, 160];

      buttonRadius = 30;
    } else if (widget.screens == 1) {
      // 룸서비스 상품 선택
      buttonPositionWidth = [104.3, 559.6, 104.3, 559.6];
      buttonPositionHeight = [459, 459, 910.5, 910.5];

      buttonSize = [420, 420];

      buttonRadius = 40;
    } else if (widget.screens == 2) {
      // 룸서비스 키패드 화면
      buttonPositionWidth = [
        115,
        409,
        703,
        115,
        409,
        703,
        115,
        409,
        703,
        115,
        409,
        703
      ];
      buttonPositionHeight = [
        521,
        521,
        521,
        813,
        813,
        813,
        1104,
        1104,
        1104,
        1394,
        1394,
        1394
      ];

      buttonSize = [261, 258];

      buttonRadius = 50;
    } else if (widget.screens == 3) {
      // 룸 서비스 목적지 리스트
      buttonPositionWidth = [79, 525, 79, 525, 79, 525, 79];
      buttonPositionHeight = [1287, 303, 303, 550, 550, 797, 797];

      buttonSize = [];

      buttonSize1 = [847, 157];
      buttonSize2 = [400, 214];

      buttonRadius = 50;
    } else if (widget.screens == 4) {
      // 도착 화면
      buttonPositionWidth = [107];
      buttonPositionHeight = [1376];

      buttonSize = [866, 160];

      buttonRadius = 50;
    }

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      (currentNum == null && widget.screens == 2)
          ? Container()
          : widget.screens == 2
              ? Positioned(
                  top: 220,
                  left: 400,
                  width: 270,
                  height: 180,
                  child: Text(
                    '$currentNum',
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 150,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff)),
                  ),
                )
              : Container(),
      widget.screens == 2
          ? Positioned(
              left: 909,
              top: 338,
              child: Container(
                width: 60,
                height: 60,
                color: Colors.transparent,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        // side: BorderSide(width: 1, color: Colors.white)
                      )),
                  onPressed: () {
                    setState(() {
                      currentNum = "";
                    });
                  },
                  child: null,
                ),
              ))
          : Container(),
      for (int i = 0; i < buttonNumbers; i++)
        Positioned(
          left: buttonPositionWidth[i],
          top: buttonPositionHeight[i],
          child: FilledButton(
            style: FilledButton.styleFrom(
                foregroundColor: widget.screens == 2
                    ? i != 9
                        ? i != 11
                            ? Colors.tealAccent
                            : null
                        : null
                    : null,
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius)),
                fixedSize:
                    // Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
                    widget.screens == 3
                        ? i == 0
                            ? Size(buttonSize1[buttonWidth],
                                buttonSize1[buttonHeight])
                            : Size(buttonSize2[buttonWidth],
                                buttonSize2[buttonHeight])
                        : Size(
                            buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
                    if ((_hotelProvider.room1 != "" ||
                        _hotelProvider.room2 != "") ||
                        _hotelProvider.room3 != "") {
                      showCountDownPopup(context);
                    } else {
                      _hotelProvider.trayCheckAll = true;
                      navPage(
                              context: context,
                              page: const RoomServiceDestinationScreenFinal(),
                              enablePop: true)
                          .navPageToPage();
                      _hotelProvider.menuItem = "상품";
                    }
                  }
                : widget.screens == 1
                    ? () {
                        setState(() {
                            _hotelProvider.menuItem = menuItems[i];
                        });
                        navPage(
                                context: context,
                                page: const RoomServiceDestinationScreenFinal(),
                                enablePop: true)
                            .navPageToPage();
                      }
                    : widget.screens == 2
                        ? () {
                            setState(() {
                              if (currentNum!.length < 3) {
                                if (i < 9) {
                                  currentNum = '$currentNum${i + 1}';
                                }
                              }
                            });
                            if (i == 9) {
                              showDestinationListPopup(context);
                            } else if (i == 10) {
                              currentNum = '${currentNum}0';
                            } else if (i == 11) {
                              setState(() {
                                if (currentNum == "") {
                                  showNoDestinationWarn(context);
                                } else {
                                  _hotelProvider.roomNumber =
                                      '$currentNum';
                                  if (_hotelProvider.trayCheckAll ==
                                      false) {
                                    if (_hotelProvider.tray1Select ==
                                        true) {
                                      _hotelProvider.room1 =
                                          "$currentNum";
                                    } else if (_hotelProvider
                                            .tray2Select ==
                                        true) {
                                      _hotelProvider.room2 =
                                          "$currentNum";
                                    } else {
                                      _hotelProvider.room3 =
                                          "$currentNum";
                                    }
                                    uploadRoomNumberNItemImg();
                                    navPage(
                                            context: context,
                                            page: const RoomServiceMenu(),
                                            enablePop: false)
                                        .navPageToPage();
                                  } else {
                                    _hotelProvider.setTrayAll();
                                    _hotelProvider.roomNumber =
                                        "$currentNum";
                                    showCountDownPopup(context);
                                  }
                                }
                              });
                            }
                          }
                        : widget.screens == 3
                            ? () {
                                setState(() {
                                  if (i == 1) {
                                    currentNum = '102';
                                  } else if (i == 2) {
                                    currentNum = '101';
                                  } else if (i == 3) {
                                    currentNum = '202';
                                  } else if (i == 4) {
                                    currentNum = '201';
                                  } else if (i == 5) {
                                    currentNum = '302';
                                  } else if (i == 6) {
                                    currentNum = '301';
                                  }
                                  _hotelProvider.roomNumber =
                                      '$currentNum';
                                  if (_hotelProvider.trayCheckAll ==
                                      false) {
                                    if (_hotelProvider.tray1Select ==
                                        true) {
                                      _hotelProvider.room1 =
                                          "$currentNum";
                                    } else if (_hotelProvider
                                            .tray2Select ==
                                        true) {
                                      _hotelProvider.room2 =
                                          "$currentNum";
                                    } else {
                                      _hotelProvider.room3 =
                                          "$currentNum";
                                    }
                                    uploadRoomNumberNItemImg();
                                    navPage(
                                            context: context,
                                            page: const RoomServiceMenu(),
                                            enablePop: false)
                                        .navPageToPage();
                                  } else {
                                    _hotelProvider.setTrayAll();
                                    _hotelProvider.roomNumber =
                                        "$currentNum";
                                    showCountDownPopup(context);
                                  }
                                });
                              }
                            : widget.screens == 4
                                ? () {
                                    _hotelProvider.clearAllTray();
                                    navPage(
                                            context: context,
                                            page:
                                                const RoomServiceReturnModuleFinal(),
                                            enablePop: false)
                                        .navPageToPage();
                                  }
                                :null,
            child: null,
          ),
        ),
    ]);
  }
}
