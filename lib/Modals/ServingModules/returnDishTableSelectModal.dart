import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDish.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class ReturnDishTableModal extends StatefulWidget {
  const ReturnDishTableModal({Key? key}) : super(key: key);

  @override
  State<ReturnDishTableModal> createState() => _ReturnDishTableModalState();
}

class _ReturnDishTableModalState extends State<ReturnDishTableModal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late String returnTable;
  late int serviceState;

  String tableSelectBG = 'assets/screens/Serving/KoriServingTableSelect.png';

  final String _audioFile = 'assets/voices/koriServingTableSelect.wav';

  late AudioPlayer _audioPlayer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  String positionURL = "";
  String hostAdr = "";

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;
  late double buttonRadius;

  late int buttonNumbers;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
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
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    hostAdr = _networkProvider.startUrl!;
    positionURL = _networkProvider.positionURL;

    buttonPositionWidth = [190, 190, 190, 190, 590, 590, 590, 590];
    buttonPositionHeight = [387, 723, 1044, 1368, 387, 723, 1044, 1368];

    buttonNumbers = buttonPositionHeight.length;

    buttonSize = [218, 124];

    buttonRadius = 0;

    return Dialog(
        backgroundColor: Colors.transparent,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide()),
        child: Stack(children: [
          Container(
            height: 1920,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(tableSelectBG), fit: BoxFit.cover),
            ),
          ),
          const Positioned(
              top: 150,
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
                              color: Colors.white)),
                    ),
                  ],
                ),
              )),
          Positioned(
              left: 855,
              top: 147,
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
                    setState(() {
                      _servingProvider.mainInit = true;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _effectPlayer.seek(const Duration(seconds: 0));
                      _effectPlayer.play();
                      Future.delayed(Duration(milliseconds: 230), () {
                        _effectPlayer.dispose();
                        _audioPlayer.dispose();
                        navPage(
                          context: context,
                          page: const TraySelectionFinal(),
                        ).navPageToPage();
                      });
                    });
                  },
                  child: null,
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
                          borderRadius: BorderRadius.circular(buttonRadius)),
                      fixedSize: Size(buttonSize[0], buttonSize[1])),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _effectPlayer.seek(const Duration(seconds: 0));
                      _effectPlayer.play();
                      setState(() {
                        returnTable = _networkProvider.getPoseData![i];
                        _servingProvider.returnTargetTable = returnTable;
                      });
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: returnTable)
                          .Posting(context);
                      Navigator.pop(context);
                      Future.delayed(Duration(milliseconds: 230), () {
                        _effectPlayer.dispose();
                        _audioPlayer.dispose();
                        navPage(
                          context: context,
                          page: const ReturnProgressModuleFinal(),
                        ).navPageToPage();
                      });
                    });
                  },
                  child: null,
                ))
        ]));
  }
}
