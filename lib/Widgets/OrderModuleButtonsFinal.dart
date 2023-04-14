import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/OrderModules/CheckOutModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/NFCModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:provider/provider.dart';

class OrderModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const OrderModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<OrderModuleButtonsFinal> createState() =>
      _OrderModuleButtonsFinalState();
}

class _OrderModuleButtonsFinalState extends State<OrderModuleButtonsFinal> {
  late OrderModel _orderProvider;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late List<double> SelButtonPositionWidth;
  late List<double> SelButtonPositionHeight;
  late List<double> SelButtonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String selectedItemFrame = 'assets/icons/decoration/selectItem.png';

  int? selectedQt;

  bool? checkOutItems;

  List<bool>? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedQt = 0;
    checkOutItems = true;
  }

  void showCheckingPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CheckOutScreenFinal();
        });
  }

  void showPaymentPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PaymentScreenFinal();
        });
  }

  void showNFCPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NFCModuleScreenFinal();
        });
  }

  void showCashServing(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            content: SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('현금 결제 준비 중', style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 50,
                      color: Color(0xffF0F0F0)
                  ),),
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
                          color: Color(0xffF0F0F0)
                        ),
                      ),
                      style: TextButton.styleFrom(
                          shape: LinearBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              top: LinearBorderEdge(size: 1)),
                          minimumSize:
                          Size(screenWidth * 0.5, screenHeight * 0.05)
                      ),
                    ),
                  ),
            ],
            // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    if (selectedQt == 0) {
      checkOutItems = true;
    } else {
      checkOutItems = false;
    }

    if (widget.screens == 0) {
      // 장바구니 담기
      buttonPositionWidth = [60.3, 515.6, 60.3, 515.6, 256];
      buttonPositionHeight = [321, 321, 772.5, 772.5, 1310.5];

      buttonSize1 = [420, 420];
      buttonSize2 = [675.8, 142.5];

      buttonRadius = 40;

      SelButtonPositionWidth = [55, 507, 56, 507, 370];

      SelButtonPositionHeight = [316, 316, 768.5, 768.5, 1855];
      SelButtonSize = [432, 432];

      if (selectedQt == 0) {
        _orderProvider.SelectedItemsQT = [true, true, true, true];
      }
    } else if (widget.screens == 1) {
      // 장바구니 확인
      buttonPositionWidth = [683.5, 817, 683.5, 817, 563.5];
      buttonPositionHeight = [154, 154, 400, 400, 1188.3];

      buttonSize1 = [53, 80];
      buttonSize2 = [370.5, 142.5];

      buttonRadius = 40;

      ;
    } else if (widget.screens == 2) {
      // 결제 선택 및 금액 확인
      buttonPositionWidth = [58.8, 520.3];
      buttonPositionHeight = [466, 466];

      buttonSize = [409.5, 318.8];

      buttonRadius = 50;
    }

    buttonNumbers = buttonPositionHeight.length;
    selectedItem = List<bool>.filled(buttonNumbers - 1, true, growable: true);

    return Stack(children: [
      if (widget.screens == 0)
        for (int i = 0; i < buttonNumbers - 1; i++)
          Positioned(
            left: SelButtonPositionWidth[i],
            top: SelButtonPositionHeight[i],
            child: Offstage(
              offstage: _orderProvider.SelectedItemsQT![i],
              child: Container(
                  width: SelButtonSize[buttonWidth],
                  height: SelButtonSize[buttonHeight],
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(selectedItemFrame),
                          fit: BoxFit.cover)),
                  child: null),
            ),
          ),
      for (int i = 0; i < buttonNumbers; i++)
        Stack(children: [
          Positioned(
            left: buttonPositionWidth[i],
            top: buttonPositionHeight[i],
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.redAccent),
                      borderRadius:
                          BorderRadius.circular(buttonRadius)),
                  fixedSize: (widget.screens == 0) || (widget.screens == 1)
                      ? i == (buttonNumbers - 1)
                          ? Size(buttonSize2[buttonWidth],
                              buttonSize2[buttonHeight])
                          : Size(buttonSize1[buttonWidth],
                              buttonSize1[buttonHeight])
                      : Size(buttonSize[buttonWidth],
                          buttonSize[buttonHeight])),
              onPressed: widget.screens == 0
                  ? () {
                      if (i != 4) {
                        setState(() {
                          if (_orderProvider.SelectedItemsQT![i] == false) {
                            _orderProvider.SelectedItemsQT![i] = true;
                            selectedQt = selectedQt! - 1;
                            _orderProvider.SelectedQT = selectedQt;
                          } else {
                            _orderProvider.SelectedItemsQT![i] = false;
                            selectedQt = selectedQt! + 1;
                            _orderProvider.SelectedQT = selectedQt;
                          }
                        });
                      } else {
                        setState(() {
                          _orderProvider.SelectedItemsQT![0] = true;
                          _orderProvider.SelectedItemsQT![1] = true;
                          _orderProvider.SelectedItemsQT![2] = true;
                          _orderProvider.SelectedItemsQT![3] = true;
                        });
                        showCheckingPopup(context);
                      }
                      print(_orderProvider.SelectedItemsQT);
                      print(selectedQt);
                      print(_orderProvider.SelectedQT);
                    }
                  : widget.screens == 1
                      ? () {
                          if (i == 4) {
                            showPaymentPopup(context);
                          }
                        }
                      : widget.screens == 2
                          ? () {
                              if (i == 1) {
                                showNFCPopup(context);
                              } else{
                                showCashServing(context);
                              }
                            }
                          : null,
              child: null,
            ),
          ),
        ]),
      if (widget.screens == 0)
        Positioned(
          left: 139.3,
          top: 1335.5,
          child: Offstage(
            offstage: checkOutItems!,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 30),
                  borderRadius: BorderRadius.circular(40)),
              child: Center(
                  child: Text(
                '$selectedQt',
                style: TextStyle(
                    fontFamily: 'kor',
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
    ]);
  }
}
