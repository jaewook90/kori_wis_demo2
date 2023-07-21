import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/testPages.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview2.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview3.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TraySelectionFinal extends StatefulWidget {
  const TraySelectionFinal({Key? key}) : super(key: key);

  @override
  State<TraySelectionFinal> createState() => _TraySelectionFinalState();
}

class _TraySelectionFinalState extends State<TraySelectionFinal>
    with TickerProviderStateMixin {
  late ServingModel _servingProvider;

  late NetworkModel _networkProvider;

  final TextEditingController configController = TextEditingController();
  late SharedPreferences _prefs;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> positioningList;
  late List<String> positionList;

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

    _initSharedPreferences();

    _debugEncounter = 0;
    _debugTray = true;

    fToast = FToast();
    fToast?.init(context);

    positioningList = [];
    positionList = [];

    serviceState = 0;

    backgroundImage = "assets/screens/Serving/koriZFinalServing.png";

    table1 = "";
    table2 = "";
    table3 = "";

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {
      positionList = [];
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
      List<String> positionWithCordList = editPoseData.split("], ");

      for (int i = 0; i < positionWithCordList.length; i++) {
        positioningList = positionWithCordList[i].split(":");
        for (int j = 0; j < positioningList.length; j++) {
          if (j == 0) {
            if (!positioningList[j].contains('[')) {
              poseData = positioningList[j];
              positionList.add(poseData);
            }
          }
        }
      }
      positionList.sort();
    } else {
      positionList = [];
    }
  }

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
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    //0: 일반 1: 퇴식 2: 광고 재생 3: 서빙 복귀
    serviceState =
        Provider.of<ServingModel>(context, listen: false).servingState!;

    if (positionList.isEmpty) {
      positionList = _networkProvider.getPoseData!;
    } else {
      _networkProvider.getPoseData = positionList;
    }

    offStageTray1 = _servingProvider.attachedTray1;
    offStageTray2 = _servingProvider.attachedTray2;
    offStageTray3 = _servingProvider.attachedTray3;

    servedItem1 = _servingProvider.servedItem1;
    servedItem2 = _servingProvider.servedItem2;
    servedItem3 = _servingProvider.servedItem3;

    table1 = _servingProvider.table1;
    table2 = _servingProvider.table2;
    table3 = _servingProvider.table3;

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
                          style:
                              const TextStyle(fontFamily: 'kor', fontSize: 35),
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
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(60, 60),
                          padding: const EdgeInsets.only(right: 0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      child: const Icon(Icons.shopping_cart_checkout, size: 50),
                    ),
                  ),
                  Positioned(
                      left: 20,
                      top: 25,
                      child: TextButton(
                        onPressed: () {
                          navPage(
                                  context: context,
                                  page: const WebviewPage1(),
                                  enablePop: true)
                              .navPageToPage();
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            padding: const EdgeInsets.only(right: 0, bottom: 2),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(0))),
                        child: const Text(
                          '1',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 40,
                              color: Colors.white),
                        ),
                      )),
                  Positioned(
                      left: 100,
                      top: 25,
                      child: TextButton(
                        onPressed: () {
                          navPage(
                                  context: context,
                                  page: const WebviewPage2(),
                                  enablePop: true)
                              .navPageToPage();
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            padding: const EdgeInsets.only(right: 0, bottom: 2),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(0))),
                        child: const Text(
                          '2',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 40,
                              color: Colors.white),
                        ),
                      )),
                  Positioned(
                      left: 180,
                      top: 25,
                      child: TextButton(
                        onPressed: () {
                          navPage(
                                  context: context,
                                  page: const WebviewPage3(),
                                  enablePop: true)
                              .navPageToPage();
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            padding: const EdgeInsets.only(right: 0, bottom: 2),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(0))),
                        child: const Text(
                          '3',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 40,
                              color: Colors.white),
                        ),
                      )),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
          iconTheme: const IconThemeData(size: 70, color: Color(0xfffefeff)),
        ),
        extendBodyBehindAppBar: true,
        drawerEdgeDragWidth: 70,
        endDrawerEnableOpenDragGesture: true,
        endDrawer: Drawer(
          backgroundColor: const Color(0xff292929),
          shadowColor: const Color(0xff191919),
          width: 400,
          child: Container(
            padding: const EdgeInsets.only(top: 100, left: 15),
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
                                title: const Row(
                                  children: [
                                    Icon(Icons.track_changes,
                                        color: Colors.white, size: 50),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
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
                                  const Divider(
                                      height: 20,
                                      color: Colors.grey,
                                      indent: 15),
                                  Container(
                                    width: 370,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, bottom: 30),
                                      child: Column(
                                        children: [
                                          const Row(
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
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                startUrl!,
                                                style: const TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '변경 할 IP',
                                                style: TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 150,
                                              ),
                                              FilledButton(
                                                onPressed: () async {
                                                  _prefs.setString('robotIp',
                                                      configController.text);
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
                                                },
                                                style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            80, 80, 255, 0.7),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    )),
                                                child: const Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
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
                                            style: const TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 18,
                                                color: Colors.white),
                                            keyboardType: const TextInputType
                                                .numberWithOptions(),
                                            decoration: const InputDecoration(
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
                            const SizedBox(
                              height: 20,
                            ),
                            //골포지션 새로고침
                            Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: FilledButton(
                                  onPressed: () {
                                    getting(_networkProvider.startUrl!,
                                        _networkProvider.positionURL);
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(370, 58),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.sync,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
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
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: FilledButton(
                                  onPressed: () {
                                    _networkProvider.servTable =
                                        'charging_pile';
                                    PostApi(
                                            url: startUrl,
                                            endadr: chgUrl,
                                            keyBody: 'charging_pile')
                                        .Posting(context);
                                    _networkProvider.currentGoal = '충전스테이션';
                                    navPage(
                                            context: context,
                                            page:
                                                const NavigatorProgressModuleFinal(),
                                            enablePop: false)
                                        .navPageToPage();
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(370, 58),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.ev_station_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
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
                            Offstage(
                              offstage: _debugTray,
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            //위치 추가 및 변경
                            Offstage(
                              offstage: _debugTray,
                              child: ExpansionTile(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.add_circle_outline_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
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
                                    const Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    Container(
                                      height: 100,
                                      width: 370,
                                      child: const Padding(
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
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: ExpansionTile(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.remove_circle_outline_outlined,
                                          color: Colors.white, size: 50),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
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
                                    const Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    Container(
                                      height: 100,
                                      width: 370,
                                      child: const Padding(
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
                            Offstage(
                              offstage: _debugTray,
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: FilledButton(
                                    onPressed: () async {
                                      _prefs.clear();
                                      navPage(
                                              context: context,
                                              page: const IntroScreen(),
                                              enablePop: false)
                                          .navPageToPage();
                                      setState(() {
                                        _networkProvider.getApiData = [];
                                        _networkProvider.startUrl = "";
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(370, 58),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0))),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.autorenew,
                                            color: Colors.white, size: 50),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            '기본정보 초기화',
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
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: FilledButton(
                                    onPressed: () {
                                      navPage(
                                              context: context,
                                              page: const TestPagesScreen(),
                                              enablePop: true)
                                          .navPageToPage();
                                    },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(370, 58),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0))),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.request_page,
                                            color: Colors.white, size: 50),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            '테스트 페이지 이동',
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
                                    });
                                    if (_debugEncounter == 5 &&
                                        _debugTray == true) {
                                      _debugTray = false;
                                      _debugEncounter = 0;
                                    } else if (_debugEncounter == 3 &&
                                        _debugTray == false) {
                                      _debugTray = true;
                                      _debugEncounter = 0;
                                    }
                                  }
                                }
                              },
                              style: FilledButton.styleFrom(
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  fixedSize: const Size(400, 150)),
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
                              style: const TextStyle(
                                  fontFamily: 'kor', fontSize: 35),
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
