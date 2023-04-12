// import 'package:flutter/material.dart';
// import 'package:kori_wis_demo/Providers/NetworkModel.dart';
// import 'package:kori_wis_demo/Providers/ServingModel.dart';
// import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
// import 'package:kori_wis_demo/Utills/navScreens.dart';
// import 'package:provider/provider.dart';
//
// class TrayStatusFinal extends StatefulWidget {
//   const TrayStatusFinal({Key? key}) : super(key: key);
//
//   @override
//   State<TrayStatusFinal> createState() => _TrayStatusFinalState();
// }
//
// class _TrayStatusFinalState extends State<TrayStatusFinal> {
//   late NetworkModel _networkProvider;
//   late ServingModel _servingProvider;
//
//   String? startUrl;
//   String? navUrl;
//
//   String backgroundImage = "assets/images/KoriBackgroundImage_v1.png";
//
//   @override
//   Widget build(BuildContext context) {
//     _networkProvider = Provider.of<NetworkModel>(context, listen: false);
//     _servingProvider = Provider.of<ServingModel>(context, listen: false);
//
//     List<String> tableDestinations = [];
//     List<String> itemDestinations = [];
//     List<String> trayDestinations = [];
//
//     String? table1 = _servingProvider.table1;
//     String? table2 = _servingProvider.table2;
//     String? table3 = _servingProvider.table3;
//
//     String? item1 = _servingProvider.item1;
//     String? item2 = _servingProvider.item2;
//     String? item3 = _servingProvider.item3;
//
//     startUrl = _networkProvider.startUrl;
//     navUrl = _networkProvider.navUrl;
//
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double textBoxWidth = screenWidth * 0.8;
//     double textBoxHeight = screenHeight * 0.125;
//
//     double buttonWidth = screenWidth * 0.35;
//     double buttonHeight = screenHeight * 0.12;
//
//     TextStyle? textFont1 = Theme.of(context).textTheme.displayMedium;
//     TextStyle? textFont2 = Theme.of(context).textTheme.displaySmall;
//     TextStyle? subTextFont = Theme.of(context).textTheme.headlineLarge;
//     TextStyle? buttonFont = Theme.of(context).textTheme.displaySmall;
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(''),
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios_new_outlined),
//             color: Color(0xffB7B7B7),
//             iconSize: screenHeight * 0.03,
//             alignment: Alignment.centerRight,
//           ),
//           actions: [
//             IconButton(
//               padding: EdgeInsets.only(right: screenWidth * 0.05),
//               onPressed: () {
//                 _servingProvider.initServing();
//                 _servingProvider.clearAllTray();
//                 print("home ${_servingProvider.tableList}");
//                 navPage(
//                         context: context,
//                         page: ServiceScreenFinal(),
//                         enablePop: false)
//                     .navPageToPage();
//               },
//               icon: Icon(
//                 Icons.home_outlined,
//               ),
//               color: Color(0xffB7B7B7),
//               iconSize: screenHeight * 0.03,
//               alignment: Alignment.center,
//             ),
//             Icon(Icons.battery_charging_full,
//                 color: Colors.teal, size: screenHeight * 0.03),
//             SizedBox(width: screenWidth * 0.03)
//           ],
//           toolbarHeight: screenHeight * 0.045,
//         ),
//         extendBodyBehindAppBar: true,
//         body: Container(
//             constraints: BoxConstraints.expand(),
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(backgroundImage), fit: BoxFit.cover)),
//             child: Stack(children: [
//               Container(
//                 margin: EdgeInsets.only(top: screenHeight * 0.05),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             Text('선반 번호, 테이블 번호', style: textFont1),
//                             Text(' 및 상품을 확인하세요', style: textFont1),
//                             SizedBox(
//                               height: screenHeight * 0.04,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: screenHeight * 0.2),
//                 width: screenWidth,
//                 height: screenHeight * 0.45,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 color: Color.fromRGBO(45, 45, 45, 45),
//                                 borderRadius: BorderRadius.circular(40),
//                                 border: Border.fromBorderSide(BorderSide(
//                                     color: Color(0xFFB7B7B7),
//                                     style: BorderStyle.solid,
//                                     width: 1))),
//                             width: textBoxWidth,
//                             height: textBoxHeight,
//                             child: Padding(
//                               padding: EdgeInsets.fromLTRB(textBoxWidth * 0.075,
//                                   0, 0, textBoxHeight * 0.05),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '1번 트레이',
//                                         style: textFont2,
//                                       ),
//                                     ],
//                                   ),
//                                   if (_servingProvider.tray1 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.table1} 번',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                   if (_servingProvider.tray1 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.item1}',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             )),
//                         Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 color: Color.fromRGBO(45, 45, 45, 45),
//                                 borderRadius: BorderRadius.circular(40),
//                                 border: Border.fromBorderSide(BorderSide(
//                                     color: Color(0xFFB7B7B7),
//                                     style: BorderStyle.solid,
//                                     width: 1))),
//                             width: textBoxWidth,
//                             height: textBoxHeight,
//                             child: Padding(
//                               padding: EdgeInsets.fromLTRB(textBoxWidth * 0.075,
//                                   0, 0, textBoxHeight * 0.05),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '2번 트레이',
//                                         style: textFont2,
//                                       ),
//                                     ],
//                                   ),
//                                   if (_servingProvider.tray2 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.table2} 번',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                   if (_servingProvider.tray2 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.item2}',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             )),
//                         Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 color: Color.fromRGBO(45, 45, 45, 45),
//                                 borderRadius: BorderRadius.circular(40),
//                                 border: Border.fromBorderSide(BorderSide(
//                                     color: Color(0xFFB7B7B7),
//                                     style: BorderStyle.solid,
//                                     width: 1))),
//                             width: textBoxWidth,
//                             height: textBoxHeight,
//                             child: Padding(
//                               // padding: EdgeInsets.only(left: textBoxWidth*0.1),
//                               padding: EdgeInsets.fromLTRB(textBoxWidth * 0.075,
//                                   0, 0, textBoxHeight * 0.05),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '3번 트레이',
//                                         style: textFont2,
//                                       ),
//                                     ],
//                                   ),
//                                   if (_servingProvider.tray3 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.table3} 번',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '테이블 : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                   if (_servingProvider.tray3 == true)
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '${_servingProvider.item3}',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     )
//                                   else
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '상품(메뉴) : ',
//                                           style: subTextFont,
//                                         ),
//                                         Text(
//                                           '미지정',
//                                           style: subTextFont,
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                   margin: EdgeInsets.only(top: screenHeight * 0.66),
//                   width: screenWidth,
//                   height: screenHeight * 0.15,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ServingButtons(
//                         onPressed: () {
//                           if(_servingProvider.tray1 == true){
//                             tableDestinations.add(table1!);
//                             itemDestinations.add(item1!);
//                             trayDestinations.add('1');
//                             if(_servingProvider.tray2 == true){
//                               tableDestinations.add(table2!);
//                               itemDestinations.add(item2!);
//                               trayDestinations.add('2');
//                               if(_servingProvider.tray3 == true){
//                                 tableDestinations.add(table3!);
//                                 itemDestinations.add(item3!);
//                                 trayDestinations.add('3');
//                               }
//                             }else{
//                               if(_servingProvider.tray3 == true){
//                                 tableDestinations.add(table3!);
//                                 itemDestinations.add(item3!);
//                                 trayDestinations.add('3');
//                               }
//                             }
//                           }else{
//                             if(_servingProvider.tray2 == true){
//                               tableDestinations.add(table2!);
//                               itemDestinations.add(item2!);
//                               trayDestinations.add('2');
//                               if(_servingProvider.tray3 == true){
//                                 tableDestinations.add(table3!);
//                                 itemDestinations.add(item3!);
//                                 trayDestinations.add('3');
//                               }
//                             }else{
//                               if(_servingProvider.tray3 == true){
//                                 tableDestinations.add(table3!);
//                                 itemDestinations.add(item3!);
//                                 trayDestinations.add('3');
//                               }
//                             }
//                           }
//                           if(_servingProvider.trayCheckAll == true){
//                             tableDestinations.removeRange(1, 3);
//                             itemDestinations.removeRange(1, 3);
//                             trayDestinations.removeRange(1, 3);
//                           }
//                           _servingProvider.tableList = tableDestinations;
//                           _servingProvider.itemList = itemDestinations;
//                           _servingProvider.trayList = trayDestinations;
//                           print(_servingProvider.tableList);
//                           print(_servingProvider.itemList);
//                           print(_servingProvider.trayList);
//
//
//                           PostApi(
//                               url: startUrl,
//                               endadr: navUrl,
//                               keyBody:
//                               'serving_${tableDestinations[0].toString()}').Posting();
//                           _networkProvider.currentGoal = '${tableDestinations[0].toString()}번 테이블';
//
//                           navPage(context: context, page: NavigatorModule(), enablePop: true).navPageToPage();
//                         },
//                         buttonColor: Color.fromRGBO(45, 45, 45, 45),
//                         buttonFont: buttonFont,
//                         buttonWidth: buttonWidth,
//                         buttonHeight: buttonHeight,
//                         buttonText: '서빙 시작',
//                       )
//                     ],
//                   )),
//             ])));
//   }
// }
