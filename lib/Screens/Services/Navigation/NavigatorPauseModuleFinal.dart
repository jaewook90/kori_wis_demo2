import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ServingProgressFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/NavModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class NavigatorPauseModuleFinal extends StatefulWidget {
  final String? servGoalPose;

  const NavigatorPauseModuleFinal({
    this.servGoalPose,
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatorPauseModuleFinal> createState() =>
      _NavigatorPauseModuleFinalState();
}

class _NavigatorPauseModuleFinalState extends State<NavigatorPauseModuleFinal> {
  late MainStatusModel _statusProvider;
  late NetworkModel _networkProvider;

  late String backgroundImage;

  final String _audioFile = 'assets/voices/koriServingNavPause2nd.mp3';

  late AudioPlayer _audioPlayer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.mp3';

  late int buttonNumbers;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late double buttonRadius1;
  late double buttonRadius2;

  int buttonWidth = 0;
  int buttonHeight = 1;

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initAudio();
    Future.delayed(Duration(milliseconds: 500), () {
      _audioPlayer.play();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initAudio();
    //   Future.delayed(Duration(milliseconds: 500), () {
    //     _audioPlayer.play();
    //   });
    // });
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    backgroundImage = "assets/screens/Nav/koriZFinalServPauseNav.png";

    double screenWidth = 1080;

    buttonPositionWidth = [107, 107, 406, 705];
    buttonPositionHeight = [1311, 1501, 1501, 1501];

    buttonSize = [];
    buttonSize1 = [866, 160];
    buttonSize2 = [268, 205];

    buttonRadius1 = 40;
    buttonRadius2 = 32;

    buttonNumbers = buttonPositionHeight.length;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
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
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(
              children: [
                // Positioned(
                //   top: 500,
                //   left: 0,
                //   child: GestureDetector(
                //       onTap: () {
                //         navPage(
                //           context: context,
                //           page: const ServingProgressFinal(),
                //         ).navPageToPage();
                //       },
                //       child: Container(
                //           height: 800,
                //           width: 1080,
                //           decoration: const BoxDecoration(
                //               border: Border.fromBorderSide(BorderSide(
                //                   color: Colors.transparent, width: 1))))),
                // ),
                Positioned(
                    top: 372,
                    left: 460,
                    child: Container(
                      width: 300,
                      height: 90,
                      child: Text(
                        widget.servGoalPose == 'charging_pile'
                            ? '충전스테이션'
                            : widget.servGoalPose == 'wait'
                                ? '대기장소'
                                : '${widget.servGoalPose!}번 테이블',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                for (int i = 0; i < buttonNumbers; i++)
                  Positioned(
                    left: buttonPositionWidth[i],
                    top: buttonPositionHeight[i],
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  i == 0 ? buttonRadius1 : buttonRadius2)),
                          fixedSize: i == 0
                              ? Size(buttonSize1[buttonWidth],
                                  buttonSize1[buttonHeight])
                              : Size(buttonSize2[buttonWidth],
                                  buttonSize2[buttonHeight])),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.play();
                          if (i == 0) {
                            // 재시작 추가 필요
                            _audioPlayer.dispose();
                            PostApi(
                                url: startUrl,
                                endadr: rsmUrl,
                                keyBody: 'stop')
                                .Posting(context);
                            navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                            ).navPageToPage();
                            _statusProvider.playAd = false;
                          } else if (i == 1) {
                            // 충전하러가기 기능
                            PostApi(
                                url: startUrl,
                                endadr: chgUrl,
                                keyBody: 'charging_pile')
                                .Posting(context);
                            _networkProvider.currentGoal = '충전스테이션';
                            navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                            ).navPageToPage();
                            _statusProvider.playAd = false;
                          } else if (i == 2) {
                            // 추후에는 골 포지션 변경을 하며 자율주행 명령 추가
                            _statusProvider.playAd = false;
                          } else {
                            // 추후에는 거점으로 복귀
                            PostApi(
                                url: startUrl,
                                endadr: navUrl,
                                keyBody: 'wait')
                                .Posting(context);
                            _networkProvider.currentGoal = '충전스테이션';
                            navPage(
                              context: context,
                              page: const NavigatorProgressModuleFinal(),
                            ).navPageToPage();
                            _statusProvider.playAd = false;
                          }
                        });
                        // Future.delayed(Duration(milliseconds: 500), () {
                        //   if (i == 0) {
                        //     // 재시작 추가 필요
                        //     _audioPlayer.dispose();
                        //     PostApi(
                        //             url: startUrl,
                        //             endadr: rsmUrl,
                        //             keyBody: 'stop')
                        //         .Posting(context);
                        //     navPage(
                        //       context: context,
                        //       page: const NavigatorProgressModuleFinal(),
                        //     ).navPageToPage();
                        //     _statusProvider.playAd = false;
                        //   } else if (i == 1) {
                        //     // 충전하러가기 기능
                        //     PostApi(
                        //             url: startUrl,
                        //             endadr: chgUrl,
                        //             keyBody: 'charging_pile')
                        //         .Posting(context);
                        //     _networkProvider.currentGoal = '충전스테이션';
                        //     navPage(
                        //       context: context,
                        //       page: const NavigatorProgressModuleFinal(),
                        //     ).navPageToPage();
                        //     _statusProvider.playAd = false;
                        //   } else if (i == 2) {
                        //     // 추후에는 골 포지션 변경을 하며 자율주행 명령 추가
                        //     _statusProvider.playAd = false;
                        //   } else {
                        //     // 추후에는 거점으로 복귀
                        //     PostApi(
                        //             url: startUrl,
                        //             endadr: navUrl,
                        //             keyBody: 'wait')
                        //         .Posting(context);
                        //     _networkProvider.currentGoal = '충전스테이션';
                        //     navPage(
                        //       context: context,
                        //       page: const NavigatorProgressModuleFinal(),
                        //     ).navPageToPage();
                        //     _statusProvider.playAd = false;
                        //   }
                        // });
                      },
                      child: null,
                    ),
                  ),
                // const NavModuleButtonsFinal(screens: 1),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
