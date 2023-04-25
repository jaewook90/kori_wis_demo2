import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/OrderModules/itemOrderModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class CheckOutScreenFinal extends StatefulWidget {
  const CheckOutScreenFinal({Key? key}) : super(key: key);

  @override
  State<CheckOutScreenFinal> createState() => _CheckOutScreenFinalState();
}

class _CheckOutScreenFinalState extends State<CheckOutScreenFinal> {
  late OrderModel _orderProvider;
  String shoppingCartImg = 'assets/screens/Serving/koriZFinalShoppingCart.png';

  late String selectedItemImg;

  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  late String hamburgerEng;
  late String hotDogEng;
  late String chickenEng;
  late String ramyeonEng;

  late int hamburgerPrice;
  late int hotDogPrice;
  late int chickenPrice;
  late int ramyeonPrice;

  late int hamburgerTotalPrice;
  late int hotDogTotalPrice;
  late int chickenTotalPrice;
  late int ramyeonTotalPrice;

  late int totalPrice;

  late int hamburgerQT;
  late int hotDogQT;
  late int chickenQT;
  late int ramyeonQT;

  List<String> selectedItemList = [];

  void showOrderPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ItemOrderModalFinal();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hamburger = "assets/images/serving_item_imgs/hamburger.png";
    hotDog = "assets/images/serving_item_imgs/hotDog.png";
    chicken = "assets/images/serving_item_imgs/chicken.png";
    ramyeon = "assets/images/serving_item_imgs/ramyeon.png";

    hamburgerEng = "Hamburger";
    hotDogEng = "Hotdog";
    chickenEng = "Chicken";
    ramyeonEng = "Ramyeon";

    hamburgerPrice = 6700;
    hotDogPrice = 4800;
    chickenPrice = 18000;
    ramyeonPrice = 3500;

    hamburgerQT = 0;
    hotDogQT = 0;
    chickenQT = 0;
    ramyeonQT = 0;

    hamburgerTotalPrice = 0;
    hotDogTotalPrice = 0;
    chickenTotalPrice = 0;
    ramyeonTotalPrice = 0;

    totalPrice = 0;

  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    selectedItemList = _orderProvider.selectedItemsList!;

    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1401,
          width: 998,
          child: Stack(children: [
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(image: AssetImage(shoppingCartImg))),
              child: Container(),
            ),
            Positioned(
                left: 52,
                top: 29.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      print("aaaaaaaaaaaaaaaaaaaaaaaaa");
                      print(_orderProvider.SelectedQT);
                      Navigator.pop(context);
                      // Navigator.pop(context);
                      // showOrderPopup(context);
                    },
                    child: null,
                  ),
                )),
            Positioned(
                left: 891,
                top: 29.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: null,
                  ),
                )),
            // 1번 목록 예시
            Container(
              padding: EdgeInsets.fromLTRB(0, 85, 0, 280),
              child: Scrollbar(
                thickness: 4.0,
                radius: Radius.circular(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: selectedItemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(60, 25, 60, 0),
                        height: 240,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Color(0xff292929),
                            borderRadius: BorderRadius.circular(50)),
                        child: Stack(
                          children: [
                            Positioned(
                                left: 60,
                                top: 30,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  // color: Colors.transparent,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(selectedItemList[
                                                    index] ==
                                                "햄버거"
                                            ? hamburger
                                            : selectedItemList[index] == "라면"
                                                ? ramyeon
                                                : selectedItemList[index] ==
                                                        "치킨"
                                                    ? chicken
                                                    : selectedItemList[index] ==
                                                            "핫도그"
                                                        ? hotDog
                                                        : "")),
                                  ),
                                )),
                            Positioned(
                                left: 300,
                                top: 40,
                                child: Container(
                                  width: 150,
                                  height: 60,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${selectedItemList[index]}',
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 300,
                                top: 100,
                                child: Container(
                                  width: 120,
                                  height: 28,
                                  // color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? hamburgerEng
                                            : selectedItemList[index] == "라면"
                                                ? ramyeonEng
                                                : selectedItemList[index] ==
                                                        "치킨"
                                                    ? chickenEng
                                                    : selectedItemList[index] ==
                                                            "핫도그"
                                                        ? hotDogEng
                                                        : "",
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 20,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 300,
                                top: 155,
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  // color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? '$hamburgerPrice 원'
                                            : selectedItemList[index] == "라면"
                                                ? '$ramyeonPrice 원'
                                                : selectedItemList[index] ==
                                                        "치킨"
                                                    ? '$chickenPrice 원'
                                                    : selectedItemList[index] ==
                                                            "핫도그"
                                                        ? '$hotDogPrice 원'
                                                        : "",
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 25,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 653,
                                top: 43,
                                child: Container(
                                  width: 155,
                                  height: 50,
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? '$hamburgerQT'
                                            : selectedItemList[index] == "라면"
                                                ? '$ramyeonQT'
                                                : selectedItemList[index] == "치킨"
                                                    ? '$chickenQT'
                                                    : selectedItemList[index] ==
                                                            "핫도그"
                                                        ? '$hotDogQT'
                                                        : "",
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 650,
                                top: 47,
                                child: Container(
                                    width: 155,
                                    height: 50,
                                    color: Colors.transparent,
                                    // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 1))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            style: IconButton.styleFrom(
                                                fixedSize: Size(40, 40)),
                                            onPressed: () {
                                              setState(() {
                                                if (selectedItemList[index] ==
                                                    "햄버거") {
                                                  hamburgerQT--;
                                                  hamburgerTotalPrice = hamburgerQT * hamburgerPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "라면") {
                                                  ramyeonQT--;
                                                  ramyeonTotalPrice = ramyeonQT * ramyeonPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "치킨") {
                                                  chickenQT--;
                                                  chickenTotalPrice = chickenQT * chickenPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "핫도그") {
                                                  hotDogQT--;
                                                  hotDogTotalPrice = hotDogQT * hotDogPrice;
                                                }
                                                totalPrice = hamburgerTotalPrice + ramyeonTotalPrice + chickenTotalPrice + hotDogTotalPrice;
                                              });
                                            },
                                            icon: Icon(
                                              Icons
                                                  .remove_circle_outline_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                        IconButton(
                                            style: IconButton.styleFrom(
                                                fixedSize: Size(40, 40)),
                                            onPressed: () {
                                              setState(() {
                                                if (selectedItemList[index] ==
                                                    "햄버거") {
                                                  hamburgerQT++;
                                                  hamburgerTotalPrice = hamburgerQT * hamburgerPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "라면") {
                                                  ramyeonQT++;
                                                  ramyeonTotalPrice = ramyeonQT * ramyeonPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "치킨") {
                                                  chickenQT++;
                                                  chickenTotalPrice = chickenQT * chickenPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "핫도그") {
                                                  hotDogQT++;
                                                  hotDogTotalPrice = hotDogQT * hotDogPrice;
                                                }
                                                totalPrice = hamburgerTotalPrice + ramyeonTotalPrice + chickenTotalPrice + hotDogTotalPrice;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            ))
                                      ],
                                    ))),
                            Positioned(
                                left: 555,
                                top: 140,
                                child: Container(
                                  width: 45,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '￦',
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 555,
                                top: 140,
                                child: Container(
                                  width: 250,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                  selectedItemList[index] == "햄버거"
                                  ? '$hamburgerTotalPrice'
                                      : selectedItemList[index] == "라면"
                                  ? '$ramyeonTotalPrice'
                                          : selectedItemList[index] == "치킨"
                                      ? '$chickenTotalPrice'
                                      : selectedItemList[index] ==
                                      "핫도그"
                                      ? '$hotDogTotalPrice'
                                          : "",
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
              ),
            ),

            Positioned(
                left: 200,
                top: 1213,
                child: Container(
                  width: 210,
                  height: 80,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$totalPrice',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 55,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 430,
                top: 1213,
                child: Container(
                  width: 55,
                  height: 80,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 55,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            OrderModuleButtonsFinal(
              screens: 1,
            )
          ]),
        ),
      ),
    );
  }
}

// 기존
// Container(
//         margin:
//             EdgeInsets.fromLTRB(0, screenHeight * 0.05, 0, screenHeight * 0.15),
//         child: Dialog(s
//           backgroundColor: Color(0xff000000),
//           shape: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(0),
//               borderSide: BorderSide(
//                 color: Color(0xFFB7B7B7),
//                 style: BorderStyle.solid,
//                 width: 1,
//               )),
//           child: Stack(children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Stack(children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(Icons.arrow_back_sharp),
//                         color: const Color(0xffF0F0F0),
//                         iconSize: 60,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           navPage(
//                                   context: context,
//                                   page: TraySelection3(),
//                                   enablePop: false)
//                               .navPageToPage();
//                         },
//                         icon: Icon(Icons.cancel_presentation_outlined),
//                         color: const Color(0xffF0F0F0),
//                         iconSize: 60,
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(screenWidth * 0.012,
//                         screenHeight * 0.04, 0, screenHeight * 0.015),
//                     width: screenWidth,
//                     height: screenHeight * 0.6,
//                     child: Scrollbar(
//                       thickness: 4.0,
//                       radius: Radius.circular(8.0),
//                       child: ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           itemCount: 1,
//                           itemBuilder: (BuildContext, int index) {
//                             return Column(
//                               children: [
//                                 for (int j = 0; j < (orderedItems.length); j++)
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                             borderRadius:
//                                                 BorderRadius.circular(0),
//                                             border: Border.fromBorderSide(
//                                                 BorderSide(
//                                                     color: Colors.white,
//                                                     style: BorderStyle.solid,
//                                                     width: 1))),
//                                         height: screenHeight * 0.175,
//                                         width: screenWidth * 0.3,
//                                         child: Row(
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Container(
//                                                     margin: EdgeInsets.fromLTRB(
//                                                         0,
//                                                         screenHeight * 0.015,
//                                                         0,
//                                                         0),
//                                                     height: screenHeight * 0.1,
//                                                     width: screenWidth * 0.2,
//                                                     decoration: BoxDecoration(
//                                                         image: DecorationImage(
//                                                             image: AssetImage(orderedItems[
//                                                                         j] ==
//                                                                     '햄버거'
//                                                                 ? menuImgItems[
//                                                                     0]
//                                                                 : orderedItems[
//                                                                             j] ==
//                                                                         '라면'
//                                                                     ? menuImgItems[
//                                                                         1]
//                                                                     : orderedItems[j] ==
//                                                                             '치킨'
//                                                                         ? menuImgItems[
//                                                                             2]
//                                                                         : menuImgItems[
//                                                                             3]),
//                                                             fit: BoxFit
//                                                                 .fitHeight))),
//                                                 Container(
//                                                   margin: EdgeInsets.fromLTRB(
//                                                       0,
//                                                       screenHeight * 0.01,
//                                                       0,
//                                                       screenHeight * 0.01),
//                                                   width: screenWidth * 0.29,
//                                                   height: 3,
//                                                   color: Colors.white,
//                                                 ),
//                                                 Container(
//                                                   child: Text(
//                                                     orderedItems[j] == '햄버거'
//                                                         ? menuItems[0]
//                                                         : orderedItems[j] ==
//                                                                 '라면'
//                                                             ? menuItems[1]
//                                                             : orderedItems[j] ==
//                                                                     '치킨'
//                                                                 ? menuItems[2]
//                                                                 : menuItems[3],
//                                                     style: tableButtonFont,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                             borderRadius:
//                                                 BorderRadius.circular(0),
//                                             border: Border.fromBorderSide(
//                                                 BorderSide(
//                                                     color: Colors.white,
//                                                     style: BorderStyle.solid,
//                                                     width: 1))),
//                                         height: screenHeight * 0.175,
//                                         width: screenWidth * 0.6,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Container(
//                                                   margin: EdgeInsets.fromLTRB(
//                                                       0, 0, 0, 0),
//                                                   height: screenHeight * 0.108,
//                                                   width: screenWidth * 0.56,
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Stack(
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Container(
//                                                                   // margin: EdgeInsets.only(top: screenHeight*0.01),
//                                                                   margin: EdgeInsets.fromLTRB(
//                                                                       screenWidth *
//                                                                           0.15,
//                                                                       screenHeight *
//                                                                           0.01,
//                                                                       0,
//                                                                       0),
//                                                                   width:
//                                                                       screenWidth *
//                                                                           0.2,
//                                                                   height:
//                                                                       screenHeight *
//                                                                           0.04,
//                                                                   child: Text(
//                                                                       '개별가격')),
//                                                             ],
//                                                           ),
//                                                           Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .end,
//                                                             children: [
//                                                               Container(
//                                                                 // padding: EdgeInsets.only(right: screenWidth*0.06),
//                                                                 width:
//                                                                     screenWidth *
//                                                                         0.2,
//                                                                 height:
//                                                                     screenHeight *
//                                                                         0.04,
//                                                                 child: Column(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         IconButton(
//                                                                           onPressed:
//                                                                               () {},
//                                                                           icon:
//                                                                               Icon(Icons.remove_circle_outline_outlined),
//                                                                           iconSize:
//                                                                               60,
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ),
//                                                                         Text(
//                                                                             '갯수'),
//                                                                         IconButton(
//                                                                           onPressed:
//                                                                               () {},
//                                                                           icon:
//                                                                               Icon(Icons.add_circle_outline_outlined),
//                                                                           iconSize:
//                                                                               60,
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.fromLTRB(
//                                                       0,
//                                                       screenHeight * 0.01,
//                                                       0,
//                                                       screenHeight * 0.01),
//                                                   width: screenWidth * 0.59,
//                                                   height: 3,
//                                                   color: Colors.white,
//                                                 ),
//                                                 Container(
//                                                   child: Text(
//                                                     '상품 별 총 가격',
//                                                     style: tableButtonFont,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                               ],
//                             );
//                           }),
//                     ),
//                   ),
//                 ]),
//                 Container(
//                   margin: EdgeInsets.only(right: 50),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             showPaymentPopup(context);
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.payment,
//                                 color: Color(0xffB7B7B7),
//                                 size: 120,
//                               ),
//                               Text(
//                                 '결제',
//                                 style: tableFont,
//                               ),
//                             ],
//                           ),
//                           style: TextButton.styleFrom(
//                               backgroundColor: Color.fromRGBO(45, 45, 45, 45),
//                               // backgroundColor: Color(0xFF2D2D2D),
//                               fixedSize:
//                                   Size(textButtonWidth, textButtonHeight * 0.7),
//                               shape: RoundedRectangleBorder(
//                                   // side: BorderSide(
//                                   //     color: Color(0xFFB7B7B7),
//                                   //     style: BorderStyle.solid,
//                                   //     width: 1),
//                                   borderRadius: BorderRadius.circular(40)))),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//                 top: 1310,
//                 left: 50,
//                 child: Icon(Icons.attach_money,
//                     size: 100, color: Color(0xffB7B7B7))),
//             Positioned(
//               top: 1310,
//                 left: 170,
//                 child: Text('총 결제금', style: TextStyle(
//                   fontFamily: 'kor',
//                     fontSize: 65,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xffB7B7B7)
//                 ) )),
//           ]),
//         ));
