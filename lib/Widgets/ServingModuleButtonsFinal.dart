import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class ServingModuleButtonsFinal extends StatefulWidget {
  final int? screens;

  const ServingModuleButtonsFinal({
    Key? key,
    this.screens,
  }) : super(key: key);

  @override
  State<ServingModuleButtonsFinal> createState() =>
      _ServingModuleButtonsFinalState();
}

class _ServingModuleButtonsFinalState extends State<ServingModuleButtonsFinal> {
  late ServingModel _servingProvider;
  late NetworkModel _networkProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  int itemNumber = 0;
  String? itemName;

  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  late List<List> itemImagesList;
  late List<String> itemImages;

  late String targetTableNum;

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initAudio();

    hamburger = "assets/images/serving_item_imgs/hamburger.png";
    hotDog = "assets/images/serving_item_imgs/hotDog.png";
    chicken = "assets/images/serving_item_imgs/chicken.png";
    ramyeon = "assets/images/serving_item_imgs/ramyeon.png";

    currentGoal = "";

    itemImages = [hamburger, hotDog, chicken, ramyeon];
    itemImagesList = [itemImages, itemImages, itemImages];
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const NavCountDownModalFinal();
        });
  }

  void uploadTableNumberNItemImg() {
    if (_servingProvider.tray1Select == true) {
      setState(() {
        _servingProvider.itemImageList![0] = itemImagesList[0][itemNumber];
        _servingProvider.servedItem1 = false;
      });
    } else if (_servingProvider.tray2Select == true) {
      setState(() {
        _servingProvider.itemImageList![1] = itemImagesList[1][itemNumber];
        _servingProvider.servedItem2 = false;
      });
    } else if (_servingProvider.tray3Select == true) {
      setState(() {
        _servingProvider.itemImageList![2] = itemImagesList[2][itemNumber];
        _servingProvider.servedItem3 = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    // 서빙 타겟 테이블 번호
    if (_servingProvider.targetTableNum != null) {
      targetTableNum = _servingProvider.targetTableNum!;
    }

    // 트레이 상품 정의
    itemName = _servingProvider.menuItem;

    if (widget.screens == 2) {
      // 서빙 테이블 선택 화면
      buttonPositionWidth = [205, 205, 205, 205, 585, 585, 585, 585];
      buttonPositionHeight = [
        245.5,
        565.6,
        870.7,
        1178,
        245.5,
        565.6,
        870.7,
        1178
      ];

      buttonSize = [208, 118];

      buttonRadius = 0;
    } else if (widget.screens == 3) {
      // 완료 화면
      buttonPositionWidth = [107.3];
      buttonPositionHeight = [1372.5];

      buttonSize = [866, 160];

      buttonRadius = 40;
    }

    buttonNumbers = buttonPositionHeight.length;

    if (_servingProvider.trayCheckAll == false) {
      if (itemName == '햄버거') {
        itemNumber = 0;
      } else if (itemName == '핫도그') {
        itemNumber = 1;
      } else if (itemName == '치킨') {
        itemNumber = 2;
      } else if (itemName == '라면') {
        itemNumber = 3;
      } else {
        itemNumber.isNaN;
      }
    }

    return Stack(children: [
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
                fixedSize:
                    Size(buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 2
                ? () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _effectPlayer.seek(Duration(seconds: 0));
                      _effectPlayer.play();
                      setState(() {
                        if (_servingProvider.trayCheckAll == false) {
                          if (_servingProvider.tray1Select == true) {
                            _servingProvider.table1 = "${i + 1}";
                            _servingProvider.tray1 = true;
                          } else if (_servingProvider.tray2Select == true) {
                            _servingProvider.table2 = "${i + 1}";
                            _servingProvider.tray2 = true;
                          } else {
                            _servingProvider.table3 = "${i + 1}";
                            _servingProvider.tray3 = true;
                          }
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            uploadTableNumberNItemImg();
                            navPage(
                              context: context,
                              page: const TraySelectionSec(),
                            ).navPageToPage();
                          });
                        } else {
                          _servingProvider.allTable = '${i + 1}';
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            showCountDownPopup(context);
                          });
                        }
                      });
                    });
                  }
                : widget.screens == 3
                    ? () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(Duration(seconds: 0));
                          _effectPlayer.play();
                          PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: _servingProvider.waitingPoint)
                              .Posting(context);
                          Future.delayed(Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            navPage(
                              context: context,
                              page: const TraySelectionSec(),
                            ).navPageToPage();
                          });
                        });
                      }
                    : null,
            child: null,
          ),
        ),
    ]);
  }
}
