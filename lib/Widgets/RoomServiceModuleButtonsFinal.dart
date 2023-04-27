import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellBoyYNModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellboyDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/RoomServiceDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/hotelBookedRoomWarnModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/ShippingDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/RoomServiceModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyReturn.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellboyDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomInfoNCartFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomSelectFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceReturn.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
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
  // late NetworkModel _networkProvider;

  late RoomServiceModel _roomServiceProvider;
  late OrderModel _orderProvider;

  late var screenList = List<Widget>.empty();
  late var serviceList = List<Widget>.empty();

  late var homeButtonName = List<String>.empty();

  // 메뉴 및 호실 선택 요소
  List<String> menuItems = ['수건', '헤어', '가운', '스킨'];

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

  String? startUrl;
  String? navUrl;

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
          return RoomServiceDestinationListModalFinal();
        });
  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal();
        });
  }

  void showNoDestinationWarn(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: SizedBox(
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
            backgroundColor: Color(0xff2C2C2C),
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
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
                  child: Text(
                    '확 인',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 30,
                        color: Color(0xffF0F0F0)),
                  ),
                  style: TextButton.styleFrom(
                      shape: LinearBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          top: LinearBorderEdge(size: 0.8)),
                      minimumSize:
                      Size(680, 81)),
                ),
              ),
            ],
          );
        });
  }

  void uploadRoomNumberNItemImg() {
    if (_roomServiceProvider.tray1Select == true) {
      // _roomServiceProvider.setTray1();
      setState(() {
        _roomServiceProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _roomServiceProvider.servedItem1 = false;
      });
    } else if (_roomServiceProvider.tray2Select == true) {
      // _roomServiceProvider.setTray1();
      setState(() {
        _roomServiceProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _roomServiceProvider.servedItem2 = false;
      });
    } else if (_roomServiceProvider.tray3Select == true) {
      // _roomServiceProvider.setTray1();
      setState(() {
        _roomServiceProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _roomServiceProvider.servedItem3 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _roomServiceProvider =
        Provider.of<RoomServiceModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    tableNumber = _roomServiceProvider.tableNumber;
    itemName = _roomServiceProvider.menuItem;

    if (_roomServiceProvider.trayCheckAll == false) {
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
      // 택배 메인 화면
      buttonPositionWidth = [84];
      buttonPositionHeight = [155];

      buttonSize = [915, 160];

      buttonRadius = 30;
    } else if (widget.screens == 1) {
      buttonPositionWidth = [104.3, 559.6, 104.3, 559.6];
      buttonPositionHeight = [459, 459, 910.5, 910.5];

      buttonSize = [420, 420];

      buttonRadius = 40;
    } else if (widget.screens == 2) {
      // 키패드 화면
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
        520.5,
        520.5,
        520.5,
        810,
        810,
        810,
        1100,
        1100,
        1100,
        1394,
        1394,
        1394
      ];

      buttonSize = [261, 258];

      buttonRadius = 50;
    } else if (widget.screens == 3) {
      // 목적지 리스트
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
          : widget.screens == 2 ?Positioned(
        top: 220,
        left: 400,
        width: 270,
        height: 180,
        child: Text(
          '$currentNum',
          style: TextStyle(
              fontFamily: 'kor',
              fontSize: 150,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        ),
      ) : Container(),
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
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(width: 1, color: Colors.redAccent),
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
              if ((_roomServiceProvider.tray1 == true ||
                  _roomServiceProvider.tray2 == true) ||
                  _roomServiceProvider.tray3 == true) {
                showCountDownPopup(context);
              } else {
                _roomServiceProvider.trayCheckAll = true;
                navPage(
                    context: context,
                    page: RoomServiceDestinationScreenFinal(),
                    enablePop: true)
                    .navPageToPage();
                _roomServiceProvider.menuItem = "상품";
              }
              // navPage(
              //         context: context,
              //         page: RoomServiceDestinationScreenFinal(),
              //         enablePop: true)
              //     .navPageToPage();
            }
                : widget.screens == 1
                ? () {
              setState(() {
                if (i == 0) {
                  _roomServiceProvider.menuItem = menuItems[i];
                } else if (i == 1) {
                  _roomServiceProvider.menuItem = menuItems[i];
                } else if (i == 2) {
                  _roomServiceProvider.menuItem = menuItems[i];
                } else {
                  _roomServiceProvider.menuItem = menuItems[i];
                }
              });
              if (_roomServiceProvider.tray1Select == true) {
                _roomServiceProvider.setItemTray1();
              } else if (_roomServiceProvider.tray2Select == true) {
                _roomServiceProvider.setItemTray2();
              } else if (_roomServiceProvider.tray3Select == true) {
                _roomServiceProvider.setItemTray3();
              }
              navPage(
                  context: context,
                  page: RoomServiceDestinationScreenFinal(),
                  enablePop: true)
                  .navPageToPage();
            }
                : widget.screens == 2
                ? () {
              setState(() {
                if (currentNum!.length < 3) {
                  if (i < 9) {
                    currentNum = '${currentNum}${i + 1}';
                  }
                }
              });
              if (i == 9) {
                showDestinationListPopup(context);
              } else if (i == 10) {
                currentNum = '${currentNum}0';
              } else if (i == 11) {
                setState(() {
                  if(currentNum==""){
                    showNoDestinationWarn(context);
                  }else {
                    _roomServiceProvider.tableNumber =
                    '$currentNum';
                    if (_roomServiceProvider.trayCheckAll ==
                        false) {
                      if (_roomServiceProvider.tray1Select ==
                          true) {
                        _roomServiceProvider.tray1 = true;
                        _roomServiceProvider.table1 =
                        "$currentNum";
                      } else if (_roomServiceProvider
                          .tray2Select ==
                          true) {
                        _roomServiceProvider.tray2 = true;
                        _roomServiceProvider.table2 =
                        "$currentNum";
                      } else {
                        _roomServiceProvider.tray3 = true;
                        _roomServiceProvider.table3 =
                        "$currentNum";
                      }
                      uploadRoomNumberNItemImg();
                      navPage(
                          context: context,
                          page: RoomServiceMenu(),
                          enablePop: false)
                          .navPageToPage();
                    } else {
                      _roomServiceProvider.setTrayAll();
                      _roomServiceProvider.tableNumber =
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
                _roomServiceProvider.tableNumber =
                '$currentNum';
                if (_roomServiceProvider.trayCheckAll ==
                    false) {
                  if (_roomServiceProvider.tray1Select ==
                      true) {
                    _roomServiceProvider.tray1 = true;
                    _roomServiceProvider.table1 =
                    "$currentNum";
                  } else if (_roomServiceProvider
                      .tray2Select ==
                      true) {
                    _roomServiceProvider.tray2 = true;
                    _roomServiceProvider.table2 =
                    "$currentNum";
                  } else {
                    _roomServiceProvider.tray3 = true;
                    _roomServiceProvider.table3 =
                    "$currentNum";
                  }
                  uploadRoomNumberNItemImg();
                  navPage(
                      context: context,
                      page: RoomServiceMenu(),
                      enablePop: false)
                      .navPageToPage();
                } else {
                  _roomServiceProvider.setTrayAll();
                  _roomServiceProvider.tableNumber =
                  "$currentNum";
                  showCountDownPopup(context);
                }
              });
            }
                : widget.screens == 4
                ? () {
              _roomServiceProvider.clearAllTray();
              navPage(
                  context: context,
                  page: RoomServiceReturnModuleFinal(),
                  enablePop: false)
                  .navPageToPage();
            }
                : widget.screens == 5
                ? () {}
                : null,
            child: null,
          ),
        ),
    ]);
  }
}
