import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/powerOffModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargingStation extends StatefulWidget {
  const ChargingStation({Key? key}) : super(key: key);

  @override
  State<ChargingStation> createState() => _ChargingStationState();
}

class _ChargingStationState extends State<ChargingStation> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  final TextEditingController autoChargeController = TextEditingController();
  late SharedPreferences _prefs;

  late AudioPlayer _audioPlayer;
  String _audioFile = 'assets/sounds/dock3.wav';

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late Timer _pwrTimer;
  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late int autoChargeConfig;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initSharedPreferences();

    batData = 0;
    CHGFlag = 8;
    EMGStatus = 1;

    autoChargeConfig = Provider.of<MainStatusModel>(context, listen: false).autoCharge!;

    Future.delayed(Duration(milliseconds: 1000), () {
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
          setState(() {
            batData =
                Provider.of<MainStatusModel>(context, listen: false).batBal!;
            CHGFlag = Provider.of<MainStatusModel>(context, listen: false)
                .chargeFlag!;
            EMGStatus =
                Provider.of<MainStatusModel>(context, listen: false).emgButton!;
          });
        }
      });
    });

    _initAudio();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void showPowerOffPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const PowerOffModalFinal();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
    _audioPlayer.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (CHGFlag == 1) {
        navPage(context: context, page: TraySelectionSec()).navPageToPage();
      }
    });

    if (_mainStatusProvider.fromDocking == true) {
      _audioPlayer.play();
      setState(() {
        _mainStatusProvider.fromDocking = false;
      });
    } else if (_mainStatusProvider.fromDocking == false || _mainStatusProvider.fromDocking == null){
      _audioPlayer.dispose();
    }

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
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      _mainStatusProvider.restartService = true;
                      PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                          .Posting(context);
                      Future.delayed(Duration(milliseconds: 500), () {
                        navPage(
                          context: context,
                          page: const TraySelectionSec(),
                        ).navPageToPage();
                      });
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(90, 90),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Home.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      drawerEdgeDragWidth: 70,
      endDrawerEnableOpenDragGesture: true,
      endDrawer: Drawer(
        backgroundColor: const Color(0xff292929),
        shadowColor: const Color(0xff191919),
        width: 400,
        child: Stack(
          children: [
            SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 300),
                child: IconButton(
                  onPressed: () {
                    showPowerOffPopup(context);
                  },
                  icon: Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  iconSize: 50,
                ),
              ),
            ),
            Container(
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
                            ExpansionTile(
                                title: const Row(
                                  children: [
                                    Icon(Icons.battery_saver,
                                        color: Colors.white, size: 50),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '자동 충전',
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
                                  _effectPlayer
                                      .seek(const Duration(seconds: 0));
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
                                                '현재 설정',
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
                                                '$autoChargeConfig',
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
                                                '변경 할 설정',
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
                                                        _effectPlayer.seek(
                                                            const Duration(
                                                                seconds: 0));
                                                        _effectPlayer.play();
                                                        _prefs.setInt('autoCharge',
                                                            int.parse(autoChargeController.text));

                                                        setState(() {
                                                          _mainStatusProvider.autoCharge = int.parse(autoChargeController.text);
                                                          autoChargeConfig = _mainStatusProvider.autoCharge!;
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
                                                autoChargeController.text = '';
                                              });
                                            },
                                            controller: autoChargeController,
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
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),]
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.charging_station_outlined,
                    size: 350,
                    color: Colors.white,
                  ),
                  Text(
                    '$batData%',
                    style: TextStyle(
                        height: 1.25,
                        // letterSpacing: 10,
                        fontFamily: 'kor',
                        fontSize: 230,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 60,
                  )
                ],
              ),
              SizedBox(
                height: 100,
              ),
              FilledButton(
                  style: FilledButton.styleFrom(
                      fixedSize: Size(500, 200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  onPressed: () {
                    _mainStatusProvider.restartService = true;
                    PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                        .Posting(context);
                    Future.delayed(Duration(milliseconds: 500), () {
                      navPage(
                        context: context,
                        page: const TraySelectionSec(),
                      ).navPageToPage();
                    });
                  },
                  child: Text(
                    '서빙 재시작',
                    style: TextStyle(
                        height: 1.25,
                        letterSpacing: 5,
                        fontFamily: 'kor',
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
