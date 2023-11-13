import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/testPages.dart';
import 'package:kori_wis_demo/Modals/CableConnectedModalFinal.dart';
import 'package:kori_wis_demo/Modals/EMGPopModalFinal.dart';
import 'package:kori_wis_demo/Modals/EmgStatusModal.dart';
import 'package:kori_wis_demo/Modals/ServiceSelectModal.dart';
import 'package:kori_wis_demo/Modals/adminPWModal.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Modals/powerOffModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityListScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigationPatrol.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview2.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview3.dart';
import 'package:kori_wis_demo/Utills/FacilityCurrentPose.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FacilityScreen extends StatefulWidget {
  const FacilityScreen({Key? key}) : super(key: key);

  @override
  State<FacilityScreen> createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  final TextEditingController configController = TextEditingController();
  final TextEditingController autoChargeController = TextEditingController();
  final CountdownController _controller = CountdownController(autoStart: true);
  late SharedPreferences _prefs;

  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;
  late String officePic;

  late int officeNumber;

  late Timer _pwrTimer;

  late int autoChargeConfig;

  late AudioPlayer _effectPlayer;

  // assets
  final String _effectFile = 'assets/sounds/button_click.wav';
  final String mainMap = 'assets/images/facility/323_black_map_modified_v_1_2.svg';
  final String mainMapBG = 'assets/images/facility/map_bg.svg';
  final String bottomBanner = 'assets/images/facility/bottom.png';
  final String listBtn = 'assets/images/facility/btn.svg';
  final String facilityName = 'assets/images/facility/habio_7_f.svg';
  final String notiBox = 'assets/images/facility/noti_box.svg';

  late bool _debugTray;
  late bool officeSelected;
  late bool officeSelectionTimeOut;

  String? startUrl;
  String? chgUrl;
  String? navUrl;

  late double buttonWidth;
  late double buttonHeight;

  late int CHGFlag;
  late int EMGStatus;

  dynamic newPoseData;
  dynamic poseData;
  dynamic newCordData;
  dynamic cordData;

  late List<String> positioningList;
  late List<String> positionList;
  late List<String> positioningCordList;
  late List<String> positioningSeparatedCordList;
  late List<List<String>> positionCordList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    officeNumber = 0;
    officePic = 'assets/images/facility/facNav/navDone/image.png';

    _initSharedPreferences();

    _debugTray = true;
    officeSelected = false;
    officeSelectionTimeOut = false;

    _initAudio();

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    autoChargeConfig =
        Provider.of<MainStatusModel>(context, listen: false).autoCharge!;

    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    positioningList = [];
    positionList = [];
    positioningSeparatedCordList = [];
    positioningCordList = [];
    positionCordList = [];

    officeNum = [];
    officeName = [];

    buttonWidth = 100;
    buttonHeight = 30;

    if (Provider.of<NetworkModel>(context, listen: false)
        .getPoseData!
        .isEmpty) {
      poseDataUpdate();
    }

    Provider.of<MainStatusModel>(context, listen: false).robotReturning = false;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
              Provider.of<MainStatusModel>(context, listen: false).emgButton! ||
          CHGFlag !=
              Provider.of<MainStatusModel>(context, listen: false)
                  .chargeFlag!) {
        setState(() {});
      }
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
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
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
      positionCordList = [];
      poseDataUpdate();
    });
  }

  void poseDataUpdate() {
    newPoseData = Provider.of<NetworkModel>(context, listen: false).getApiData;
    if (newPoseData != null) {
      poseData = newPoseData;
      cordData = newPoseData;
      String editPoseData = poseData.toString();

      editPoseData = editPoseData.replaceAll('{', "");
      editPoseData = editPoseData.replaceAll('}', "");

      List<String> positionWithCordList = editPoseData.split("], ");

      String editCordData = cordData.toString();

      editCordData = editCordData.replaceAll('{', "");
      editCordData = editCordData.replaceAll('}', "");
      List<String> cordWithNumList = editCordData.split("]");

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
      for (int h = 0; h < cordWithNumList.length - 1; h++) {
        positioningCordList = cordWithNumList[h].split(": [");
        positioningSeparatedCordList = positioningCordList[1].split(', ');
        positioningSeparatedCordList.removeAt(2);
        if (positionList[h] != 'charging_pile') {
          positionCordList.add(positioningSeparatedCordList);
        }
      }
      positionList.sort();
    } else {
      positionList = [];
    }
  }

  void showEMGStateModal(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const EMGStateModalScreen();
        });
  }

  void serviceSelectPopup(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const ServiceSelectModalFinal();
        });
  }

  void showPowerOffPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const PowerOffModalFinal();
        });
  }

  void enterAdmin(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const AdminPWModal();
        });
  }

  void showEMGAlert(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const EMGPopModalFinal();
        });
  }

  void showAdaptorCableAlert(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const CableConnectedModalFinal();
        });
  }

  void showCountDownPopup(context, officeLocation) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal(
            serviceMode: 'facilityGuide',
            goalPosition: officeLocation,
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    if(_mainStatusProvider.facilitySelectByBTN == true){
      setState(() {
        officeSelected = true;
        officeNumber = _mainStatusProvider.targetFacilityIndex!;
        _mainStatusProvider.facilitySelectByBTN = false;
      });
    }

    if (positionList.isEmpty) {
      positionList = _networkProvider.getPoseData!;
      positionCordList = _mainStatusProvider.cordList!;
    } else {
      _networkProvider.getPoseData = positionList;
      _mainStatusProvider.cordList = positionCordList;
    }

    _debugTray = _mainStatusProvider.debugMode!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      officeQTY =
          Provider.of<MainStatusModel>(context, listen: false).cordList!.length;

      print(officeQTY);

      for (int h = 0; h < officeQTY; h++) {
        officeNum.add(
            Provider.of<NetworkModel>(context, listen: false).getPoseData![h]);

        if (Provider.of<NetworkModel>(context, listen: false).getPoseData![h] !=
            '시설1') {
          if (Provider.of<NetworkModel>(context, listen: false)
                  .getPoseData![h] !=
              '시설2') {
            if (Provider.of<NetworkModel>(context, listen: false)
                    .getPoseData![h] !=
                '시설3') {
              if (Provider.of<NetworkModel>(context, listen: false)
                      .getPoseData![h] !=
                  '701') {
                // officeName.add("D'LIVE  (주)딜라이브");
                if (Provider.of<NetworkModel>(context, listen: false)
                        .getPoseData![h] !=
                    '704') {
                  if (Provider.of<NetworkModel>(context, listen: false)
                          .getPoseData![h] !=
                      '705') {
                    if (Provider.of<NetworkModel>(context, listen: false)
                            .getPoseData![h] !=
                        '706') {
                      if (Provider.of<NetworkModel>(context, listen: false)
                              .getPoseData![h] !=
                          '708') {
                        if (Provider.of<NetworkModel>(context, listen: false)
                                .getPoseData![h] !=
                            '710') {
                          if (Provider.of<NetworkModel>(context, listen: false)
                                  .getPoseData![h] !=
                              '711') {
                            if (Provider.of<NetworkModel>(context,
                                        listen: false)
                                    .getPoseData![h] !=
                                '712') {
                              if (Provider.of<NetworkModel>(context,
                                          listen: false)
                                      .getPoseData![h] !=
                                  '713') {
                                if (Provider.of<NetworkModel>(context,
                                            listen: false)
                                        .getPoseData![h] !=
                                    '715') {
                                  if (Provider.of<NetworkModel>(context,
                                              listen: false)
                                          .getPoseData![h] !=
                                      '716') {
                                    if (Provider.of<NetworkModel>(context,
                                                listen: false)
                                            .getPoseData![h] !=
                                        '717') {
                                      if (Provider.of<NetworkModel>(context,
                                                  listen: false)
                                              .getPoseData![h] !=
                                          '718') {
                                        if (Provider.of<NetworkModel>(context,
                                                    listen: false)
                                                .getPoseData![h] !=
                                            '719') {
                                        } else {
                                          officeName.add("JS융합인재교육원(주)");
                                        }
                                      } else {
                                        officeName.add("(주)딜라이브 자재실");
                                      }
                                    } else {
                                      officeName.add("수성엔지니어링");
                                    }
                                  } else {
                                    officeName.add("(주)엑사로보틱스");
                                  }
                                } else {
                                  officeName.add("HD인베스트");
                                }
                              } else {
                                officeName.add("신영비엠이(주)");
                              }
                            } else {
                              officeName.add("(주)엘렉시");
                            }
                          } else {
                            officeName.add("Daily Vegan");
                          }
                        } else {
                          officeName.add("(주)범건축종합건축사사무소");
                        }
                      } else {
                        officeName.add("(주)드림디엔에스");
                      }
                    } else {
                      officeName.add("DAWON Tax Office");
                    }
                  } else {
                    officeName.add("브레인컴퍼니");
                  }
                } else {
                  officeName.add("아워팜");
                }
              } else {
                officeName.add("(주)딜라이브");
              }
            } else {
              officeName.add('화장실2');
            }
          } else {
            officeName.add('화장실1');
          }
        } else {
          officeName.add('엘리베이터');
        }
      }

      if (Provider.of<MainStatusModel>(context, listen: false)
              .facilityNum!
              .isEmpty ||
          Provider.of<MainStatusModel>(context, listen: false)
              .facilityName!
              .isEmpty) {
        for (int i = 0; i < officeQTY; i++) {
          setState(() {
            Provider.of<MainStatusModel>(context, listen: false)
                .facilityNum!
                .add(officeNum[i]);
            Provider.of<MainStatusModel>(context, listen: false)
                .facilityName!
                .add(officeName[i]);
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 1080,
            height: 132,
            child: Stack(
              children: [
                const AppBarStatus(
                  iconPoseSide: 167 * 3,
                  iconPoseTop: 11 * 3,
                ),
                Positioned(
                    top: 30,
                    right: 51,
                    child: Stack(children: [
                      SvgPicture.asset(listBtn, width: 240, height: 72),
                      FilledButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              navPage(
                                      context: context,
                                      page: const FacilityListScreen(hideThings: false,))
                                  .navPageToPage();
                            });
                          });
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            fixedSize: const Size(240, 72),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        child: null,
                      ),
                    ])),
                Padding(
                  padding: const EdgeInsets.only(left: 54, top: 36),
                  child: SvgPicture.asset(
                    facilityName,
                    width: 82*3,
                    height: 14*3,
                  ),
                ),
              ],
            ),
          )
        ],
        toolbarHeight: 132,
      ),
      extendBodyBehindAppBar: true,
      drawerEdgeDragWidth: 70,
      endDrawerEnableOpenDragGesture: true,
      endDrawer:
          Drawer(
        backgroundColor: const Color(0xff292929),
        shadowColor: const Color(0xff191919),
        width: 800,
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 405,
                      height: 500,
                      child: Column(
                        children: [
                          //ip 변경
                          ExpansionTile(
                              tilePadding: const EdgeInsets.only(left: 30),
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
                                          fontSize: 34,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              initiallyExpanded: false,
                              backgroundColor: Colors.transparent,
                              onExpansionChanged: (value) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                              },
                              children: <Widget>[
                                const Divider(
                                    height: 20, color: Colors.grey, indent: 15),
                                SizedBox(
                                  width: 390,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, bottom: 10),
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
                                                  fontSize: 27,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              startUrl!,
                                              style: const TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '변경 할 IP',
                                              style: TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 27,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 120,
                                            ),
                                            FilledButton(
                                              onPressed: () async {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _effectPlayer.seek(
                                                      const Duration(
                                                          seconds: 0));
                                                  _effectPlayer.play();
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
                                                });
                                                FocusScope.of(context)
                                                    .unfocus();
                                                SystemChrome
                                                    .setEnabledSystemUIMode(
                                                        SystemUiMode.manual,
                                                        overlays: []);
                                              },
                                              style: FilledButton.styleFrom(
                                                  enableFeedback: false,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          80, 80, 255, 0.7),
                                                  shape: RoundedRectangleBorder(
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
                                        const SizedBox(
                                          height: 10,
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
                                              fontSize: 23,
                                              color: Colors.white),
                                          keyboardType: TextInputType.url,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(0),
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
                          Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    _networkProvider.servTable = 'wait';
                                    PostApi(
                                            url: startUrl,
                                            endadr: navUrl,
                                            keyBody: 'wait')
                                        .Posting(context);
                                    _networkProvider.currentGoal = '대기장소';
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      _effectPlayer.dispose();
                                      navPage(
                                        context: context,
                                        page:
                                            const NavigatorProgressModuleFinal(),
                                      ).navPageToPage();
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor: Colors.transparent,
                                    fixedSize: const Size(395, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.add_to_home_screen,
                                        color: Colors.white, size: 50),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '대기장소로 이동',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    getting(_networkProvider.startUrl!,
                                        _networkProvider.positionURL);
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    enableFeedback: false,
                                    fixedSize: const Size(390, 58),
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
                                        '목적지 초기화',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 390,
                      height: 500,
                      child: Column(
                        children: [
                          ExpansionTile(
                              tilePadding: const EdgeInsets.only(left: 25),
                              title: const Row(
                                children: [
                                  Icon(Icons.battery_saver,
                                      color: Colors.white, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '자동 충전 설정',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 34,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              initiallyExpanded: false,
                              backgroundColor: Colors.transparent,
                              onExpansionChanged: (value) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                              },
                              children: <Widget>[
                                const Divider(
                                    height: 20, color: Colors.grey, indent: 15),
                                SizedBox(
                                  width: 390,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, bottom: 10),
                                    child: Column(
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '현재 설정',
                                              style: TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 27,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$autoChargeConfig',
                                              style: const TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '변경 할 설정',
                                              style: TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 27,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 100,
                                            ),
                                            FilledButton(
                                              onPressed: () async {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _effectPlayer.seek(
                                                      const Duration(
                                                          seconds: 0));
                                                  _effectPlayer.play();
                                                  _prefs.setInt(
                                                      'autoCharge',
                                                      int.parse(
                                                          autoChargeController
                                                              .text));

                                                  setState(() {
                                                    _mainStatusProvider
                                                            .autoCharge =
                                                        int.parse(
                                                            autoChargeController
                                                                .text);
                                                    autoChargeConfig =
                                                        _mainStatusProvider
                                                            .autoCharge!;
                                                    autoChargeController.text =
                                                        '';
                                                  });
                                                });
                                                FocusScope.of(context)
                                                    .unfocus();
                                                SystemChrome
                                                    .setEnabledSystemUIMode(
                                                        SystemUiMode.manual,
                                                        overlays: []);
                                              },
                                              style: FilledButton.styleFrom(
                                                  enableFeedback: false,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          80, 80, 255, 0.7),
                                                  shape: RoundedRectangleBorder(
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              autoChargeController.text = '';
                                            });
                                          },
                                          controller: autoChargeController,
                                          style: const TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 23,
                                              color: Colors.white),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(),
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(0),
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
                          Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    _networkProvider.servTable =
                                        'charging_pile';
                                    PostApi(
                                            url: startUrl,
                                            endadr: chgUrl,
                                            keyBody: 'charging_pile')
                                        .Posting(context);
                                    _networkProvider.currentGoal = '충전스테이션';
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      _effectPlayer.dispose();
                                      navPage(
                                        context: context,
                                        page:
                                            const NavigatorProgressModuleFinal(),
                                      ).navPageToPage();
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor: Colors.transparent,
                                    fixedSize: const Size(390, 58),
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
                                        '충전',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
                                    _effectPlayer
                                        .seek(const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      _effectPlayer.dispose();
                                      serviceSelectPopup(context);
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    enableFeedback: false,
                                    fixedSize: const Size(390, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.change_circle_outlined,
                                        color: Colors.white, size: 50),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '서비스 모드 변경',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Offstage(
                  offstage: _debugTray,
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 5,
                        height: 80,
                        color: Colors.grey,
                        indent: 15,
                        endIndent: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 390,
                            height: 250,
                            child: Column(
                              children: [
                                FilledButton(
                                  onPressed: () async {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer
                                          .seek(const Duration(seconds: 0));
                                      _effectPlayer.play();
                                      _prefs.clear();
                                      Future.delayed(
                                          const Duration(milliseconds: 230),
                                          () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page: const IntroScreen(),
                                        ).navPageToPage();
                                      });
                                      setState(() {
                                        _networkProvider.getApiData = [];
                                        _networkProvider.startUrl = "";
                                      });
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      enableFeedback: false,
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(390, 58),
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
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer
                                          .seek(const Duration(seconds: 0));
                                      _effectPlayer.play();
                                      Future.delayed(
                                          const Duration(milliseconds: 230),
                                          () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page: const NavigationPatrol(),
                                        ).navPageToPage();
                                      });
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      enableFeedback: false,
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(390, 58),
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
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 390,
                            height: 250,
                            child: Column(
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer.play();
                                      _effectPlayer
                                          .seek(const Duration(seconds: 0));
                                      Future.delayed(
                                          const Duration(milliseconds: 230),
                                          () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page: const TestPagesScreen(),
                                        ).navPageToPage();
                                      });
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      enableFeedback: false,
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(390, 58),
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
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer
                                          .seek(const Duration(seconds: 0));
                                      _effectPlayer.play();
                                      Future.delayed(
                                          const Duration(milliseconds: 230),
                                          () {
                                        _effectPlayer.dispose();
                                        navPage(
                                          context: context,
                                          page: const IntroScreen(),
                                        ).navPageToPage();
                                      });
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                      enableFeedback: false,
                                      backgroundColor: Colors.transparent,
                                      fixedSize: const Size(390, 58),
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
                                          '인트로 화면 이동',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 5,
                        height: 80,
                        color: Colors.grey,
                        indent: 15,
                        endIndent: 15,
                      ),
                      const Text(
                        '액티브 링크',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  _effectPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const WebviewPage1(),
                                  ).navPageToPage();
                                });
                              });
                            },
                            style: TextButton.styleFrom(
                                fixedSize: const Size(60, 60),
                                enableFeedback: false,
                                padding:
                                    const EdgeInsets.only(right: 0, bottom: 2),
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
                          ),
                          TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  _effectPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const WebviewPage2(),
                                  ).navPageToPage();
                                });
                              });
                            },
                            style: TextButton.styleFrom(
                                fixedSize: const Size(60, 60),
                                enableFeedback: false,
                                padding:
                                    const EdgeInsets.only(right: 0, bottom: 2),
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
                          ),
                          TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  _effectPlayer.dispose();
                                  navPage(
                                    context: context,
                                    page: const WebviewPage3(),
                                  ).navPageToPage();
                                });
                              });
                            },
                            style: TextButton.styleFrom(
                                fixedSize: const Size(60, 60),
                                enableFeedback: false,
                                padding:
                                    const EdgeInsets.only(right: 0, bottom: 2),
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
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 800,
                  child: FilledButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        Future.delayed(const Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          if (_debugTray == true) {
                            enterAdmin(context);
                          } else {
                            setState(() {
                              _mainStatusProvider.debugMode = true;
                            });
                          }
                        });
                      });
                    },
                    style: FilledButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        fixedSize: const Size(400, 150)),
                    child: Text(
                      '관리자 모드',
                      style: TextStyle(
                          fontSize: 50,
                          color:
                              _debugTray == true ? Colors.white : Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //전원 버튼
          Container(
            margin: const EdgeInsets.only(left: 700, top: 10),
            width: 78,
            child: IconButton(
              onPressed: () {
                showPowerOffPopup(context);
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              iconSize: 60,
            ),
          ),
        ]),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(color: Color(0xff191919)),
        child: Stack(
          children: [
            Offstage(
              offstage: officeSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 135),
                child: SvgPicture.asset(
                  notiBox,
                  width: 1080,
                  height: 96,
                ),
              ),
            ),
            Offstage(
              offstage: officeSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 1614, left: 51),
                child: Container(
                    width: 978,
                    height: 255,
                    decoration: BoxDecoration(
                        image:
                            DecorationImage(image: AssetImage(bottomBanner))),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 25*3, left: 146*3),
                        width: 34*3,
                        height: 13*3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_on_outlined, size: 11*3, color: Color(0xffffffff).withOpacity(0.6),),
                            Text('주소', style: TextStyle(fontFamily: 'kor', fontSize: 11*3, color: Color(0xffffffff).withOpacity(0.6), fontWeight: FontWeight.w700, height: 1.1),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 44*3, left: 108*3),
                        width: 109*3,
                        height: 16*3,
                        child: Text(
                          '서울특별시 송파구 송파대로 111\n파크하비오 205동 _7층',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'kor', fontSize: 7*3, color: Color(0xffffffff).withOpacity(0.4), fontWeight: FontWeight.w400, height: 1.1, letterSpacing: -0.04*3)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: !officeSelected,
              child:SvgPicture.asset(
                mainMapBG,
                width: 1080,
                height: 1920,
              ),
            ),
            AnimatedPadding(
              padding: EdgeInsets.only(
                  top: officeSelected ? 176 * 3 : 255, left: 51),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: Stack(
                children: [SvgPicture.asset(
                  mainMap,
                  width: 978,
                  height: 1335,
                ),
                  // const FacilityCurrentPositionScreen()
                ]
              ),
            ),
            // 입주사 화면 버튼
            AnimatedPadding(
              padding: EdgeInsets.only(
                  top: officeSelected ? (176 - 85) * 3 : 0, left: 0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: Stack(
                children: [
                  Positioned(
                      top: 263,
                      left: 833,
                      child: GestureDetector(
                        child: Container(
                          width: 190,
                          height: 350,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 0;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 620,
                      left: 840,
                      child: GestureDetector(
                        child: Container(
                          width: 180,
                          height: 240,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 1;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 865,
                      left: 842,
                      child: GestureDetector(
                        child: Container(
                          width: 181,
                          height: 80,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 2;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 952,
                      left: 847,
                      child: GestureDetector(
                        child: Container(
                          width: 173,
                          height: 95,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 3;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 1053,
                      left: 853,
                      child: GestureDetector(
                        child: Container(
                          width: 167,
                          height: 147,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 4;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 1210,
                      left: 868,
                      child: GestureDetector(
                        child: Container(
                          width: 152,
                          height: 375,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 5;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 1323,
                      left: 60,
                      child: GestureDetector(
                        child: Container(
                          width: 390,
                          height: 262,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 6;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 1155,
                      left: 60,
                      child: GestureDetector(
                        child: Container(
                          width: 495,
                          height: 160,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 7;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 856,
                      left: 60,
                      child: GestureDetector(
                        child: Container(
                          width: 440,
                          height: 290,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 8;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 767,
                      left: 287,
                      child: GestureDetector(
                        child: Container(
                          width: 210,
                          height: 80,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 9;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 628,
                      left: 60,
                      child: GestureDetector(
                        child: Container(
                          width: 215,
                          height: 220,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 10;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 260,
                      left: 57,
                      child: GestureDetector(
                        child: Container(
                          width: 489,
                          height: 305,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 11;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 260,
                      left: 553,
                      child: GestureDetector(
                        child: Container(
                          width: 205,
                          height: 305,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 12;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 625,
                      left: 350,
                      child: GestureDetector(
                        child: Container(
                          width: 150,
                          height: 83,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 13;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 915,
                      left: 580,
                      child: GestureDetector(
                        child: Container(
                          width: 200,
                          height: 85,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 14;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 620,
                      left: 560,
                      child: GestureDetector(
                        child: Container(
                          width: 210,
                          height: 100,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 15;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                  Positioned(
                      top: 1322,
                      left: 647,
                      child: GestureDetector(
                        child: Container(
                          width: 147,
                          height: 101,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 2, color: Colors.transparent))),
                        ),
                        onTap: () {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              officeSelected = true;
                              officeSelectionTimeOut = false;
                              _controller.restart();
                              officeNumber = 16;
                              _mainStatusProvider.targetFacilityIndex = officeNumber;
                            });
                          });
                        },
                      )),
                ],
              ),
            ),
            // 상단 팝업 화면
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              height: officeSelected ? officeSelectionTimeOut ? 146*3 : 181 * 3
                  : 0,
              width: 1080,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff2e2e2e).withOpacity(0.5),
                        spreadRadius: 20,
                        blurRadius: 25,
                        offset: const Offset(0, 5))
                  ],
                  border: const Border.fromBorderSide(
                      BorderSide(color: Color(0x4cffffff), width: 1.5)),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45)),
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xff222222), Color(0xff4d4d4d)])),
              child: Stack(
                children: [
                  //업장 선택
                  Offstage(
                  offstage: officeSelectionTimeOut,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 54 * 3, left: 17 * 3),
                        child: Container(
                          width: 280 * 3,
                          height: 62 * 3,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2 * 3),
                                child: Container(
                                  width: 103 * 3,
                                  height: 59 * 3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/images/facility/banners/${_mainStatusProvider.facilityNum![officeNumber]}.png'))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 114 * 3),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: (280 - 105) * 3,
                                      child: Text(
                                        '${_mainStatusProvider.facilityNum![officeNumber]}호',
                                        style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 14 * 3,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffffffff),
                                            letterSpacing: -0.24),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (280 - 105) * 3,
                                      child: Text(
                                        _mainStatusProvider
                                            .facilityName![officeNumber],
                                        style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 14 * 3,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffffffff),
                                            letterSpacing: -0.24),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4 * 3,
                                    ),
                                    SizedBox(
                                      width: (280 - 105) * 3,
                                      child: Text(
                                        _mainStatusProvider.facilityDetail![officeNumber],
                                        style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 10 * 3,
                                            fontWeight: FontWeight.w100,
                                            color: Color(0xffffffff),
                                            letterSpacing: -0.21),
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 버튼
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 130 * 3, left: 17 * 3),
                        child: SizedBox(
                          width: 326 * 3,
                          height: 34 * 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _controller.pause();
                                    setState(() {
                                      officeSelected = false;
                                    });
                                    if (EMGStatus == 0) {
                                      showEMGStateModal(context);
                                    } else {
                                      if (CHGFlag == 3) {
                                        showAdaptorCableAlert(context);
                                      } else {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _effectPlayer
                                              .seek(const Duration(seconds: 0));
                                          _effectPlayer.play();
                                          Future.delayed(
                                              const Duration(milliseconds: 230),
                                              () {
                                            _effectPlayer.dispose();
                                            showCountDownPopup(
                                                context,
                                                _mainStatusProvider
                                                    .facilityNum![officeNumber]);
                                          });
                                        });
                                      }
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      fixedSize: const Size(159 * 3, 34 * 3),
                                      backgroundColor: const Color(0xff000000)
                                          .withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: const Center(
                                      child: Text(
                                    '로봇 길안내',
                                    style: TextStyle(
                                      fontFamily: 'kor',
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14 * 3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))),
                              TextButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _effectPlayer
                                          .seek(const Duration(seconds: 0));
                                      _effectPlayer.play();
                                      Future.delayed(
                                          const Duration(milliseconds: 230), () {
                                        _effectPlayer.dispose();
                                        setState(() {
                                          officeSelected = false;
                                        });
                                      });
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      fixedSize: const Size(159 * 3, 34 * 3),
                                      backgroundColor: const Color(0xff000000)
                                          .withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: const Center(
                                      child: Text(
                                    '새로운 안내',
                                    style: TextStyle(
                                      fontFamily: 'kor',
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14 * 3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))),
                            ],
                          ),
                        ),
                      ),
                      Countdown(
                        controller: _controller,
                        seconds: 10,
                        build: (_, double time) {
                          if (!officeSelected) {
                            _controller.restart();
                            _controller.pause();
                          }
                          return Container();
                        },
                        interval: const Duration(seconds: 1),
                        onFinished: () {
                          setState(() {
                            officeSelectionTimeOut = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                  //시간 초과
                  Offstage(
                    offstage: !officeSelectionTimeOut,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50 * 3, left: 70 * 3),
                          child: Container(
                            width: 230 * 3,
                            child: const Text(
                              '"다른 장소 안내를 원하시나요?"',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 17 * 3,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffffffff)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        // 버튼
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 95 * 3, left: 17 * 3),
                          child: SizedBox(
                            width: 326 * 3,
                            height: 34 * 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        _effectPlayer.seek(const Duration(seconds: 0));
                                        _effectPlayer.play();
                                        Future.delayed(const Duration(milliseconds: 230), () {
                                          _effectPlayer.dispose();
                                          setState(() {
                                            officeSelectionTimeOut = false;
                                          });
                                          _controller.restart();
                                        });
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        fixedSize: const Size(159 * 3, 34 * 3),
                                        backgroundColor: const Color(0xff000000)
                                            .withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12))),
                                    child: const Center(
                                        child: Text(
                                          '취소',
                                          style: TextStyle(
                                            fontFamily: 'kor',
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14 * 3,
                                          ),
                                          textAlign: TextAlign.center,
                                        ))),
                                TextButton(
                                    onPressed: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        _effectPlayer.seek(const Duration(seconds: 0));
                                        _effectPlayer.play();
                                        Future.delayed(const Duration(milliseconds: 230), () {
                                          _effectPlayer.dispose();
                                          setState(() {
                                            officeSelectionTimeOut = false;
                                            officeSelected = false;
                                          });
                                        });
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        fixedSize: const Size(159 * 3, 34 * 3),
                                        backgroundColor: const Color(0xff0a84ff),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12))),
                                    child: const Center(
                                        child: Text(
                                          '확인',
                                          style: TextStyle(
                                            fontFamily: 'kor',
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14 * 3,
                                          ),
                                          textAlign: TextAlign.center,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
