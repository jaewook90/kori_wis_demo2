import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';

class CheckOutScreenFinal extends StatefulWidget {
  const CheckOutScreenFinal({Key? key}) : super(key: key);

  @override
  State<CheckOutScreenFinal> createState() => _CheckOutScreenFinalState();
}

class _CheckOutScreenFinalState extends State<CheckOutScreenFinal> {

  String shoppingCartImg = 'assets/screens/Serving/koriZFinalShoppingCart.png';


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Dialog(
        backgroundColor: Color(0xff000000),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Color(0xFFB7B7B7),
              style: BorderStyle.solid,
              width: 1,
            )),
        child: Stack(children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(shoppingCartImg))),
            child: Container(),
          ),
          Positioned(
              left: 110 * 0.75,
              top: 264 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                color: Colors.transparent,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // shape: RoundedRectangleBorder(
                      //     side: BorderSide(width: 1, color: Colors.white),
                      //     borderRadius: BorderRadius.circular(0))
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: null,
                ),
              )),
          Positioned(
              left: 1150 * 0.75,
              top: 264 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                color: Colors.transparent,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // shape: RoundedRectangleBorder(
                      //     side: BorderSide(width: 1, color: Colors.white),
                      //     borderRadius: BorderRadius.circular(0))
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: null,
                ),
              )),
          // 1번 목록 예시
          Positioned(
              left: 1003 * 0.75,
              top: 427 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                color: Colors.transparent,
                child: Text('1', style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Color(0xffffffff),
                ),),
              )),
          Positioned(
              left: 925 * 0.75,
              top: 535 * 0.75,
              child: Container(
                width: 300,
                height: 48,
                color: Colors.transparent,
                child: Text('6,700', style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Color(0xffffffff),
                ),),
              )),
          Positioned(
              left: 1003 * 0.75,
              top: 735 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                color: Colors.transparent,
                child: Text('2', style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Color(0xffffffff),
                ),),
              )),
          Positioned(
              left: 925 * 0.75,
              top: 843 * 0.75,
              child: Container(
                width: 300,
                height: 48,
                color: Colors.transparent,
                child: Text('4,800', style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 40,
                  color: Color(0xffffffff),
                ),),
              )),
          Positioned(
              left: 1150 * 0.75,
              top: 264 * 0.75,
              child: Container(
                width: 48,
                height: 48,
                color: Colors.transparent,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // shape: RoundedRectangleBorder(
                      //     side: BorderSide(width: 1, color: Colors.white),
                      //     borderRadius: BorderRadius.circular(0))
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: null,
                ),
              )),
          Positioned(
              left: 320 * 0.75,
              top: 1728 * 0.75,
              child: Container(
                width: 300,
                height: 80,
                color: Colors.transparent,
                child: Text('11,500', style: TextStyle(
                  fontFamily: 'kor',
                  fontSize: 55,
                  color: Color(0xffffffff),
                ),),
              )),
          OrderModuleButtonsFinal(screens: 1,)
        ]),
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

