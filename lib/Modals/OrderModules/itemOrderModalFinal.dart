import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

import '../../Providers/ServingModel.dart';

class ItemOrderModalFinal extends StatefulWidget {
  const ItemOrderModalFinal({Key? key}) : super(key: key);

  @override
  State<ItemOrderModalFinal> createState() => _ItemOrderModalFinalState();
}

class _ItemOrderModalFinalState extends State<ItemOrderModalFinal> {
  late ServingModel _servingProvider;
  late OrderModel _orderProvider;

  String? tableNumber;

  List<String>? orderedItems;

  List<String> menuItems = ['햄버거', '라면', '치킨', '핫도그'];
  int? menuLength;

  String orderBookImg = 'assets/screens/Serving/koriZFinalOrderBook.png';

  String downArrowIcon1 = 'assets/icons/decoration/DownArrow1.png';
  String downArrowIcon2 = 'assets/icons/decoration/DownArrow2.png';
  String downArrowIcon3 = 'assets/icons/decoration/DownArrow3.png';

  late List<String> menuImgItems;

  // 배경 화면
  late String backgroundImage;

  // 상품 구분 번호
  // late int itemNumber;
  int itemNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    menuLength = menuItems.length;

  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    tableNumber = _servingProvider.tableNumber;

    if (_orderProvider.orderedItems == null) {
      orderedItems!.isEmpty;
    } else {
      orderedItems = _orderProvider.orderedItems;
    }


    print('asdfsadf');
    print(_orderProvider.orderedItems);
    print('asdfsadf');

    print(menuLength);
    print(menuLength.runtimeType);

    return Container(
      padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.white)),),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Color(0xFFB7B7B7),
              style: BorderStyle.solid,
              width: 1,
            )),
        child: Container(
          height: 1561,
          width: 992,
          child: Stack(children: [
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                  image: DecorationImage(image: AssetImage(orderBookImg))),
              child: Container(),
            ),
            Positioned(
                left: 888,
                top: 30.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(0))
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: null,
                  ),
                )),
            OrderModuleButtonsFinal(screens: 0,)
          ]),
        ),
      ),
    );
  }
}

// 장바구니 수량 확인
// Offstage(
//                     offstage: checkOutItems!,
//                     child: Container(
//                       // color: Colors.red,
//                       margin: EdgeInsets.fromLTRB(
//                           screenWidth * 0.14, screenWidth * 0.075, 0, 0),
//                       width: screenWidth * 0.08,
//                       height: screenWidth * 0.05,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(255, 0, 0, 30),
//                           borderRadius: BorderRadius.circular(50)),
//                       child: Center(
//                           child: Text(
//                         '$selectedQt',
//                         style: TextStyle(
//                             fontFamily: 'kor',
//                             color: Colors.black,
//                             fontSize: 35,
//                             fontWeight: FontWeight.bold),
//                       )),
//                     ),
//                   )

// 주문 선택 및 수량 변경
// child: Scrollbar(
//                       thickness: 4.0,
//                       radius: Radius.circular(8.0),
//                       child: ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           itemCount: 1,
//                           itemBuilder: (BuildContext, int index) {
//                             return Column(
//                               children: [
//                                 for (int j = 0; j < (menuItems.length) / 2; j++)
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           FilledButton(
//                                             style: FilledButton.styleFrom(
//                                                 backgroundColor:
//                                                     Colors.transparent,
//                                                 shape: RoundedRectangleBorder(
//                                                     side: BorderSide(
//                                                         color: Colors.white,
//                                                         width: 1))),
//                                             onPressed: () {
//                                               setState(() {
//                                                 if (selectedItem![(2 * j)] ==
//                                                     true) {
//                                                   _orderProvider.orderedItems!
//                                                       .add(menuItems[(2 * j)]);
//                                                   selectedItem!.replaceRange(
//                                                       (2 * j),
//                                                       (2 * j) + 1,
//                                                       [false]);
//                                                 } else {
//                                                   _orderProvider.orderedItems!
//                                                       .remove(
//                                                           menuItems[(2 * j)]);
//                                                   selectedItem!.replaceRange(
//                                                       (2 * j),
//                                                       (2 * j) + 1,
//                                                       [true]);
//                                                 }
//                                                 selectedQt = 0;
//                                                 for (int i = 0;
//                                                     i < selectedItem!.length;
//                                                     i++) {
//                                                   if (selectedItem![i] ==
//                                                       false) {
//                                                     setState(() {
//                                                       selectedQt =
//                                                           selectedQt! + 1;
//                                                     });
//                                                   }
//                                                 }
//                                               });
//                                               print('담은 상품 : $orderedItems');
//                                               print('담은 상품 갯수 : $selectedQt');
//                                             },
//                                             child: Column(
//                                               children: [
//                                                 Stack(children: [
//                                                   Container(
//                                                       height:
//                                                           screenHeight * 0.2,
//                                                       width: screenWidth * 0.4,
//                                                       decoration: BoxDecoration(
//                                                           image: DecorationImage(
//                                                               image: AssetImage(
//                                                                   menuImgItems[
//                                                                       (2 * j)]),
//                                                               fit: BoxFit
//                                                                   .fitHeight))),
//                                                   Offstage(
//                                                     offstage:
//                                                         selectedItem![(2 * j)],
//                                                     child: Container(
//                                                       padding:
//                                                           EdgeInsets.fromLTRB(
//                                                               screenWidth *
//                                                                   0.02,
//                                                               screenHeight *
//                                                                   0.01,
//                                                               0,
//                                                               0),
//                                                       child: Icon(
//                                                         Icons
//                                                             .check_circle_outline_rounded,
//                                                         size: 150,
//                                                         color: Colors.green,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ]),
//                                                 Container(
//                                                   margin: EdgeInsets.fromLTRB(
//                                                       0,
//                                                       screenHeight * 0.01,
//                                                       0,
//                                                       screenHeight * 0.01),
//                                                   width: screenWidth * 0.37,
//                                                   height: 3,
//                                                   color: Colors.white,
//                                                 ),
//                                                 Container(
//                                                   child: Text(
//                                                     menuItems[(2 * j)],
//                                                     style: tableButtonFont,
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       top: screenHeight * 0.01),
//                                                   width: screenWidth * 0.37,
//                                                   height: 3,
//                                                   color: Colors.white,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           FilledButton(
//                                               style: FilledButton.styleFrom(
//                                                   backgroundColor:
//                                                       Colors.transparent,
//                                                   shape: RoundedRectangleBorder(
//                                                       side: BorderSide(
//                                                           color: Colors.white,
//                                                           width: 1))),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   if (selectedItem![
//                                                           (2 * j) + 1] ==
//                                                       true) {
//                                                     _orderProvider.orderedItems!
//                                                         .add(menuItems[
//                                                             (2 * j) + 1]);
//                                                     selectedItem!.replaceRange(
//                                                         (2 * j) + 1,
//                                                         (2 * j) + 2,
//                                                         [false]);
//                                                   } else {
//                                                     _orderProvider.orderedItems!
//                                                         .remove(menuItems[
//                                                             (2 * j) + 1]);
//                                                     selectedItem!.replaceRange(
//                                                         (2 * j) + 1,
//                                                         (2 * j) + 2,
//                                                         [true]);
//                                                   }
//                                                 });
//                                                 selectedQt = 0;
//                                                 for (int i = 0;
//                                                     i < selectedItem!.length;
//                                                     i++) {
//                                                   if (selectedItem![i] ==
//                                                       false) {
//                                                     setState(() {
//                                                       selectedQt =
//                                                           selectedQt! + 1;
//                                                     });
//                                                   }
//                                                 }
//                                                 print('담은 상품 : $orderedItems');
//                                               },
//                                               child: Column(
//                                                 children: [
//                                                   Stack(children: [
//                                                     Container(
//                                                         height:
//                                                             screenHeight * 0.2,
//                                                         width:
//                                                             screenWidth * 0.4,
//                                                         decoration: BoxDecoration(
//                                                             image: DecorationImage(
//                                                                 image: AssetImage(
//                                                                     menuImgItems[
//                                                                         (2 * j) +
//                                                                             1]),
//                                                                 fit: BoxFit
//                                                                     .fitHeight))),
//                                                     Offstage(
//                                                       offstage: selectedItem![
//                                                           (2 * j) + 1],
//                                                       child: Container(
//                                                         padding:
//                                                             EdgeInsets.fromLTRB(
//                                                                 screenWidth *
//                                                                     0.02,
//                                                                 screenHeight *
//                                                                     0.01,
//                                                                 0,
//                                                                 0),
//                                                         child: Icon(
//                                                           Icons
//                                                               .check_circle_outline_rounded,
//                                                           size: 150,
//                                                           color: Colors.green,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ]),
//                                                   Container(
//                                                     margin: EdgeInsets.fromLTRB(
//                                                         0,
//                                                         screenHeight * 0.01,
//                                                         0,
//                                                         screenHeight * 0.01),
//                                                     width: screenWidth * 0.37,
//                                                     height: 3,
//                                                     color: Colors.white,
//                                                   ),
//                                                   Container(
//                                                     child: Text(
//                                                       menuItems[(2 * j) + 1],
//                                                       style: tableButtonFont,
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     margin: EdgeInsets.only(
//                                                         top: screenHeight *
//                                                             0.01),
//                                                     width: screenWidth * 0.37,
//                                                     height: 3,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ],
//                                               )),
//                                         ],
//                                       ),
//                                       (j + 1 < (menuItems.length) / 2)
//                                           ? Container(
//                                               height: screenHeight * 0.04,
//                                             )
//                                           : Container(),
//                                     ],
//                                   ),
//                               ],
//                             );
//                           }),
//                     ),

// 장바구니 확인 및 다음 화면으로 이동
// TextButton(
//                             onPressed: () {
//                               showCheckingPopup(context);
//                             },
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   // SizedBox(
//                                   //   width: textButtonWidth * 0.2,
//                                   // ),
//                                   Text(
//                                     '다음',
//                                     style: TextStyle(
//                                         fontFamily: 'kor',
//                                         fontSize: 100,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xffB7B7B7)),
//                                   ),
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     color: Color(0xffB7B7B7),
//                                     size: 110,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             style: TextButton.styleFrom(
//                                 backgroundColor:
//                                     const Color.fromRGBO(45, 45, 45, 45),
//                                 // backgroundColor: Color(0xFF2D2D2D),
//                                 fixedSize: Size(textButtonWidth * 1.3,
//                                     textButtonHeight * 0.8),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(40))))
