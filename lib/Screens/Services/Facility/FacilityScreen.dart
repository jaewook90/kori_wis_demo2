import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Modals/ServiceSelectModal.dart';
import 'package:kori_wis_demo/Modals/adminPWModal.dart';
import 'package:kori_wis_demo/Modals/powerOffModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityDoneFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityListScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigationPatrol.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview2.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview3.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences _prefs;

  final String facilityMap = 'assets/images/facility_map_v1.2.png';

  // final String facilityOfficeMap = 'assets/images/facility_test_v1.0.png';
  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;

  // late List<String> officeDetail;

  late int autoChargeConfig;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late bool _debugTray;

  String? startUrl;
  String? chgUrl;
  String? navUrl;

  late double buttonWidth;
  late double buttonHeight;

  // late List<double> poseX;
  // late List<double> poseY;
  //
  // late List<double> mapOrigin;
  // late List<double> originMove;
  //
  // late double canvasX;
  // late double canvasY;
  //
  // late double mapX;
  // late double mapY;

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

    _initSharedPreferences();

    _debugTray = true;

    _initAudio();

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    autoChargeConfig =
        Provider.of<MainStatusModel>(context, listen: false).autoCharge!;

    positioningList = [];
    positionList = [];
    positioningSeparatedCordList = [];
    positioningCordList = [];
    positionCordList = [];

    officeNum = [];
    officeName = [];
    // officeDetail = [];

    // canvasX = 972;
    // canvasY = 1344;

    buttonWidth = 100;
    buttonHeight = 30;

    // poseX = [];
    // poseY = [];
    // originMove = [];
    //
    // mapX = 44.8;
    // mapY = 100.5;
    //
    // mapOrigin = [3.1, 63.36];
    //
    // originMove.add(mapOrigin[0] / mapX);
    // originMove.add(mapOrigin[1] / mapY);

    officeQTY =
        Provider.of<MainStatusModel>(context, listen: false).cordList!.length;

    print(officeQTY);

    for (int h = 0; h < officeQTY; h++) {
      // poseX.add(double.parse(
      //     Provider.of<MainStatusModel>(context, listen: false).cordList![h]
      //         [0]));
      // poseY.add(double.parse(
      //     Provider.of<MainStatusModel>(context, listen: false).cordList![h]
      //         [1]));
      officeNum.add(
          Provider.of<NetworkModel>(context, listen: false).getPoseData![h]);

      if (Provider.of<NetworkModel>(context, listen: false).getPoseData![h] !=
          '시설1') {
        if (Provider.of<NetworkModel>(context, listen: false).getPoseData![h] !=
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
                          if (Provider.of<NetworkModel>(context, listen: false)
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
            // officeName.add('awsdfasdf');
            // officeDetail.add('여기는 ${officeName[h]} 입니다.');
          } else {
            officeName.add('화장실2');
            // officeDetail.add('여기는 화장실2 입니다.');
          }
        } else {
          officeName.add('화장실1');
          // officeDetail.add('여기는 화장실1 입니다.');
        }
      } else {
        officeName.add('엘리베이터');
        // officeDetail.add('여기는 엘리베이터 입니다.');
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
          // Provider.of<MainStatusModel>(context, listen: false)
          //     .facilityDetail!
          //     .add(officeDetail[i]);
        });
      }
      print(Provider.of<MainStatusModel>(context, listen: false).facilityNum);
      print(Provider.of<MainStatusModel>(context, listen: false).facilityName);
      print(
          Provider.of<MainStatusModel>(context, listen: false).facilityDetail);
    }
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  // cordOffice(String axis, int num) {
  //   if (axis == 'x') {
  //     double cordX =
  //         (canvasX * (((poseX[num]) / mapX) + ((mapOrigin[0] / mapX))) -
  //             (buttonWidth / 2));
  //     return cordX;
  //   } else if (axis == 'y') {
  //     double cordY =
  //         (canvasY * (((poseY[num]) / mapY) + ((mapOrigin[1] / mapY))) -
  //             (buttonHeight / 2));
  //     return cordY;
  //   }
  // }

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

  void facilityInform(context, int number) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return FacilityModal(
            number: number,
          );
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

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    _debugTray = _mainStatusProvider.debugMode!;

    // print(originMove);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                const AppBarStatus(),
                Positioned(
                    top: 25,
                    left: 53,
                    child: TextButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: const FacilityListScreen())
                            .navPageToPage();
                      },
                      style: TextButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.white, width: 2)),
                      child: const Text(
                        '입주사 목록',
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ))
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      drawerEdgeDragWidth: 70,
      endDrawerEnableOpenDragGesture: true,
      endDrawer:
          // ConfigDrawerMenu(),
          Drawer(
        backgroundColor: const Color(0xff292929),
        shadowColor: const Color(0xff191919),
        width: 800,
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.only(top: 100, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 390,
                      height: 500,
                      child: Column(
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
                                          fontSize: 36,
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
                                                  fontSize: 30,
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
                                                  fontSize: 25,
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
                                                  fontSize: 30,
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
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              configController.text = '';
                                            });
                                          },
                                          controller: configController,
                                          style: const TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 25,
                                              color: Colors.white),
                                          keyboardType: TextInputType.url,
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
                                    fixedSize: const Size(390, 58),
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
                                            fontSize: 36,
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
                                            fontSize: 36,
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
                                          fontSize: 36,
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
                                        left: 50, bottom: 30),
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
                                                  fontSize: 30,
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
                                              '$autoChargeConfig',
                                              style: const TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 25,
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
                                              '변경 할 설정',
                                              style: TextStyle(
                                                  fontFamily: 'kor',
                                                  fontSize: 30,
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
                                        TextField(
                                          onTap: () {
                                            setState(() {
                                              autoChargeController.text = '';
                                            });
                                          },
                                          controller: autoChargeController,
                                          style: const TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 25,
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
                                            fontSize: 36,
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
                                            fontSize: 36,
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
                                              fontSize: 36,
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
                                              fontSize: 36,
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
                                          page: const FacilityDoneScreen(),
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
                                              fontSize: 36,
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
                                              fontSize: 36,
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
      body: Stack(
        children: [
          Positioned(
            top: 110,
            left: (1080 * 0.1) / 2,
            child: Container(
              width: 972,
              height: 1344,
              decoration: BoxDecoration(
                border: const Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 2)),
                image: DecorationImage(
                    image: AssetImage(facilityMap), fit: BoxFit.fill),
              ),
              // 반응형 오피스 위치
              // child: Stack(children: [
              //   for (int i = 0; i < officeQTY; i++)
              //     Positioned(
              //         bottom: cordOffice('y', i),
              //         left: cordOffice('x', i),
              //         child: ConstrainedBox(
              //           constraints: BoxConstraints.tightFor(
              //               width: buttonWidth, height: buttonHeight),
              //           child: TextButton(
              //             onPressed: () {
              //               facilityInform(context, i);
              //             },
              //             style: TextButton.styleFrom(
              //               backgroundColor: Colors.transparent,
              //             ),
              //             child: officeNum[i] != '시설1'
              //                 ? officeNum[i] != '시설2'
              //                     ? officeNum[i] != '시설3'
              //                         ? Text(
              //                             '${officeNum[i]}',
              //                             style: const TextStyle(
              //                                 fontFamily: 'kor',
              //                                 fontSize: 10,
              //                                 fontWeight: FontWeight.bold,
              //                                 color: Colors.black),
              //                           )
              //                         : const Text(
              //                             '화장실2',
              //                             style: TextStyle(
              //                                 fontFamily: 'kor',
              //                                 fontSize: 10,
              //                                 fontWeight: FontWeight.bold,
              //                                 color: Colors.black),
              //                           )
              //                     : const Text(
              //                         '화장실1',
              //                         style: TextStyle(
              //                             fontFamily: 'kor',
              //                             fontSize: 10,
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.black),
              //                       )
              //                 : const Text(
              //                     '엘리베이터',
              //                     style: TextStyle(
              //                         fontFamily: 'kor',
              //                         fontSize: 10,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.black),
              //                   ),
              //           ),
              //         )),
              // ]),
            ),
          ),
          // 수동 위치 입력
          Positioned(
              top: 115,
              left: 840,
              child: GestureDetector(
                child: Container(
                  width: 180,
                  height: 355,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        width: 2,
                        color: Colors.transparent
                      )
                    )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 0);
                },
              )),
          Positioned(
              top: 480,
              left: 850,
              child: GestureDetector(
                child: Container(
                  width: 170,
                  height: 245,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 1);
                },
              )),
          Positioned(
              top: 735,
              left: 850,
              child: GestureDetector(
                child: Container(
                  width: 165,
                  height: 80,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 2);
                },
              )),
          Positioned(
              top: 820,
              left: 850,
              child: GestureDetector(
                child: Container(
                  width: 165,
                  height: 80,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 3);
                },
              )),
          Positioned(
              top: 910,
              left: 860,
              child: GestureDetector(
                child: Container(
                  width: 160,
                  height: 155,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 4);
                },
              )),
          Positioned(
              top: 1080,
              left: 875,
              child: GestureDetector(
                child: Container(
                  width: 145,
                  height: 370,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 5);
                },
              )),
          Positioned(
              top: 1190,
              left: 60,
              child: GestureDetector(
                child: Container(
                  width: 395,
                  height: 260,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 6);
                },
              )),
          Positioned(
              top: 1020,
              left: 60,
              child: GestureDetector(
                child: Container(
                  width: 500,
                  height: 160,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 7);
                },
              )),
          Positioned(
              top: 715,
              left: 60,
              child: GestureDetector(
                child: Container(
                  width: 440,
                  height: 295,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 8);
                },
              )),
          Positioned(
              top: 620,
              left: 325,
              child: GestureDetector(
                child: Container(
                  width: 175,
                  height: 80,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 9);
                },
              )),
          Positioned(
              top: 485,
              left: 60,
              child: GestureDetector(
                child: Container(
                  width: 205,
                  height: 215,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 10);
                },
              )),
          Positioned(
              top: 115,
              left: 60,
              child: GestureDetector(
                child: Container(
                  width: 435,
                  height: 325,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 11);
                },
              )),
          Positioned(
              top: 115,
              left: 515,
              child: GestureDetector(
                child: Container(
                  width: 245,
                  height: 325,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 12);
                },
              )),
          Positioned(
              top: 485,
              left: 360,
              child: GestureDetector(
                child: Container(
                  width: 140,
                  height: 95,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 13);
                },
              )),
          Positioned(
              top: 770,
              left: 575,
              child: GestureDetector(
                child: Container(
                  width: 215,
                  height: 60,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 14);
                },
              )),
          Positioned(
              top: 485,
              left: 565,
              child: GestureDetector(
                child: Container(
                  width: 210,
                  height: 95,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 15);
                },
              )),
          Positioned(
              top: 1245,
              left: 655,
              child: GestureDetector(
                child: Container(
                  width: 150,
                  height: 60,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 2,
                              color: Colors.transparent
                          )
                      )
                  ),
                ),
                onTap: () {
                  facilityInform(context, 16);
                },
              )),
        ],
      ),
    );
  }
}
