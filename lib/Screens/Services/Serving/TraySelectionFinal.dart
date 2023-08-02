import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/testPages.dart';
import 'package:kori_wis_demo/Modals/ServingModules/itemSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/tableSelectModalFinal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigationPatrol.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview2.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview3.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
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
  late MainStatusModel _mainStatusProvider;

  late bool mainInit;

  late bool volumeOnOff;

  final TextEditingController configController = TextEditingController();
  late SharedPreferences _prefs;

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingMain.mp3';

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late Timer _timer;
  late Timer _pwrTimer;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> positioningList;
  late List<String> positionList;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  // 배경 화면
  late String backgroundImage;

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

    volumeOnOff = true;

    fToast = FToast();
    fToast?.init(context);

    positioningList = [];
    positionList = [];

    backgroundImage = "assets/screens/Serving/KoriServingMain.png";

    table1 = "";
    table2 = "";
    table3 = "";

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }

    _initAudio();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _audioPlayer.play();
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _audioPlayer.seek(const Duration(seconds: 0));
    });

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if ((EMGStatus !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .emgButton! ||
              CHGFlag !=
                  Provider.of<MainStatusModel>(context, listen: false)
                      .chargeFlag!) ||
          batData !=
              Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }
      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag =
          Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus =
          Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _audioPlayer.setVolume(1);
    _effectPlayer.setVolume(0.8);
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

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const NavCountDownModalFinal();
        });
  }

  void showTableSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectTableModalFinal();
        });
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
  void dispose() {
    // TODO: implement dispose
    // _pwrTimer.cancel();
    _timer.cancel();
    _pwrTimer.cancel();
    _audioPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    mainInit = _servingProvider.mainInit!;

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

    _debugTray = _mainStatusProvider.debugMode!;

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
            SizedBox(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    right: 46,
                    top: 60,
                    child: Text(('${batData.toString()} %')),
                  ),
                  Positioned(
                    right: 50,
                    top: 20,
                    child: Container(
                      height: 45,
                      width: 50,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  EMGStatus == 0
                      ? const Positioned(
                          right: 35,
                          top: 15,
                          child: Icon(Icons.block,
                              color: Colors.red,
                              size: 80,
                              grade: 200,
                              weight: 200),
                        )
                      : Container(),
                  CHGFlag == 3
                      ? const Positioned(
                    right: 50,
                    top: 18,
                    child: Icon(Icons.bolt,
                        color: Colors.yellow,
                        size: 50),
                  )
                      : Container(),
                  Positioned(
                    right: 150,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _servingProvider.mainInit = false;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _audioPlayer.dispose();
                          _effectPlayer.seek(Duration(seconds: 0));
                          _effectPlayer.play();
                          _timer.cancel();
                          _pwrTimer.cancel();
                          showReturnSelectPopup(context);
                        });
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(60, 60),
                          enableFeedback: false,
                          padding: const EdgeInsets.only(right: 0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      child: const Icon(Icons.shopping_cart_checkout, size: 50),
                    ),
                  ),
                  Positioned(
                    right: 250,
                    top: 25,
                    child: FilledButton(
                      onPressed: () {
                        if(volumeOnOff == true){
                          _audioPlayer.stop();
                          setState(() {
                            volumeOnOff = false;
                          });
                        }else{
                          _audioPlayer.seek(Duration(seconds: 0));
                          _audioPlayer.play();
                          setState(() {
                            volumeOnOff = true;
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(60, 60),
                          enableFeedback: false,
                          padding: const EdgeInsets.only(right: 0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      child: Icon(
                        volumeOnOff == true?
                          Icons.volume_up : Icons.volume_off, size: 50),
                    ),
                  ),
                  Positioned(
                    right: 350,
                    top: 25,
                    child: Offstage(
                      offstage: _debugTray,
                      child: const SizedBox(
                        height: 60,
                        width: 60,
                        child: Icon(Icons.bug_report, size: 50),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 20,
                      top: 25,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _servingProvider.mainInit = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(Duration(seconds: 0));
                            _effectPlayer.play();
                            navPage(
                              context: context,
                              page: const WebviewPage1(),
                            ).navPageToPage();
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            enableFeedback: false,
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
                          setState(() {
                            _servingProvider.mainInit = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(Duration(seconds: 0));
                            _effectPlayer.play();
                            navPage(
                              context: context,
                              page: const WebviewPage2(),
                            ).navPageToPage();
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            enableFeedback: false,
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
                          setState(() {
                            _servingProvider.mainInit = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(Duration(seconds: 0));
                            _effectPlayer.play();
                            navPage(
                              context: context,
                              page: const WebviewPage3(),
                            ).navPageToPage();
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            enableFeedback: false,
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
                    SizedBox(
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
                                        'IP 변경',
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
                                onExpansionChanged: (value) {
                                  _effectPlayer.seek(Duration(seconds: 0));
                                  _effectPlayer.play();
                                },
                                children: <Widget>[
                                  const Divider(
                                      height: 20,
                                      color: Colors.grey,
                                      indent: 15),
                                  SizedBox(
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
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                            _effectPlayer.seek(Duration(seconds: 0));
                                                            _effectPlayer.play();
                                                    _prefs.setString('robotIp',
                                                        configController.text);
                                                    setState(() {
                                                      _networkProvider
                                                              .startUrl =
                                                          "http://${configController.text}/";
                                                      startUrl =
                                                          _networkProvider
                                                              .startUrl;
                                                      configController.text =
                                                          '';
                                                    });
                                                    getting(
                                                        _networkProvider
                                                            .startUrl!,
                                                        _networkProvider
                                                            .positionURL);
                                                  });
                                                },
                                                style: FilledButton.styleFrom(
                                                    enableFeedback: false,
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer.seek(Duration(seconds: 0));
                                      _effectPlayer.play();
                                      getting(_networkProvider.startUrl!,
                                          _networkProvider.positionURL);
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      enableFeedback: false,
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
                                          '목적지설정 초기화',
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
                                    setState(() {
                                      _servingProvider.mainInit = false;
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer.seek(Duration(seconds: 0));
                                      _effectPlayer.play();
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
                                      ).navPageToPage();
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      enableFeedback: false,
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
                                          '충전 스테이션으로 이동',
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
                                  title: Row(
                                    children: const [
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
                                  onExpansionChanged: (value) {
                                    _effectPlayer.seek(Duration(seconds: 0));
                                    _effectPlayer.play();
                                  },
                                  children: const <Widget>[
                                    Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    SizedBox(
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
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Offstage(
                              offstage: _debugTray,
                              child: ExpansionTile(
                                  title: Row(
                                    children: const [
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
                                  onExpansionChanged: (value) {
                                    _effectPlayer.seek(Duration(seconds: 0));
                                    _effectPlayer.play();
                                  },
                                  children: const <Widget>[
                                    Divider(
                                        height: 1,
                                        color: Colors.grey,
                                        indent: 15),
                                    SizedBox(
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
                                      setState(() {
                                        _servingProvider.mainInit = false;
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _effectPlayer.seek(Duration(seconds: 0));
                                        _effectPlayer.play();
                                        _prefs.clear();
                                        navPage(
                                          context: context,
                                          page: const IntroScreen(),
                                        ).navPageToPage();
                                        setState(() {
                                          _networkProvider.getApiData = [];
                                          _networkProvider.startUrl = "";
                                        });
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                        enableFeedback: false,
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
                                      setState(() {
                                        _servingProvider.mainInit = false;
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _effectPlayer.play();
                                        _effectPlayer.seek(Duration(seconds: 0));
                                        navPage(
                                          context: context,
                                          page: const TestPagesScreen(),
                                        ).navPageToPage();
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                        enableFeedback: false,
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
                                      setState(() {
                                        _servingProvider.mainInit = false;
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _effectPlayer.seek(Duration(seconds: 0));
                                        _effectPlayer.play();
                                        navPage(
                                          context: context,
                                          page: const NavigationPatrol(),
                                        ).navPageToPage();
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                        enableFeedback: false,
                                        backgroundColor: Colors.transparent,
                                        fixedSize: const Size(370, 58),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0))),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.repeat,
                                            color: Colors.white, size: 50),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            '순찰 기동',
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
                                _effectPlayer.seek(Duration(seconds: 0));
                                _effectPlayer.play();
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
                                      // _debugTray = false;
                                      _mainStatusProvider.debugMode = false;
                                      _debugEncounter = 0;
                                    } else if (_debugEncounter == 3 &&
                                        _debugTray == false) {
                                      // _debugTray = true;
                                      _mainStatusProvider.debugMode = true;
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
            child: Stack(children: [
              //서빙 버튼
              Positioned(
                  left: 315,
                  top: 152,
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: const Color(0xff3a46f0),
                          shape: RoundedRectangleBorder(
                              // side: const BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: const Size(450, 168)),
                      onPressed: () {
                        _audioPlayer.dispose();
                        setState(() {
                          _servingProvider.mainInit = false;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(Duration(seconds: 0));
                          _effectPlayer.play();
                          if ((_servingProvider.table1 != "" ||
                                  _servingProvider.table2 != "") ||
                              _servingProvider.table3 != "") {
                            _timer.cancel();
                            _pwrTimer.cancel();
                            showCountDownPopup(context);
                          } else {
                            _servingProvider.trayCheckAll = true;
                            _timer.cancel();
                            _pwrTimer.cancel();
                            showTableSelectPopup(context);
                            _servingProvider.menuItem = "상품";
                          }
                        });
                      },
                      child: const Text(
                        '서빙시작',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'kor',
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ))),
              const Positioned(
                  top: 345,
                  child: SizedBox(
                    width: 1080,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '트레이를 선택하세요',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )),
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer.seek(Duration(seconds: 0));
                                  _effectPlayer.play();
                                  if (_servingProvider.attachedTray1 == true) {
                                    setState(() {
                                      _servingProvider.stickTray1();
                                    });
                                  } else {
                                    setState(() {
                                      _servingProvider.dittachedTray1();
                                    });
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                  enableFeedback: false,
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer.seek(Duration(seconds: 0));
                                  _effectPlayer.play();
                                  if (_servingProvider.attachedTray2 == true) {
                                    setState(() {
                                      _servingProvider.stickTray2();
                                    });
                                  } else {
                                    setState(() {
                                      _servingProvider.dittachedTray2();
                                    });
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                  enableFeedback: false,
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer.seek(Duration(seconds: 0));
                                  _effectPlayer.play();
                                  if (_servingProvider.attachedTray3 == true) {
                                    setState(() {
                                      _servingProvider.stickTray3();
                                    });
                                  } else {
                                    setState(() {
                                      _servingProvider.dittachedTray3();
                                    });
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                  enableFeedback: false,
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(Duration(seconds: 0));
                        _effectPlayer.play();
                        setState(() {
                          _servingProvider.clearTray1();
                        });
                      });
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(Duration(seconds: 0));
                        _effectPlayer.play();
                        setState(() {
                          _servingProvider.clearTray2();
                        });
                      });
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(Duration(seconds: 0));
                        _effectPlayer.play();
                        setState(() {
                          _servingProvider.clearTray3();
                        });
                      });
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
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
                      SizedBox(
                        width: 388.5,
                        height: 171.8,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                _servingProvider.mainInit = false;
                                // _audioPlayer.stop();
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(Duration(seconds: 0));
                                _effectPlayer.play();
                                _servingProvider.tray1Select = true;
                                _servingProvider.tray2Select = false;
                                _servingProvider.tray3Select = false;
                                _servingProvider.trayCheckAll = false;
                                _audioPlayer.dispose();
                                _timer.cancel();
                                _pwrTimer.cancel();
                                showTraySetPopup(context);
                              });
                            },
                            style: TextButton.styleFrom(
                                enableFeedback: false,
                                foregroundColor: Colors.tealAccent,
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.green, width: 10),
                                    borderRadius: BorderRadius.circular(20))),
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
                                    image: AssetImage(
                                        _servingProvider.itemImageList![1])),
                                borderRadius: BorderRadius.circular(0),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 388.5,
                        height: 171.8,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                _servingProvider.mainInit = false;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(Duration(seconds: 0));
                                _effectPlayer.play();
                                _servingProvider.tray1Select = false;
                                _servingProvider.tray2Select = true;
                                _servingProvider.tray3Select = false;
                                _servingProvider.trayCheckAll = false;
                                _audioPlayer.dispose();
                                _timer.cancel();
                                _pwrTimer.cancel();
                                showTraySetPopup(context);
                              });
                            },
                            style: TextButton.styleFrom(
                                enableFeedback: false,
                                foregroundColor: Colors.tealAccent,
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.green, width: 10),
                                    borderRadius: BorderRadius.circular(20))),
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
                                    image: AssetImage(
                                        _servingProvider.itemImageList![2])),
                                borderRadius: BorderRadius.circular(0),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 518 * 0.75,
                        height: 293 * 0.75,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                _servingProvider.mainInit = false;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(Duration(seconds: 0));
                                _effectPlayer.play();
                                _servingProvider.tray1Select = false;
                                _servingProvider.tray2Select = false;
                                _servingProvider.tray3Select = true;
                                _servingProvider.trayCheckAll = false;
                                _audioPlayer.dispose();
                                _timer.cancel();
                                _pwrTimer.cancel();
                                showTraySetPopup(context);
                              });
                            },
                            style: TextButton.styleFrom(
                                enableFeedback: false,
                                foregroundColor: Colors.tealAccent,
                                backgroundColor: Colors.transparent,
                                fixedSize:
                                    Size(textButtonWidth, textButtonHeight),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.green, width: 10),
                                    borderRadius: BorderRadius.circular(20))),
                            child: Container()),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
