import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/ETC/adScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigationPatrol.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceSelectModalFinal extends StatefulWidget {
  const ServiceSelectModalFinal({Key? key}) : super(key: key);

  @override
  State<ServiceSelectModalFinal> createState() =>
      _ServiceSelectModalFinalState();
}

class _ServiceSelectModalFinalState extends State<ServiceSelectModalFinal> {
  late MainStatusModel _mainStatusProvider;

  late SharedPreferences _prefs;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSharedPreferences();
    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
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
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          // alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 1080 * 0.8,
              height: 1920 * 0.7,
              color: Color.fromRGBO(24, 24, 24, 0.9),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('서비스 선택',
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
            Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  onPressed: () {
                    if(_mainStatusProvider.robotServiceMode == 0){
                      navPage(context: context, page: TraySelectionFinal())
                          .navPageToPage();
                    }else if(_mainStatusProvider.robotServiceMode == 1){
                      navPage(context: context, page: ShippingMenuFinal())
                          .navPageToPage();
                    }else if(_mainStatusProvider.robotServiceMode == 2){
                      navPage(context: context, page: FacilityScreen())
                          .navPageToPage();
                    }
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                  iconSize: 50,
                )),
            Positioned(
              // left: 50,
              top: 200,
              child: SizedBox(
                width: 1080 * 0.8,
                height: 1920 * 0.7 - 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff1b263b),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _prefs.setInt('robotMode', 0);
                              setState(() {
                                _mainStatusProvider.robotServiceMode =
                                    _prefs.getInt('robotMode');
                              });
                              Navigator.pop(context);
                              navPage(
                                      context: context,
                                      page: TraySelectionFinal())
                                  .navPageToPage();
                            });
                          },
                          child: const Center(
                            child: Text(
                              '서빙',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff1b263b),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _prefs.setInt('robotMode', 1);
                              setState(() {
                                _mainStatusProvider.robotServiceMode =
                                    _prefs.getInt('robotMode');
                              });
                              Navigator.pop(context);
                              navPage(
                                      context: context,
                                      page: ShippingMenuFinal())
                                  .navPageToPage();
                            });
                          },
                          child: const Center(
                            child: Text(
                              '택배',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff415a77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(const Duration(milliseconds: 230),
                                  () {
                                _effectPlayer.dispose();
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AdScreen(
                                              patrolMode: false,
                                            )));
                              });
                            });
                          },
                          child: const Center(
                            child: Text(
                              '사이니지',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff415a77),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const NavigationPatrol(),
                                ).navPageToPage();
                              });
                            });
                          },
                          child: const Center(
                            child: Text(
                              '패트롤',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff778da9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(const Duration(milliseconds: 230),
                                  () {
                                _effectPlayer.dispose();
                                showReturnSelectPopup(context);
                              });
                            });
                          },
                          child: const Center(
                            child: Text(
                              '퇴식',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: Color(0xff778da9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              fixedSize: const Size(
                                  1080 * 0.4 - 5, ((1920 * 0.7 - 220) / 3))),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _prefs.setInt('robotMode', 2);
                              Future.delayed(Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                setState(() {
                                  _mainStatusProvider.robotServiceMode = _prefs.getInt('robotMode');
                                });
                                navPage(
                                  context: context,
                                  page: const FacilityScreen(),
                                ).navPageToPage();
                              });
                            });
                          },
                          child: const Center(
                            child: Text(
                              '시설안내',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
