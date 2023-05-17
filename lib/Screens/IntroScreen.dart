import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

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

  String positionURL = "";
  String hostAdr = "";

  late VideoPlayerController _controller;
  late AudioPlayer _audioPlayer;

  String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

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
    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(false);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    _audioPlayer = AudioPlayer()..setAsset(_audioFile);

    fToast = FToast();
    fToast?.init(context);

    _playVideo();
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
    _audioPlayer.setVolume(1);
    _audioPlayer.play();
  }

  // 추후 로딩 시 데이터 업데이트 및 로딩시 사용할 함수 현재는 임의로 2초의 시간 딜레이로 지정

  void _updateData() async {
    // print('-------------VIDEO START-------------');
    Duration mediaDuration = _controller.value.duration;
    Duration introDuration = mediaDuration + const Duration(milliseconds: 2000);
    await Future.delayed(introDuration);
    // print('-------------VIDEO END-------------');
    _playAudio();
    await Future.delayed(const Duration(milliseconds: 500));
    _networkProvider.hostIP();
    setState(() {
      updateComplete = true;
    });
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    navPage(
        context: context,
        page: MainScreenFinal(
          parsePoseData: getApiData,
        ),
        enablePop: true)
        .navPageToPage();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    _textAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    hostAdr = _networkProvider.startUrl;
    positionURL = _networkProvider.positionURL;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

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
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 35
                            ),
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
      child: GestureDetector(
        // 스크린 터치시 화면 이동을 위한 위젯
        onTap: () {
          updateComplete == true ? getting(hostAdr, positionURL) : null;
        },
        child: Center(
          child: Scaffold(
            body: Stack(children: [
              Column(
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
                              aspectRatio: _controller.value.aspectRatio,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (updateComplete == true)
                        FadeTransition(
                          opacity: _animation,
                          child: Text("화면을 터치해 주세요",
                              style: Theme.of(context).textTheme.titleLarge),
                        )
                      else
                        const SizedBox(),
                      SizedBox(
                        height: screenHeight * 0.4,
                      )
                    ],
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
