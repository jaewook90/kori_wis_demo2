import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
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
  late ServingModel _servingProvider;

  final TextEditingController configController = TextEditingController();
  late SharedPreferences _prefs;

  dynamic apiData;

  String positionURL = "";
  String hostAdr = "";

  // 블루투스 연결
  final String robotId = 'serv1';

  late bool robotInit;
  late bool navTrigger;

  late bool skipIntro;
  late bool playingVideo;

  late Duration mediaDuration;

  late VideoPlayerController _controller;
  late AudioPlayer _audioPlayer;

  final String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

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
  final String _audioFile = 'assets/voices/koriServingIntro.wav';

  FToast? fToast;

  @override
  void initState() {
    super.initState();
    skipIntro = false;
    playingVideo = true;
    _initSharedPreferences();
    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(false);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    navTrigger = true;

    fToast = FToast();
    fToast?.init(context);

    _initAudio();
    _playVideo();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _audioPlayer.setVolume(1);
    _effectPlayer.setVolume(0.4);
  }

  // SharedPreferences 초기화 함수
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

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
    _audioPlayer.play();
  }

  // 추후 로딩 시 데이터 업데이트 및 로딩시 사용할 함수 현재는 임의로 2초의 시간 딜레이로 지정

  void _updateData() async {
    if (_prefs.getString('robotIp') != null) {
      _networkProvider.startUrl = _prefs.getString('robotIp');
    }
    if(_prefs.getBool('robotInit')==null){
      robotInit = false;
    }else{
      robotInit = _prefs.getBool('robotInit')!;
    }
    print('-----------------robotInit---------------------');
    print(robotInit);
    _networkProvider.hostIP();
    getting(_networkProvider.startUrl!, _networkProvider.positionURL);
    mediaDuration = _controller.value.duration;
    Duration introDuration = mediaDuration + const Duration(milliseconds: 2000);
    await Future.delayed(introDuration);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio();
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      updateComplete = true;
      playingVideo = false;
    });
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _textAniCon.dispose();
    super.dispose();
  }

  var deviceId1 = "";

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    hostAdr = _networkProvider.startUrl!;
    positionURL = _networkProvider.positionURL;

    double screenWidth = 1080;
    double screenHeight = 1920;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

    apiData = Provider.of<NetworkModel>(context, listen: false).getApiData;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navTrigger == false) {
        getting(_networkProvider.startUrl!, _networkProvider.positionURL);
        if (apiData != null && apiData != []) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _audioPlayer.stop();
          });
          setState(() {
            navTrigger = true;
            _servingProvider.mainInit = true;
          });
          _effectPlayer.dispose();
          _audioPlayer.dispose();
          Future.delayed(const Duration(milliseconds: 50), () {
            navPage(
              context: context,
              page: const TraySelectionFinal(),
            ).navPageToPage();
          });
        } else {
          setState(() {
            navTrigger = true;
          });
        }
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
            onTap: () async {
              if(playingVideo == false){
                if (updateComplete == true) {
                  if (_prefs.getString('robotIp') == null) {
                    setState(() {
                      robotInit = false;
                    });
                  } else {
                    getting(
                        _networkProvider.startUrl!, _networkProvider.positionURL);
                    if (apiData != null && apiData != []) {
                      setState(() {
                        navTrigger = true;
                        _servingProvider.mainInit = true;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _audioPlayer.stop();
                      });
                      _effectPlayer.dispose();
                      _audioPlayer.dispose();
                      Future.delayed(const Duration(milliseconds: 50), () {
                        navPage(
                          context: context,
                          page: const TraySelectionFinal(),
                        ).navPageToPage();
                      });
                    } else {
                      setState(() {
                        robotInit = false;
                        navTrigger = true;
                      });
                    }
                  }
                }
              }else if(playingVideo == true && robotInit == true){
                _controller.seekTo(mediaDuration);
                Future.delayed(const Duration(milliseconds: 500), () {
                  _audioPlayer.play();
                });
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {
                  updateComplete = true;
                  playingVideo = false;
                });
              }
            },
            child: Center(
              child: SingleChildScrollView(
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
                    padding: const EdgeInsets.only(top: 1050),
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
                                              const SizedBox(
                                                width: 150,
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _effectPlayer.play();
                                                    _prefs.setString('robotIp',
                                                        configController.text);
                                                    _prefs.setBool('robotInit', !robotInit);
                                                    setState(() {
                                                      _networkProvider
                                                              .startUrl =
                                                          _prefs.getString(
                                                              'robotIp');
                                                      _networkProvider.hostIP();
                                                      navTrigger = false;
                                                    });
                                                  });
                                                },
                                                style: FilledButton.styleFrom(
                                                    enableFeedback: false,
                                                    fixedSize:
                                                        const Size(100, 70),
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
                                                  size: 50,
                                                ),
                                              ),
                                            ]),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                          width: 400,
                                          child: TextField(
                                            controller: configController,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(),
                                            decoration: InputDecoration(
                                              fillColor: const Color.fromRGBO(
                                                  30, 30, 30, 0.5),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20,
                                                      top: 10,
                                                      bottom: 10),
                                            ),
                                            showCursor: true,
                                            cursorColor: Colors.white,
                                            onSubmitted: (value) {
                                              _prefs.setString(
                                                  'robotIp', value);
                                              _prefs.setBool('robotInit', !robotInit);
                                              setState(() {
                                                _networkProvider.startUrl =
                                                    _prefs.getString('robotIp');
                                                _networkProvider.hostIP();
                                                navTrigger = false;
                                              });
                                            },
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
        ));
  }
}
