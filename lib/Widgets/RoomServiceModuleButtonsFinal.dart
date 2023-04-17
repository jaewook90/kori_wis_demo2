import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellBoyYNModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/BellboyDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/RoomServiceDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Modals/HotelModules/hotelBookedRoomWarnModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/ShippingDestinationsModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyReturn.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellboyDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenuFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomInfoNCartFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomSelectFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceDestinationModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceMenuFinal.dart';
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

  late ServingModel _servingProvider;
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

  void uploadRoomNumberNItemImg() {
    if (_servingProvider.tray1Select == true) {
      // _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _servingProvider.servedItem1 = false;
      });
    } else if (_servingProvider.tray2Select == true) {
      // _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _servingProvider.servedItem2 = false;
      });
    } else if (_servingProvider.tray3Select == true) {
      // _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _servingProvider.servedItem3 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    tableNumber = _servingProvider.tableNumber;
    itemName = _servingProvider.menuItem;

    if (_servingProvider.trayCheckAll == false) {
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
      buttonPositionWidth = [70.3, 517.3, 70.3, 517.3];
      buttonPositionHeight = [315.8, 315.8, 757.5, 757.5];

      buttonSize = [412, 412];

      buttonRadius = 35;
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
          : Positioned(
              top: 290 * 0.75,
              left: 551 * 0.75,
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
            ),
      widget.screens == 2
          ? Positioned(
              left: 1213 * 0.75,
              top: 451 * 0.75,
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
                    side: BorderSide(width: 1, color: Colors.redAccent),
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
                    if ((_servingProvider.tray1 == true ||
                            _servingProvider.tray2 == true) ||
                        _servingProvider.tray3 == true) {
                      showCountDownPopup(context);
                    } else {
                      _servingProvider.trayCheckAll = true;
                      // _servingProvider.servingBeginningIsNot=true;
                      navPage(
                              context: context,
                              page: RoomServiceDestinationScreenFinal(),
                              enablePop: true)
                          .navPageToPage();
                      _servingProvider.menuItem = "상품";
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
                            _servingProvider.menuItem = menuItems[i];
                          } else if (i == 1) {
                            _servingProvider.menuItem = menuItems[i];
                          } else if (i == 2) {
                            _servingProvider.menuItem = menuItems[i];
                          } else {
                            _servingProvider.menuItem = menuItems[i];
                          }
                        });
                        if (_servingProvider.tray1Select == true) {
                          _servingProvider.setItemTray1();
                        } else if (_servingProvider.tray2Select == true) {
                          _servingProvider.setItemTray2();
                        } else if (_servingProvider.tray3Select == true) {
                          _servingProvider.setItemTray3();
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
                                _servingProvider.tableNumber = '$currentNum';
                                if (_servingProvider.trayCheckAll == false) {
                                  if (_servingProvider.tray1Select == true) {
                                    _servingProvider.tray1 = true;
                                    _servingProvider.table1 = "$currentNum";
                                  } else if (_servingProvider.tray2Select ==
                                      true) {
                                    _servingProvider.tray2 = true;
                                    _servingProvider.table2 = "$currentNum";
                                  } else {
                                    _servingProvider.tray3 = true;
                                    _servingProvider.table3 = "$currentNum";
                                  }
                                  uploadRoomNumberNItemImg();
                                  navPage(
                                          context: context,
                                          page: RoomServiceMenu(),
                                          enablePop: false)
                                      .navPageToPage();
                                } else {
                                  _servingProvider.setTrayAll();
                                  _servingProvider.tableNumber = "$currentNum";
                                  showCountDownPopup(context);
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
                                  }else if (i == 6) {
                                    currentNum = '301';
                                  }
                                  _servingProvider.tableNumber = '$currentNum';
                                  if (_servingProvider.trayCheckAll == false) {
                                    if (_servingProvider.tray1Select == true) {
                                      _servingProvider.tray1 = true;
                                      _servingProvider.table1 = "$currentNum";
                                    } else if (_servingProvider.tray2Select ==
                                        true) {
                                      _servingProvider.tray2 = true;
                                      _servingProvider.table2 = "$currentNum";
                                    } else {
                                      _servingProvider.tray3 = true;
                                      _servingProvider.table3 = "$currentNum";
                                    }
                                    uploadRoomNumberNItemImg();
                                    navPage(
                                            context: context,
                                            page: RoomServiceMenu(),
                                            enablePop: false)
                                        .navPageToPage();
                                  } else {
                                    _servingProvider.setTrayAll();
                                    _servingProvider.tableNumber =
                                        "$currentNum";
                                    showCountDownPopup(context);
                                  }
                                });
                              }
                            : widget.screens == 4
                                ? () {
                                    navPage(
                                            context: context,
                                            page: BellboyReturnModuleFinal(),
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
