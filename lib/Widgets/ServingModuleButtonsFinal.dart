import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/OrderModules/itemOrderModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/TrayStatusModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/tableSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/trayCheckingModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/AdminScreen.dart';
import 'package:kori_wis_demo/Screens/ConfigScreen.dart';
import 'package:kori_wis_demo/Screens/LinkConnectorScreen.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceMenu.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class ServingModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const ServingModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<ServingModuleButtonsFinal> createState() =>
      _ServingModuleButtonsFinalState();
}

class _ServingModuleButtonsFinalState extends State<ServingModuleButtonsFinal> {
  // late NetworkModel _networkProvider;

  late ServingModel _servingProvider;
  late OrderModel _orderProvider;

  late var homeButtonName = List<String>.empty();

  double pixelRatio = 0.75;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  List<String> menuItems = ['햄버거', '라면', '치킨', '핫도그'];
  List<String> receiptMenu = [
    '햄버거',
    '핫도그',
    '미주문',
    '핫도그',
    '라면',
    '미주문',
    '핫도그',
    '핫도그'
  ];

  String? table1;
  String? table2;
  String? table3;
  String? tableAll;

  String? item1;
  String? item2;
  String? item3;

  int itemNumber = 0;
  String? itemName;

  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  late List<List> itemImagesList;
  late List<String> itemImages;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // poseDataUpdate(widget.parsePoseData);

    homeButtonName = ["택배", "서빙", "호텔"];

    hamburger = "assets/images/serving_item_imgs/hamburger.png";
    hotDog = "assets/images/serving_item_imgs/hotDog.png";
    chicken = "assets/images/serving_item_imgs/chicken.png";
    ramyeon = "assets/images/serving_item_imgs/ramyeon.png";

    itemImages = [hamburger, hotDog, chicken, ramyeon];
    itemImagesList = [itemImages, itemImages, itemImages];
  }

  void showOrderPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ItemOrderModalFinal();
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

  void showTableSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SelectTableModalFinal();
        });
  }

  void showTrayStatusPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return TrayStatusModalFinal();
        });
  }

  // 다른 트레이 상품 추가 여부
  void showCheckingPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return TrayCheckingModalFinal();
        });
  }

  void uploadTableNumberNItemImg() {
    if (_servingProvider.tray1Select == true) {
      _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _servingProvider.servedItem1 = false;
      });
    } else if (_servingProvider.tray2Select == true) {
      _servingProvider.setTray1();
      setState(() {
        _servingProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _servingProvider.servedItem2 = false;
      });
    } else if (_servingProvider.tray3Select == true) {
      _servingProvider.setTray1();
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

    itemName = _servingProvider.menuItem;

    if (widget.screens == 0) {
      // 서빙화면(주문하기 및 서빙시작)
      buttonPositionWidth = [109, 757];
      buttonPositionHeight = [225, 225];

      buttonSize = [570, 220];

      buttonRadius = 30;
    } else if (widget.screens == 1) {
      // 서빙 상품 선택 화면
      buttonPositionWidth = [100, 688, 100, 688];
      buttonPositionHeight = [600, 600, 1180, 1180];

      buttonSize = [545, 545];

      buttonRadius = 30;
    } else if (widget.screens == 2) {
      // 서빙 테이블 선택 화면
      buttonPositionWidth = [254, 254, 254, 254, 788, 788, 788, 788];
      buttonPositionHeight = [515, 964, 1390, 1822, 515, 964, 1390, 1822];

      buttonSize = [292, 167];

      buttonRadius = 0;
    } else if (widget.screens == 3) {
      // 주문표 버전 선택 화면
      buttonPositionWidth = [70, 688, 70, 688, 70, 688, 70, 688];
      buttonPositionHeight = [444, 444, 872, 872, 1300, 1300, 1728, 1728];

      buttonSize = [570, 378];

      buttonRadius = 50;
    } else if (widget.screens == 4) {
      // 팝업 ( 추가 여부 / 카운트다운 )
      buttonPositionWidth = [70, 695];
      buttonPositionHeight = [327, 327];

      buttonSize = [565, 194];

      buttonRadius = 50;
    } else if (widget.screens == 5) {
      // 완료 화면
      buttonPositionWidth = [143];
      buttonPositionHeight = [1308];

      buttonSize = [1155, 230];

      buttonRadius = 50;
    }

    buttonNumbers = buttonPositionHeight.length;

    if (_servingProvider.trayCheckAll == false) {
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
    }

    return Stack(children: [
      for (int i = 0; i < buttonNumbers; i++)
        Positioned(
          left: buttonPositionWidth[i] * pixelRatio,
          top: buttonPositionHeight[i] * pixelRatio,
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius:
                        BorderRadius.circular(buttonRadius * pixelRatio)),
                fixedSize: Size(buttonSize[buttonWidth] * pixelRatio,
                    buttonSize[buttonHeight] * pixelRatio)),
            onPressed: widget.screens == 0
                ? () {
                    if (i == 0) {
                      setState(() {
                        _orderProvider.SelectedItemsQT=[false, false, false, false];
                      });
                      showOrderPopup(context);
                    } else {
                      _servingProvider.trayCheckAll = true;
                      // _servingProvider.servingBeginningIsNot=true;
                      showTableSelectPopup(context);
                      _servingProvider.menuItem = "상품";
                    }
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
                        Navigator.pop(context);
                        showTableSelectPopup(context);
                      }
                    : widget.screens == 2
                        ? () {
                            print(_servingProvider.trayCheckAll);
                            setState(() {
                              _servingProvider.tableNumber = "${i + 1}";
                              if (_servingProvider.trayCheckAll == false) {
                                if (_servingProvider.tray1Select == true) {
                                  _servingProvider.table1 = "${i + 1}";
                                } else if (_servingProvider.tray2Select ==
                                    true) {
                                  _servingProvider.table2 = "${i + 1}";
                                } else if (_servingProvider.tray3Select ==
                                    true) {
                                  _servingProvider.table3 = "${i + 1}";
                                }
                              } else {
                                _servingProvider.setTrayAll();
                                _servingProvider.tableNumber = "${i + 1}";
                              }
                            });
                            uploadTableNumberNItemImg();
                            showCheckingPopup(context);
                          }
                        : widget.screens == 3
                            ? receiptMenu[i] == '미주문'
                                ? null
                                : () {
                                    if (receiptMenu[i] != '미주문') {
                                      setState(() {
                                        _servingProvider.menuItem =
                                            receiptMenu[i];
                                        _servingProvider.tableNumber =
                                            "${i + 1}";
                                      });
                                    }
                                    if (_servingProvider.tray1Select == true) {
                                      _servingProvider.setTray1();
                                    } else if (_servingProvider.tray2Select ==
                                        true) {
                                      _servingProvider.setTray2();
                                    } else if (_servingProvider.tray3Select ==
                                        true) {
                                      _servingProvider.setTray3();
                                    }
                                    uploadTableNumberNItemImg();
                                    print("asdfasdfasdfasdf");
                                    print(_servingProvider.tray1Select);
                                    print(_servingProvider.tray2Select);
                                    print(_servingProvider.tray3Select);
                                    print("asdfasdfasdfasdf");
                                    showTrayStatusPopup(context);
                                  }
                            : widget.screens == 4
                                ? () {
                                    if (i == 0) {
                                      showCheckingPopup(context);
                                      // Navigator.pop(context);
                                      // Navigator.pop(context);
                                    } else {
                                      showCountDownPopup(context);
                                    }
                                  }
                                : widget.screens == 5
                                    ? () {
                                        _servingProvider.clearAllTray();
                                        navPage(
                                                context: context,
                                                page: TraySelectionFinal(),
                                                enablePop: false)
                                            .navPageToPage();
                                      }
                                    : null,
            child: null,
          ),
        ),
    ]);
  }
}