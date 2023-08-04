import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectTableModalFinal extends StatefulWidget {
  const SelectTableModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectTableModalFinal> createState() => _SelectTableModalFinalState();
}

class _SelectTableModalFinalState extends State<SelectTableModalFinal> {
  late ServingModel _servingProvider;

  String tableSelectBG = 'assets/screens/Serving/KoriServingTableSelect.png';

  final String _audioFile = 'assets/voices/koriServingTableSelect.mp3';

  late AudioPlayer _audioPlayer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initAudio();
    _audioPlayer.play();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 90),
      child: Dialog(
          backgroundColor: Colors.transparent,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide()),
          child: Stack(children: [
            Container(
              height: 1536,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(tableSelectBG), fit: BoxFit.cover),
              ),
            ),
            const Positioned(
              top: 15,
                child: SizedBox(
                  width: 1080,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 80),
                        child: Text('테이블을 선택하세요',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 35,
                          color: Colors.white
                        )),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 836,
                top: 18,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        if (_servingProvider.trayCheckAll == true) {
                          setState(() {
                            _servingProvider.mainInit = true;
                          });
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();
                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });
                        } else {
                          if ((_servingProvider.table1 == "" &&
                              _servingProvider.table2 == "") &&
                              _servingProvider.table3 == "") {
                            setState(() {
                              _servingProvider.mainInit = true;
                            });
                          }
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();

                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });
                        }
                        _servingProvider.item1 = "";
                        _servingProvider.item2 = "";
                        _servingProvider.item3 = "";(context);
                      });
                    },
                    child: null,
                  ),
                )),
            const ServingModuleButtonsFinal(
              screens: 2,
            ),
          ])),
    );
  }
}
