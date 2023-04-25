import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/OrderModules/CheckOutModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/NFCModalFinal.dart';
import 'package:kori_wis_demo/Modals/OrderModules/PaymentModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
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

  late double buttonRadius1;
  late double buttonRadius2;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String selectedItemFrame = 'assets/icons/decoration/selectItem.png';

  int? selectedQt;

  bool? checkOutItems;

  List<bool>? selectedItem;

  List<String> selectedItemList = [];

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
                  Text(
                    '서비스를 준비 중 입니다.',
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 50,
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
                          top: LinearBorderEdge(size: 1)),
                      minimumSize:
                          Size(screenWidth * 0.5, screenHeight * 0.05)),
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

    setState(() {
      selectedQt = _orderProvider.SelectedQT;
    });

    if (selectedQt == 0) {
      checkOutItems = true;
    } else {
      checkOutItems = false;
    }

    if (widget.screens == 0) {
      // 장바구니 담기
      buttonPositionWidth = [60.3, 515.6, 60.3, 515.6, 262];
      buttonPositionHeight = [321, 321, 772, 772, 1309];

      buttonSize1 = [419, 419];
      buttonSize2 = [674, 142];

      buttonRadius1 = 43;
      buttonRadius2 = 40;

      SelButtonPositionWidth = [57.5, 507.5, 57.5, 507.5, 370];

      SelButtonPositionHeight = [316, 316, 769, 769, 1855];
      SelButtonSize = [430, 430];

      if (selectedQt == 0) {
        _orderProvider.SelectedItemsQT = [true, true, true, true];
      }
    } else if (widget.screens == 1) {
      // 장바구니 확인
      buttonPositionWidth = [563.5];
      buttonPositionHeight = [1188.3];

      buttonSize = [370.5, 142.5];

      buttonRadius = 40;
    } else if (widget.screens == 2) {
      // 결제 선택 및 금액 확인
      buttonPositionWidth = [62, 506, 62, 506, 62, 506];
      buttonPositionHeight = [550, 550, 750, 750, 949, 949];

      buttonSize = [425, 178];

      buttonRadius = 28;
    }else if (widget.screens == 3) {
      // 결제 선택 및 금액 확인
      buttonPositionWidth = [88];
      buttonPositionHeight = [1305];

      buttonSize = [813.8, 160];

      buttonRadius = 28;
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
                      // side: BorderSide(width: 1, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(widget.screens == 0
                          ? i == 4
                              ? buttonRadius2
                              : buttonRadius1
                          : buttonRadius)),
                  fixedSize: (widget.screens == 0)
                      ? i == (buttonNumbers - 1)
                          ? Size(buttonSize2[buttonWidth],
                              buttonSize2[buttonHeight])
                          : Size(buttonSize1[buttonWidth],
                              buttonSize1[buttonHeight])
                      : Size(
                          buttonSize[buttonWidth], buttonSize[buttonHeight])),
              onPressed: widget.screens == 0
                  ? () {
                      if (i != 4) {
                        setState(() {
                          if (_orderProvider.SelectedItemsQT![i] == false) {
                            _orderProvider.SelectedItemsQT![i] = true;
                            selectedQt = selectedQt! - 1;
                            _orderProvider.SelectedQT = selectedQt;
                            if(i==0){
                              selectedItemList.remove('햄버거');
                            }else if(i==1){
                              selectedItemList.remove('라면');
                            }else if(i==2){
                              selectedItemList.remove('치킨');
                            }else if(i==3){
                              selectedItemList.remove('핫도그');
                            }
                          } else {
                            _orderProvider.SelectedItemsQT![i] = false;
                            selectedQt = selectedQt! + 1;
                            _orderProvider.SelectedQT = selectedQt;
                            if(i==0){
                              selectedItemList.add('햄버거');
                            }else if(i==1){
                              selectedItemList.add('라면');
                            }else if(i==2){
                              selectedItemList.add('치킨');
                            }else if(i==3){
                              selectedItemList.add('핫도그');
                            }
                          }
                          _orderProvider.selectedItemsList = selectedItemList;
                        });
                      } else {
                        showCheckingPopup(context);
                      }
                      print(_orderProvider.SelectedItemsQT);
                      print(selectedQt);
                      print(_orderProvider.SelectedQT);
                    }
                  : widget.screens == 1
                      ? () {
                            showPaymentPopup(context);
                        }
                      : widget.screens == 2
                          ? () {
                              if (i == 1) {
                                showNFCPopup(context);
                              } else {
                                showCashServing(context);
                              }
                            }
                          : widget.screens == 3 ?(){
                navPage(context: context, page: TraySelectionFinal(), enablePop: false).navPageToPage();
              } :null,
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
