import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Screens/Services/ShippingAndDelivery/ShippingMain.dart';
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
  late String backGroundIMG;
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
    AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    backGroundIMG = 'assets/screens/koriServiceSelect.png';
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);


    return Container(
        padding: const EdgeInsets.only(top: 607),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 740,
              height: 362,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backGroundIMG), fit: BoxFit.fill)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('사용할 서비스를 선택하세요',
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
            Positioned(
              // left: 50,
              top: 180,
              child: SizedBox(
                width: 740,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(240, 100)),
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
                          navPage(context: context, page: TraySelectionSec()).navPageToPage();
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
                    FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: const Size(240, 100)),
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
                          navPage(context: context, page: ShippingMainScreen()).navPageToPage();
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
              ),
            ),
            // Positioned(
            //   left: 340,
            //   top: 180,
            //   child: FilledButton(
            //     style: FilledButton.styleFrom(
            //         enableFeedback: false,
            //         backgroundColor: Colors.transparent,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(0)),
            //         fixedSize: const Size(240, 100)),
            //     onPressed: () {
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //         _effectPlayer.seek(const Duration(seconds: 0));
            //         _effectPlayer.play();
            //         Navigator.pop(context);
            //       });
            //     },
            //     child: const Center(
            //       child: Text(
            //         '택배',
            //         style: TextStyle(
            //             fontFamily: 'kor',
            //             fontSize: 35,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
