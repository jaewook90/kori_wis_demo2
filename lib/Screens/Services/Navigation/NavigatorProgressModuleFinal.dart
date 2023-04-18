import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ShippingModules/shippingNavDoneFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/RoomService/RoomServiceProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingDoneFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NavigatorProgressModuleFinal extends StatefulWidget {
  NavigatorProgressModuleFinal({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorProgressModuleFinal> createState() =>
      _NavigatorProgressModuleFinalState();
}

class _NavigatorProgressModuleFinalState
    extends State<NavigatorProgressModuleFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late VideoPlayerController _controller;

  String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  bool? offStageAd;

  int? shipping;
  int? serving;
  int? bellboy;
  int? roomService;

  String? currentGoal;

  bool? pauseCheck;

  int? serviceState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pauseCheck = false;

    shipping = 0;
    serving = 1;
    bellboy = 2;
    roomService = 3;

    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(true);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    _playVideo();
  }

  void _playVideo() async {
    _controller.play();
  }

  late String backgroundImageServ;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    if (_networkProvider.serviceState == 0) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalShipProgNav.png";
    } else if (_networkProvider.serviceState == 1) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";
    } else if (_networkProvider.serviceState == 2) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalBellProgNav.png";
    } else if (_networkProvider.serviceState == 3) {
      backgroundImageServ = "assets/screens/Nav/koriZFinalRoomProgNav.png";
    }

    offStageAd = _servingProvider.playAd;

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;
    currentGoal = _networkProvider.currentGoal;

    serviceState = _networkProvider.serviceState;

    print(serviceState);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

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
                    left: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          if (_networkProvider.serviceState == 0) {
                            navPage(
                                context: context,
                                page: ShippingDoneFinal(),
                                enablePop: false)
                                .navPageToPage();
                            // showShippingDone(context);
                          } else if (_networkProvider.serviceState == 1) {
                            navPage(
                                context: context,
                                page: ServingProgressFinal(),
                                enablePop: false)
                                .navPageToPage();
                          } else if (_networkProvider.serviceState == 2) {
                            navPage(
                                context: context,
                                page: BellboyProgressFinal(),
                                enablePop: false)
                                .navPageToPage();
                          }else if (_networkProvider.serviceState == 3) {
                            navPage(
                                context: context,
                                page: RoomServiceProgressFinal(),
                                enablePop: false)
                                .navPageToPage();
                          }
                        },
                        child: Text(
                          '도착',
                          style: TextStyle(
                              fontFamily: 'kok',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff)),
                        ),
                        style: TextButton.styleFrom(
                          fixedSize: Size(100, 0),
                          backgroundColor: Colors.transparent,
                          // shape: RoundedRectangleBorder(
                          //     side: BorderSide(width: 1, color: Colors.white)
                          // )
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 150,
                    top: 15,
                    child: Container(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        onPressed: () {
                          setState(() {
                            _servingProvider.playAD();
                          });
                        },
                        icon: Icon(
                          Icons.play_circle,
                        ),
                        color: Color(0xffB7B7B7),
                        iconSize: 60,
                        alignment: Alignment.center,
                      ),
                    ),),

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
                  Center(
                    child: Text(
                      "시간",
                      style: TextStyle(fontFamily: 'kor', fontSize: 60),
                    ),
                  )
                ],
              ),
            )
            // SizedBox(width: screenWidth * 0.03)
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Container(
              child: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.04),
                      child: null),
                  NavModuleButtonsFinal(
                    screens: 0,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            // 스크린 터치시 화면 이동을 위한 위젯
            onTap: () {
              setState(() {
                _servingProvider.playAD();
              });
            },
            child: Center(
              child: Offstage(
                offstage: offStageAd!,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.8,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: videoWidth,
                                height: videoHeight,
                                child: _controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(
                                          _controller,
                                        ),
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

// 기능 버튼 ( 기존 )
//Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               TextButton(
//                                   onPressed: () {
//                                     PostApi(
//                                             url: startUrl,
//                                             endadr: rsmUrl,
//                                             keyBody: 'stop')
//                                         .Posting();
//                                     setState(() {
//                                       pauseCheck = false;
//                                     });
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "계속 이동",
//                                         style: buttonFont2,
//                                       ),
//                                     ],
//                                   ),
//                                   style: TextButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                       fixedSize: Size(
//                                           textButtonWidth, textButtonHeight),
//                                       shape: RoundedRectangleBorder(
//                                           // side: BorderSide(
//                                           //     color: Color(0xFFB7B7B7),
//                                           //     style: BorderStyle.solid,
//                                           //     width: 1),
//                                           borderRadius:
//                                               BorderRadius.circular(40)))),
//                               SizedBox(
//                                 height: textButtonHeight * 0.1,
//                               ),
//                               if (currentGoal != "충전스테이션")
//                                 Column(
//                                   children: [
//                                     TextButton(
//                                         onPressed: () {
//                                           PostApi(
//                                                   url: startUrl,
//                                                   endadr: chgUrl,
//                                                   keyBody: 'charging_pile')
//                                               .Posting();
//                                           _networkProvider.currentGoal =
//                                               '충전스테이션';
//                                           setState(() {
//                                             pauseCheck = false;
//                                           });
//                                         },
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "충전",
//                                               style: buttonFont2,
//                                             ),
//                                           ],
//                                         ),
//                                         style: TextButton.styleFrom(
//                                             backgroundColor:
//                                                 Color.fromRGBO(45, 45, 45, 45),
//                                             fixedSize: Size(textButtonWidth,
//                                                 textButtonHeight),
//                                             shape: RoundedRectangleBorder(
//                                                 // side: BorderSide(
//                                                 //     color: Color(0xFFB7B7B7),
//                                                 //     style: BorderStyle.solid,
//                                                 //     width: 1),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         40)))),
//                                     SizedBox(
//                                       height: textButtonHeight * 0.1,
//                                     ),
//                                   ],
//                                 ),
//                               TextButton(
//                                   onPressed: () {
//                                     // Posting(startUrl, navUrl, 대기장소이름);
//                                     setState(() {
//                                       pauseCheck = false;
//                                     });
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "대기장소로 이동",
//                                         style: buttonFont2,
//                                       ),
//                                     ],
//                                   ),
//                                   style: TextButton.styleFrom(
//                                       backgroundColor:
//                                           Color.fromRGBO(45, 45, 45, 45),
//                                       fixedSize: Size(
//                                           textButtonWidth, textButtonHeight),
//                                       shape: RoundedRectangleBorder(
//                                           // side: BorderSide(
//                                           //     color: Color(0xFFB7B7B7),
//                                           //     style: BorderStyle.solid,
//                                           //     width: 1),
//                                           borderRadius:
//                                               BorderRadius.circular(40)))),
//                               SizedBox(
//                                 height: textButtonHeight * 0.1,
//                               ),
//                               if (serviceState == shipping)
//                                 TextButton(
//                                     onPressed: () {
//                                       if (serviceState == shipping) {
//                                         navPage(
//                                                 context: context,
//                                                 page: ShippingDestination(),
//                                                 enablePop: false)
//                                             .navPageToPage();
//                                       }
//                                     },
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "목적지 변경",
//                                           style: buttonFont2,
//                                         ),
//                                       ],
//                                     ),
//                                     style: TextButton.styleFrom(
//                                         backgroundColor:
//                                             Color.fromRGBO(45, 45, 45, 45),
//                                         fixedSize: Size(
//                                             textButtonWidth, textButtonHeight),
//                                         shape: RoundedRectangleBorder(
//                                             // side: BorderSide(
//                                             //     color: Color(0xFFB7B7B7),
//                                             //     style: BorderStyle.solid,
//                                             //     width: 1),
//                                             borderRadius:
//                                                 BorderRadius.circular(40)))),
//                             ],
//                           )

// 디버그용 도착 버튼
//IconButton(
//                                     onPressed: () {
//                                       if (serviceState == shipping) {
//                                         if (_networkProvider.shippingDone ==
//                                             true) {
//                                           navPage(
//                                                   context: context,
//                                                   page: ShippingMenu(),
//                                                   enablePop: false)
//                                               .navPageToPage();
//                                           _networkProvider.shippingDone = false;
//                                         } else {
//                                           navPage(
//                                                   context: context,
//                                                   page: ShippingDone(),
//                                                   enablePop: false)
//                                               .navPageToPage();
//                                         }
//                                       } else if (serviceState == serving) {
//                                         if (_networkProvider.servingDone ==
//                                             true) {
//                                           _servingProvider.clearAllTray();
//                                           _networkProvider.servingDone = false;
//                                           navPage(
//                                                   context: context,
//                                                   page: TraySelection3(),
//                                                   enablePop: false)
//                                               .navPageToPage();
//                                         } else {
//                                           navPage(
//                                                   context: context,
//                                                   page: ServingProgress3(),
//                                                   enablePop: false)
//                                               .navPageToPage();
//                                         }
//                                       }
//                                     },
//                                     iconSize: screenWidth * 0.1,
//                                     color: Color(0xffF0F0F0),
//                                     icon: Icon(
//                                         Icons.pause_circle_outline_outlined),
//                                   ),
