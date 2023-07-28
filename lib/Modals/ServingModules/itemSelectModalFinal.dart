import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/ServingModules/tableSelectModalFinal.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectItemModalFinal extends StatefulWidget {
  const SelectItemModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectItemModalFinal> createState() => _SelectItemModalFinalState();
}

class _SelectItemModalFinalState extends State<SelectItemModalFinal> {
  late ServingModel _servingProvider;

  String itemSelectBG = 'assets/screens/Serving/koriZFinalItemSelect.png';

  final String _audioFile = 'assets/voices/koriServingItemSelect2nd.mp3';

  late AudioPlayer _audioPlayer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.mp3';

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;

  late int buttonNumbers;

  List<String> menuItems = ['햄버거', '라면', '치킨', '핫도그'];

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

  void showTableSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const SelectTableModalFinal();
        });
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
    super.dispose();
    _effectPlayer.dispose();
    _audioPlayer.dispose();
    print('dispose item!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    buttonPositionWidth = [70.3, 517.3, 70.3, 517.3];
    buttonPositionHeight = [315.8, 315.8, 759, 759];

    buttonNumbers = buttonPositionHeight.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 90, 0, 180),
      height: 1536,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                height: 1536,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(image: AssetImage(itemSelectBG))),
              ),
              // 아이템 선택 종료 X버튼
              Positioned(
                  left: 880,
                  top: 23,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        setState(() {
                          _servingProvider.mainInit = true;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.play();
                          setState(() {
                            _servingProvider.item1 = "";
                            _servingProvider.item2 = "";
                            _servingProvider.item3 = "";
                          });
                          navPage(context: context, page: TraySelectionFinal())
                              .navPageToPage();
                        });
                        // Future.delayed(Duration(milliseconds: 500), () {
                        //   setState(() {
                        //     _servingProvider.item1 = "";
                        //     _servingProvider.item2 = "";
                        //     _servingProvider.item3 = "";
                        //   });
                        //   navPage(context: context, page: TraySelectionFinal())
                        //       .navPageToPage();
                        // });
                      },
                      child: null,
                    ),
                  )),
              // 상품 버튼
              for (int i = 0; i < buttonNumbers; i++)
                Positioned(
                    left: buttonPositionWidth[i],
                    top: buttonPositionHeight[i],
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          enableFeedback: false,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34)),
                          fixedSize: Size(412, 412)),
                      onPressed: () {
                        _audioPlayer.dispose();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.play();
                          setState(() {
                            _servingProvider.menuItem = menuItems[i];
                          });
                          showTableSelectPopup(context);
                        });
                        // Future.delayed(Duration(milliseconds: 500), () {
                        //   setState(() {
                        //     _servingProvider.menuItem = menuItems[i];
                        //   });
                        //   showTableSelectPopup(context);
                        // });
                      },
                      child: null,
                    )),
              // const ServingModuleButtonsFinal(
              //   screens: 1,
              // ),
            ],
          )),
    );
  }
}
