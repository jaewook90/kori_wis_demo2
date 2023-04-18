import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/RoomServiceModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceReturn.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';


class RoomServiceProgressFinal extends StatefulWidget {
  const RoomServiceProgressFinal({Key? key}) : super(key: key);

  @override
  State<RoomServiceProgressFinal> createState() => _RoomServiceProgressFinalState();
}

class _RoomServiceProgressFinalState extends State<RoomServiceProgressFinal> {

  late ServingModel _servingProvider;
  late RoomServiceModel _roomServiceProvider;

  String backgroundImage = "assets/screens/Hotel/RoomService/koriZFinalRoomDone.png";



  @override
  Widget build(BuildContext context) {
    _roomServiceProvider =
        Provider.of<RoomServiceModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.35;
    double buttonHeight = screenHeight * 0.12;

    TextStyle? textFont1 = Theme.of(context).textTheme.displayMedium;
    TextStyle? buttonFont = Theme.of(context).textTheme.displaySmall;

    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            // leading:
            actions: [
              Container(
                width: screenWidth,
                height: 108,
                child: Stack(
                  children: [
                    Positioned(
                      left: 130,
                      top: 25,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Home.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Positioned(
                      left: 120,
                      top: 18,
                      child: FilledButton(onPressed: () {
                        navPage(context: context, page: MainScreenFinal(), enablePop: false).navPageToPage();
                      }, child: null, style: FilledButton.styleFrom(
                          fixedSize: Size(80, 80),
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0)
                          ),
                          backgroundColor: Colors.transparent
                      ),),
                    ),
                    Positioned(
                      right: 50,
                      top: 25,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Battery.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                   ],
                ),
              )
              // SizedBox(width: screenWidth * 0.03)
            ],
            toolbarHeight: 110,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage), fit: BoxFit.cover)),
              child: Stack(children: [
                Positioned(
                  top: 420,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        _roomServiceProvider.clearAllTray();
                        navPage(
                            context: context,
                            page: RoomServiceReturnModuleFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      child: Container(
                          height: 1200,
                          width: 1080,
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.transparent, width: 1))))),
                ),
                Container(
                  child: RoomServiceModuleButtonsFinal(screens: 4),
                ),
              ]))),
    );
  }
}









// 도착완료 시나리오 ( 모든 선반 / 개별 선반 )
//if(_servingProvider.trayCheckAll == true)
//                           Column(
//                           children: [
//                             Text('주문 하신 $itemName 나왔습니다.', style: textFont1),
//                             SizedBox(
//                               height: screenHeight * 0.05,
//                             ),
//                             Text('선반에서 상품을 수령 하신 후', style: textFont1),
//                             Text('완료 버튼을 눌러주세요.', style: textFont1),
//                             SizedBox(
//                               height: screenHeight * 0.04,
//                             ),
//                           ],
//                         )
//                         else
//                           Column(
//                             children: [
//                               Text('주문 하신 $itemName 나왔습니다.', style: textFont1),
//                               SizedBox(
//                                 height: screenHeight * 0.05,
//                               ),
//                               Text('$trayName번 선반에서', style: textFont1),
//                               Text('상품을 수령 하신 후', style: textFont1),
//                               Text('완료 버튼을 눌러주세요.', style: textFont1),
//                               SizedBox(
//                                 height: screenHeight * 0.04,
//                               ),
//                             ],
//                           ),




// 완료 버튼
// Positioned(
//                 left: screenWidth * 0.325,
//                 top: screenHeight * 0.55,
//                 child: ServingButtons(
//                   onPressed: () {
//
//                     _servingProvider.playAd = false;
//
//                     if (tableDestinations.length > 1) {
//                       itemDestinations.removeAt(0);
//                       tableDestinations.removeAt(0);
//                       trayDestinations.removeAt(0);
//                     } else {
//                       tableDestinations.clear();
//                       itemDestinations.clear();
//                       trayDestinations.clear();
//                     }
//                     _servingProvider.itemList = itemDestinations;
//                     _servingProvider.tableList = tableDestinations;
//                     _servingProvider.trayList = trayDestinations;
//                     print(_servingProvider.itemList);
//                     print(_servingProvider.tableList);
//                     print(_servingProvider.trayList);
//
//                     if (_servingProvider.tableList!.length == 0) {
//                       PostApi(
//                               url: startUrl,
//                               endadr: chgUrl,
//                               keyBody: 'charging_pile')
//                           .Posting();
//                       _networkProvider.currentGoal = '충전스테이션';
//                       _networkProvider.servingDone = true;
//                       navPage(
//                               context: context,
//                               page: NavigatorModule(),
//                               enablePop: true)
//                           .navPageToPage();
//                       _servingProvider.initServing();
//                     } else {
//                       PostApi(
//                               url: startUrl,
//                               endadr: navUrl,
//                               keyBody:
//                                   'serving_${tableDestinations[0].toString()}')
//                           .Posting();
//                       _networkProvider.currentGoal =
//                           '${tableDestinations[0].toString()}번 테이블';
//
//                       navPage(
//                               context: context,
//                               page: NavigatorModule(),
//                               enablePop: true)
//                           .navPageToPage();
//                     }
//                   },
//                   buttonWidth: buttonWidth,
//                   buttonHeight: buttonHeight,
//                   buttonText: '완료',
//                   buttonFont: buttonFont,
//                   buttonColor: Color.fromRGBO(45, 45, 45, 45),
//                   screenWidth: screenWidth,
//                   screenHeight: screenHeight,
//                 ),
//               )