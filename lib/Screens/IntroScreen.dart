// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:video_player/video_player.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late NetworkModel _networkProvider;
  late BLEModel _bleProvider;

  final TextEditingController configController = TextEditingController();

  dynamic apiData;

  String positionURL = "";
  String hostAdr = "";

  // 블루투스 연결
  final String robotId = 'serv1';

  late bool robotInit;
  late bool navTrigger;

  // Ip주소, MicroBit주소, 서비스 상태등 데이터 저장을 위한 객체
  late SharedPreferences _prefs;

  // // 허스키 렌즈
  // late Uuid huskyCharacteristicId;
  // late Uuid huskyServiceId;
  // late String huskyDeviceId;
  //
  // 트레이
  late Uuid trayDetectorCharacteristicId;
  late Uuid trayDetectorServiceId;
  late String trayDetectorDeviceId;

  late VideoPlayerController _controller;
  late AudioPlayer _audioPlayer;

  final String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  bool updateComplete = false;

  late final AnimationController _textAniCon = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _textAniCon,
    curve: Curves.easeOut,
  );

  DateTime? currentBackPressTime;
  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";
  final String _audioFile = 'assets/voices/welcome.mp3';

  FToast? fToast;

  @override
  void initState() {
    super.initState();
    // _initSharedPreferences();
    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(false);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);

    // robotInit = false;
    navTrigger = true;

    fToast = FToast();
    fToast?.init(context);

    _playVideo();

    // _saveMicroBitData();

    // huskyCharacteristicId = Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    // huskyServiceId = Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    // huskyDeviceId = 'F0:52:FD:5C:8D:73';
    //
    trayDetectorCharacteristicId =
        Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    trayDetectorServiceId = Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');
    trayDetectorDeviceId = 'DF:75:E4:D6:32:63';
  }

  //
  // Future<void> _initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }
  //
  // Future<void> _saveMicroBitData() async {
  //   _prefs.setString('trayDetectorCharacteristicId', '6e400002-b5a3-f393-e0a9-e50e24dcca9e');
  //   _prefs.setString('trayDetectorServiceId', '6e400002-b5a3-f393-e0a9-e50e24dcca9e');
  //   _prefs.setString('trayDetectorDeviceId', 'DF:75:E4:D6:32:63');
  //   setState(() {
  //
  //   });
  // }
  //
  // Future<void> _saveIPData() async {
  //   _prefs.setString('robotIp', configController.text);  // 'myData' 키에 데이터 저장
  // }
  //
  // // 데이터를 로드하는 함수
  // Future<void> _loadData() async {
  //   Provider.of<NetworkModel>(context, listen: false).startUrl = _prefs.getString('robotIp'); // 'myData' 키에 저장된 데이터 로드
  //   final deviceId = _prefs.getString('trayDetectorDeviceId');
  //   final serviceId = _prefs.getString('trayDetectorServiceId');
  //   final characteristicId = _prefs.getString('trayDetectorCharacteristicId');
  //
  //   trayDetectorCharacteristicId =
  //       Uuid.parse(characteristicId!);
  //   trayDetectorServiceId = Uuid.parse(serviceId!);
  //   trayDetectorDeviceId = deviceId!;
  // }

  void _playVideo() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
    // 디버그 모드 + KORI 메인 디스플레이에서 비디오 실행시 필요
    // 빌드시 주석 처리 해도 됨
    await Future.delayed(const Duration(milliseconds: 500));
    _controller.play();
    _updateData();
  }

  void _playAudio() {
    _audioPlayer.setVolume(1);
    _audioPlayer.play();
  }

  // 추후 로딩 시 데이터 업데이트 및 로딩시 사용할 함수 현재는 임의로 2초의 시간 딜레이로 지정

  void _updateData() async {
    _networkProvider.hostIP();
    getting(_networkProvider.startUrl!, _networkProvider.positionURL!);
    // print('-------------VIDEO START-------------');
    Duration mediaDuration = _controller.value.duration;
    Duration introDuration = mediaDuration + const Duration(milliseconds: 2000);
    await Future.delayed(introDuration);
    // print('-------------VIDEO END-------------');
    _playAudio();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      updateComplete = true;
    });
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    print('apiAddress : $apiAddress');

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    _textAniCon.dispose();
    super.dispose();
  }

  var deviceId1 = "";

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    hostAdr = _networkProvider.startUrl!;
    positionURL = _networkProvider.positionURL;

    // getting(hostAdr, positionURL);

    double screenWidth = 1080;
    double screenHeight = 1920;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

    apiData = Provider.of<NetworkModel>(context, listen: false).getApiData;

    // _loadData();

    // 파이어 베이스 미 사용 시 트레이 데이터 입력
    _bleProvider.trayDetectorDeviceId = trayDetectorDeviceId;
    _bleProvider.trayDetectorCharacteristicId = trayDetectorCharacteristicId;
    _bleProvider.trayDetectorServiceId = trayDetectorServiceId;


    // 파이어 베이스 기반 아이피 등 정보 연동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (apiData != null && apiData != []) {
        setState(() {
          robotInit = true;
        });
        if (navTrigger != robotInit) {
          navPage(
              context: context,
              // BLE 미사용시
              page: const TraySelectionFinal(),
              // BLE 사용시
              // page: TrayEquipped(
              //   characteristic: QualifiedCharacteristic(
              //       characteristicId:
              //       _bleProvider.trayDetectorCharacteristicId!,
              //       serviceId: _bleProvider.trayDetectorServiceId!,
              //       deviceId: _bleProvider.trayDetectorDeviceId!),
              // ),
              enablePop: true)
              .navPageToPage();
          setState(() {
            navTrigger = robotInit;
          });
        }
      }else{
        setState(() {
          robotInit = false;
        });
      }
    });

    return WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (updateComplete == true) {
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
            return Future.value(true);
          }
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
          ),
          body: GestureDetector(
            // 스크린 터치시 화면 이동을 위한 위젯
            onTap: () {
              if (robotInit == true) {
                if (updateComplete == true) {
                  navPage(
                          context: context,
                          // BLE 미사용시
                          page: TraySelectionFinal(),
                          // BLE 사용시
                          // page: TrayEquipped(
                          //   characteristic: QualifiedCharacteristic(
                          //       characteristicId:
                          //           Provider.of<BLEModel>(context, listen: false)
                          //               .trayDetectorCharacteristicId!,
                          //       serviceId: Provider.of<BLEModel>(context, listen: false)
                          //           .trayDetectorServiceId!,
                          //       deviceId: Provider.of<BLEModel>(context, listen: false)
                          //           .trayDetectorDeviceId!),
                          // ),
                          enablePop: true)
                      .navPageToPage();
                }
              }
            },
            child: Center(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 108),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 1000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (updateComplete == true)
                                Stack(children: [
                                  Offstage(
                                    offstage: !robotInit,
                                    child: FadeTransition(
                                      opacity: _animation,
                                      child: Text("화면을 터치해 주세요",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ),
                                  ),
                                  Offstage(
                                      offstage: robotInit,
                                      child: Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'IP 입력',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    final String newStartUrl =
                                                        configController.text;
                                                    setState(() {
                                                      _networkProvider
                                                              .startUrl =
                                                          "http://${configController.text}/";
                                                      hostAdr = _networkProvider
                                                          .startUrl!;
                                                      configController.text =
                                                          '';
                                                      navTrigger = false;
                                                    });
                                                    getting(
                                                        hostAdr, positionURL);
                                                  },
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ),
                                                  style: FilledButton.styleFrom(
                                                      fixedSize: Size(100, 70),
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              80, 80, 255, 0.7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      )),
                                                ),
                                              ]),
                                          Container(
                                            width: 500,
                                            child: TextField(
                                              onTap: () {
                                                setState(() {
                                                  configController.text = '';
                                                });
                                              },
                                              controller: configController,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
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
                                          ),
                                        ],
                                      ))
                                ])
                              else
                                const SizedBox(),
                              SizedBox(
                                height: screenHeight * 0.4,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ));
  }
}
