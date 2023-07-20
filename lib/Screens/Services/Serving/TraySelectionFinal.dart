import 'dart:async';
import 'dart:convert' show utf8;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/menuBookModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/ConfigScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDish.dart';
import 'package:kori_wis_demo/Utills/ble/KoriViewModel.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_list.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

part 'TraySelectionFinal.g.dart';

//ignore_for_file: annotate_overrides
// 트레이 반응형 UI

// // BLE 모듈 사용 시 필요한 상위 위젯
// class TrayEquipped extends StatelessWidget {
//   const TrayEquipped({
//     this.characteristic,
//     Key? key,
//   }) : super(key: key);
//   final QualifiedCharacteristic? characteristic;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer3<BleDeviceInteractor, BleDeviceConnector,
//             ConnectionStateUpdate>(
//         builder: (_, interactor, deviceConnector, connectionStateUpdate, __) =>
//             TraySelectionFinal(
//               characteristic: characteristic,
//               subscribeToCharacteristic: interactor.subScribeToCharacteristic,
//               viewModel: TrayEquippedViewModel(
//                   deviceId: characteristic!.deviceId,
//                   connectionStatus: connectionStateUpdate.connectionState,
//                   deviceConnector: deviceConnector,
//                   discoverServices: () =>
//                       interactor.discoverServices(characteristic!.deviceId)),
//             ));
//   }
// }
//

// // BLE 모듈 사용
// class TraySelectionFinal extends StatefulWidget {
//   const TraySelectionFinal(
//       {this.characteristic,
//       this.subscribeToCharacteristic,
//       this.viewModel,
//       Key? key})
//       : super(key: key);
//
//   final QualifiedCharacteristic? characteristic;
//
//   final Stream<List<int>> Function(QualifiedCharacteristic characteristic)?
//       subscribeToCharacteristic;
//
//   final TrayEquippedViewModel? viewModel;
//
//   @override
//   State<TraySelectionFinal> createState() => _TraySelectionFinalState();
// }

// BLE 모듈 미사용
class TraySelectionFinal extends StatefulWidget {
  const TraySelectionFinal(
      {Key? key})
      : super(key: key);

  @override
  State<TraySelectionFinal> createState() => _TraySelectionFinalState();
}

class _TraySelectionFinalState extends State<TraySelectionFinal>
    with TickerProviderStateMixin {
  late ServingModel _servingProvider;
  // late BLEModel _bleProvider;
  late NetworkModel _networkProvider;

  final TextEditingController configController = TextEditingController();

  // FirebaseFirestore robotDb = FirebaseFirestore.instance;

  // late bool bleConnection;

  // late Timer _timer;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> PositioningList;
  late List<String> PositionList;

  // ble 데이터 변수
  // late String subscribeOutput;
  // late StreamSubscription<List<int>>? subscribeStream;

  late String targetTableNum;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  // 배경 화면
  late String backgroundImage;
  late String resetIcon;

  // 트레이 하이드 앤 쇼
  bool? offStageTray1;
  bool? offStageTray2;
  bool? offStageTray3;

  // 음식 하이드 앤 쇼
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;

  //트레이별 선택 테이블 넘버
  String? table1;
  String? table2;
  String? table3;

  // //트레이 BLE시그널
  // // late bool trayDetecting;
  // late String tray1BLE;
  // late String tray2BLE;
  // late String tray3BLE;

  //디버그
  late bool _debugTray;
  late int _debugEncounter;

  late int serviceState;

  DateTime? currentBackPressTime;

  FToast? fToast;

  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _debugEncounter = 0;
    _debugTray = true;

    fToast = FToast();
    fToast?.init(context);

    PositioningList = [];
    PositionList = [];

    serviceState = 0;

    backgroundImage = "assets/screens/Serving/koriZFinalServing.png";

    table1 = "";
    table2 = "";
    table3 = "";

    // // BLE 사용시 이용
    // bleConnection = false;

    // tray1BLE = "";
    // tray2BLE = "";
    // tray3BLE = "";
    //
    // subscribeOutput = 'init';

    // Provider.of<BLEModel>(context, listen: false).onTraySelectionScreen = true;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    // // BLE 사용시 사용
    // if (widget.characteristic == null) {
    //   subscribeStream = null;
    // }

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    // print('apiAddress : $apiAddress');

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {
      PositionList = [];
      poseDataUpdate();
    });
  }

  void poseDataUpdate() {
    newPoseData = Provider.of<NetworkModel>(context, listen: false).getApiData;
    if (newPoseData != null) {
      poseData = newPoseData;
      String editPoseData = poseData.toString();

      editPoseData = editPoseData.replaceAll('{', "");
      editPoseData = editPoseData.replaceAll('}', "");
      List<String> PositionWithCordList = editPoseData.split("], ");

      for (int i = 0; i < PositionWithCordList.length; i++) {
        PositioningList = PositionWithCordList[i].split(":");
        for (int j = 0; j < PositioningList.length; j++) {
          if (j == 0) {
            if (!PositioningList[j].contains('[')) {
              poseData = PositioningList[j];
              PositionList.add(poseData);
            }
          }
        }
      }
      PositionList.sort();
    } else {
      PositionList = [];
    }
  }

  // // 트레이 디텍팅 (BLE 사용)
  // Future<void> subscribeCharacteristic() async {
  //   _timer = Timer(Duration(milliseconds: 500), () {
  //     subscribeStream = widget.subscribeToCharacteristic!
  //             (widget.characteristic!)
  //         .listen((event) {
  //       if (mounted) {
  //         setState(() {
  //           subscribeOutput = utf8.decode(event);
  //           tray1BLE = subscribeOutput.split('')[0];
  //           tray2BLE = subscribeOutput.split('')[1];
  //           tray3BLE = subscribeOutput.split('')[2];
  //           if (subscribeOutput != 'Notification set') {
  //             subscribeStream!.cancel();
  //           }
  //           _timer.cancel();
  //         });
  //       }
  //     });
  //     if (mounted) {
  //       setState(() {
  //         subscribeOutput = 'Notification set';
  //         _timer.cancel();
  //       });
  //     }
  //   });
  //   await Future.delayed(Duration(milliseconds: 1));
  // }

  void showTraySetPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectItemModalFinal();
        });
  }

  void showReturnSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ReturnDishTableModal();
        });
  }

  @override
  void dispose() {
    super.dispose();
    // BLE 이용시 디스포즈
    // subscribeStream!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // _bleProvider = Provider.of<BLEModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    // _debugTray = _servingProvider.trayDebug!;

    // print(PositionList);

    //0: 일반 1: 퇴식 2: 광고 재생 3: 서빙 복귀
    serviceState =
        Provider.of<ServingModel>(context, listen: false).servingState!;

    if (PositionList.isEmpty) {
      // print('11111111');
      PositionList = _networkProvider.getPoseData!;
    } else {
      // print('2222222222');
      _networkProvider.getPoseData = PositionList;
    }

    // // BLE 사용시 데이터 리드
    // if (mounted) {
    //   if (_bleProvider.onTraySelectionScreen == true) {
    //     subscribeCharacteristic();
    //   }
    // } else {
    //   subscribeStream!.cancel();
    // }

    // BLE 트레이 장착 유무 판독
    // if (tray1BLE == "1") {
    //   _servingProvider.attachedTray1 = false;
    // } else if (tray1BLE == "0") {
    //   _servingProvider.attachedTray1 = true;
    //   if (table1 != "") {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _servingProvider.clearTray1();
    //     });
    //   }
    // }
    // if (tray2BLE == "1") {
    //   _servingProvider.attachedTray2 = false;
    // } else if (tray2BLE == "0") {
    //   _servingProvider.attachedTray2 = true;
    //   if (table2 != "") {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _servingProvider.clearTray2();
    //     });
    //     // print('t2');
    //   }
    // }
    // if (tray3BLE == "1") {
    //   _servingProvider.attachedTray3 = false;
    // } else if (tray3BLE == "0") {
    //   _servingProvider.attachedTray3 = true;
    //   if (table3 != "") {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _servingProvider.clearTray3();
    //     });
    //     // print('t3');
    //   }
    // }

    offStageTray1 = _servingProvider.attachedTray1;
    offStageTray2 = _servingProvider.attachedTray2;
    offStageTray3 = _servingProvider.attachedTray3;

    servedItem1 = _servingProvider.servedItem1;
    servedItem2 = _servingProvider.servedItem2;
    servedItem3 = _servingProvider.servedItem3;

    table1 = _servingProvider.table1;
    table2 = _servingProvider.table2;
    table3 = _servingProvider.table3;

    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = 1080;
    double screenHeight = 1920;
    double textButtonWidth = screenWidth * 0.6;
    double textButtonHeight = screenHeight * 0.08;

    TextStyle? buttonFont = Theme.of(context).textTheme.headlineMedium;

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(milliseconds: 1300)) {
          currentBackPressTime = now;
          fToast?.showToast(
              toastDuration: const Duration(milliseconds: 1300),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageIcon(
                          AssetImage('assets/icons/ExaIcon.png'),
                          size: 35,
                          color: Color(0xffB7B7B7),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          _text,
                          style: TextStyle(fontFamily: 'kor', fontSize: 35),
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    )
                  ],
                ),
              ),
              gravity: ToastGravity.BOTTOM);
          return Future.value(false);
        }

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  Positioned(
                    right: 150,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        showReturnSelectPopup(context);
                      },
                      child: Icon(Icons.shopping_cart_checkout, size: 50),
                      style: FilledButton.styleFrom(
                          fixedSize: Size(60, 60),
                          padding: EdgeInsets.only(right: 0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                    ),
                  ),
                  Positioned(
                      left: 50,
                      top: 25,
                      child: FilledButton(
                        onPressed: () {
                          navPage(context: context, page: MenuBookScreen(), enablePop: true).navPageToPage();
                        },
                        child: Icon(Icons.menu_book, size: 50),
                        style: FilledButton.styleFrom(
                            fixedSize: Size(60, 60),
                            padding: EdgeInsets.only(right: 0),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                      )),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
          iconTheme: IconThemeData(size: 70, color: Color(0xfffefeff)),
        ),
        extendBodyBehindAppBar: true,
        drawerEdgeDragWidth: 70,
        endDrawerEnableOpenDragGesture: true,
        endDrawer: Drawer(
          backgroundColor: Color(0xff292929),
          shadowColor: Color(0xff191919),
          width: 400,
          child: Container(
            padding: EdgeInsets.only(top: 100, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 370,
                      height: 1820,
                      child: Stack(children: [
                        Column(
                          children: [
                            //ip 변경
                            ExpansionTile(
                                title: Row(
                                  children: [
                                    Icon(Icons.track_changes,
                                        color: Colors.white, size: 50),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        'ip 변경',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                initiallyExpanded: false,
                                backgroundColor: Colors.transparent,
                                children: <Widget>[
                                  Divider(
                                      height: 20,
                                      color: Colors.grey,
                                      indent: 15),
                                  Container(
                                    // height: 1820,
                                    width: 370,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, bottom: 30),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '기존 IP',
                                                style: TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                startUrl!,
                                                style: TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '변경 할 IP',
                                                style: TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 150,
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  final String newStartUrl =
                                                      configController.text;
                                                  // IP 변경 정보 데이터 베이스에 업데이트
                                                  // final data = {
                                                  //   "RobotIp": newStartUrl
                                                  // };
                                                  // robotDb
                                                  //     .collection("servingBot1")
                                                  //     .doc("robotState")
                                                  //     .set(
                                                  //         data,
                                                  //         SetOptions(
                                                  //             merge: true));
                                                  setState(() {
                                                    _networkProvider.startUrl =
                                                        "http://${configController.text}/";
                                                    startUrl = _networkProvider
                                                        .startUrl;
                                                    configController.text = '';
                                                  });
                                                  getting(
                                                      _networkProvider
                                                          .startUrl!,
                                                      _networkProvider
                                                          .positionURL);
                                                  setState(() {
                                                    // PositionList = [];
                                                    // poseDataUpdate();
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                                style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            80, 80, 255, 0.7),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          TextField(
                                            onTap: () {
                                              setState(() {
                                                configController.text = '';
                                              });
                                            },
                                            controller: configController,
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 18,
                                                color: Colors.white),
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            //골포지션 새로고침
                            Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: FilledButton(
                                  onPressed: () {
                                    getting(_networkProvider.startUrl!,
                                        _networkProvider.positionURL);
                                    setState(() {});
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(370, 58),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.sync,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          'GoalPose 새로고침',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: FilledButton(
                                  onPressed: () {
                                    _networkProvider.servTable = 'charging_pile';
                                    PostApi(
                                        url: startUrl,
                                        endadr: chgUrl,
                                        keyBody: 'charging_pile')
                                        .Posting(context);
                                    _networkProvider.currentGoal = '충전스테이션';
                                    navPage(
                                        context: context,
                                        page: const NavigatorProgressModuleFinal(),
                                        enablePop: false)
                                        .navPageToPage();
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(370, 58),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(0))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.ev_station_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 15),
                                        child: Text(
                                          '충전 스테이션 이동',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // //블루투스 변경
                            // Offstage(
                            //   offstage: _debugTray,
                            //   child: Padding(
                            //       padding: const EdgeInsets.only(left: 0),
                            //       child: FilledButton(
                            //         onPressed: () {
                            //           navPage(
                            //                   context: context,
                            //                   page: const DeviceListScreen(),
                            //                   enablePop: true)
                            //               .navPageToPage();
                            //         },
                            //         style: FilledButton.styleFrom(
                            //             backgroundColor: Colors.transparent,
                            //             fixedSize: Size(370, 58),
                            //             shape: RoundedRectangleBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(0))),
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.bluetooth,
                            //                 color: Colors.white, size: 50),
                            //             Padding(
                            //               padding:
                            //                   const EdgeInsets.only(left: 15),
                            //               child: Text(
                            //                 'microBit ID 변경',
                            //                 textAlign: TextAlign.start,
                            //                 style: TextStyle(
                            //                     fontFamily: 'kor',
                            //                     fontSize: 24,
                            //                     fontWeight: FontWeight.bold,
                            //                     height: 1,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )),
                            // ),
                            Offstage(
                              offstage: _debugTray,
                              child: SizedBox(
                                height: 20,
                              ),
                            ),
                            //위치 추가 및 변경
                            Offstage(
                              offstage: _debugTray,
                              child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.add_circle_outline_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          '위치 추가',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: false,
                                  backgroundColor: Colors.transparent,
                                  children: <Widget>[
                                    Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    Container(
                                      height: 100,
                                      width: 370,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '포지션 추가',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: SizedBox(
                                height: 20,
                              ),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.remove_circle_outline_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          '위치 삭제',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: false,
                                  backgroundColor: Colors.transparent,
                                  children: <Widget>[
                                    Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    Container(
                                      height: 100,
                                      width: 370,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '포지션 제거',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        //투명 디버그 모드 온/오프 스위치
                        Positioned(
                            top: 1620,
                            child: FilledButton(
                              onPressed: () {
                                DateTime now = DateTime.now();
                                if (currentBackPressTime == null ||
                                    now.difference(currentBackPressTime!) >
                                        const Duration(milliseconds: 100)) {
                                  currentBackPressTime = now;
                                  if (now.difference(currentBackPressTime!) >
                                      const Duration(milliseconds: 1300)) {
                                    _debugEncounter = 0;
                                  } else {
                                    setState(() {
                                      _debugEncounter++;
                                      // print(_debugEncounter);
                                    });
                                    if (_debugEncounter == 5 &&
                                        _debugTray == true) {
                                      _debugTray = false;
                                      // print(_debugTray);
                                      _debugEncounter = 0;
                                      // setState(() {
                                      //   _debugTray = false;
                                      //   print(_debugTray);
                                      //   _debugEncounter = 0;
                                      // });
                                    } else if (_debugEncounter == 3 &&
                                        _debugTray == false) {
                                      _debugTray = true;
                                      // print(_debugTray);
                                      _debugEncounter = 0;
                                      // setState(() {
                                      // });
                                    }
                                  }
                                  // currentBackPressTime = now;
                                }
                              },
                              style: FilledButton.styleFrom(
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  fixedSize: Size(400, 150)),
                              child: null,
                            ))
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(milliseconds: 1300)) {
              currentBackPressTime = now;
              fToast?.showToast(
                  toastDuration: const Duration(milliseconds: 1300),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ImageIcon(
                              AssetImage('assets/icons/ExaIcon.png'),
                              size: 35,
                              color: Color(0xffB7B7B7),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              _text,
                              style: TextStyle(fontFamily: 'kor', fontSize: 35),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        )
                      ],
                    ),
                  ),
                  gravity: ToastGravity.BOTTOM);
              return Future.value(false);
            }
            return Future.value(false);
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                //기능적 부분
                Stack(children: [
                  // 상단 2버튼
                  const ServingModuleButtonsFinal(
                    screens: 0,
                  ),
                  // 디버그 버튼
                  Offstage(
                    offstage: _debugTray,
                    child: Opacity(
                      opacity: 0.02,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 디버그 버튼 트레이 활성화용
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (_servingProvider.attachedTray1 ==
                                        true) {
                                      setState(() {
                                        _servingProvider.stickTray1();
                                      });
                                    } else {
                                      setState(() {
                                        _servingProvider.dittachedTray1();
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray1', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    if (_servingProvider.attachedTray2 ==
                                        true) {
                                      setState(() {
                                        _servingProvider.stickTray2();
                                      });
                                    } else {
                                      setState(() {
                                        _servingProvider.dittachedTray2();
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray2', style: buttonFont)),
                              TextButton(
                                  onPressed: () {
                                    if (_servingProvider.attachedTray3 ==
                                        true) {
                                      setState(() {
                                        _servingProvider.stickTray3();
                                      });
                                    } else {
                                      setState(() {
                                        _servingProvider.dittachedTray3();
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: Size(textButtonWidth * 0.2,
                                          textButtonHeight * 0.5),
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFB7B7B7),
                                              style: BorderStyle.solid,
                                              width: 10))),
                                  child: Text('Tray3', style: buttonFont)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 초기화 버튼
                  Positioned(
                      right: 188,
                      top: 812,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray1();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 188,
                      top: 1030,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray2();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  Positioned(
                      right: 188,
                      top: 1296,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.clearTray3();
                          });
                        },
                        child: null,
                        style: FilledButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            fixedSize: const Size(64, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: Colors.transparent),
                      )),
                  //트레이1
                  Positioned(
                    top: 757,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray1!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              width: 50,
                              height: 30,
                              child: Offstage(
                                  offstage: servedItem1!,
                                  child: Center(
                                    child: Text(
                                      '$table1 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 25.9,
                            child: Offstage(
                              offstage: servedItem1!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          _servingProvider.itemImageList![0]),
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 388.5,
                            height: 171.8,
                            child: TextButton(
                                onPressed: () {
                                  // _bleProvider.onTraySelectionScreen = false;
                                  _servingProvider.tray1Select = true;
                                  _servingProvider.tray2Select = false;
                                  _servingProvider.tray3Select = false;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //트레이2
                  Positioned(
                    top: 975.8,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray2!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 120,
                            child: Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Offstage(
                                  offstage: servedItem2!,
                                  child: Center(
                                    child: Text(
                                      '$table2 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 25.9,
                            child: Offstage(
                              offstage: servedItem2!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(_servingProvider
                                            .itemImageList![1])),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 388.5,
                            height: 171.8,
                            child: TextButton(
                                onPressed: () {
                                  // _bleProvider.onTraySelectionScreen = false;
                                  _servingProvider.tray1Select = false;
                                  _servingProvider.tray2Select = true;
                                  _servingProvider.tray3Select = false;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //트레이3
                  Positioned(
                    top: 1217.6,
                    left: 394,
                    child: Offstage(
                      offstage: offStageTray3!,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 145,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              width: 50,
                              height: 30,
                              child: Offstage(
                                  offstage: servedItem3!,
                                  child: Center(
                                    child: Text(
                                      '$table3 번',
                                      style: buttonFont,
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            left: 145.5,
                            top: 51,
                            child: Offstage(
                              offstage: servedItem3!,
                              child: Container(
                                  width: 146,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(_servingProvider
                                            .itemImageList![2])),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 518 * 0.75,
                            height: 293 * 0.75,
                            child: TextButton(
                                onPressed: () {
                                  // _bleProvider.onTraySelectionScreen = false;
                                  _servingProvider.tray1Select = false;
                                  _servingProvider.tray2Select = false;
                                  _servingProvider.tray3Select = true;
                                  _servingProvider.trayCheckAll = false;
                                  showTraySetPopup(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    backgroundColor: Colors.transparent,
                                    fixedSize:
                                        Size(textButtonWidth, textButtonHeight),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green, width: 10),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
