import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class AppBarAction extends StatefulWidget {
  final bool? homeButton;
  final String? screenName;

  const AppBarAction({Key? key, this.screenName, this.homeButton})
      : super(key: key);

  @override
  State<AppBarAction> createState() => _AppBarActionState();
}

class _AppBarActionState extends State<AppBarAction> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';
  late AudioPlayer _audioPlayer;
  late String _audioFile;

  late bool mainTTSPlay;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mainTTSPlay = Provider.of<MainStatusModel>(context, listen: false).mainSoundMute!;

    if (widget.screenName == 'ServingProgress') {
      if (Provider.of<ServingModel>(context, listen: false).tray1 == true) {
        _audioFile = 'assets/voices/koriServingNavDoneTray1.wav';
      } else {
        if (Provider.of<ServingModel>(context, listen: false).tray2 == true) {
          _audioFile = 'assets/voices/koriServingNavDoneTray2.wav';
        } else {
          if (Provider.of<ServingModel>(context, listen: false).tray3 == true) {
            _audioFile = 'assets/voices/koriServingNavDoneTray3.wav';
          } else {
            _audioFile = 'assets/voices/koriServingNavDone.wav';
          }
        }
      }
    } else if (widget.screenName == 'ReturnPause') {
      _audioFile = 'assets/voices/koriServingNavPause.wav';
    } else if (widget.screenName == 'ReturnProgress') {
      _audioFile = 'assets/sounds/sound_moving_bg.wav';
    } else if (widget.screenName == 'Patrolling') {
      _audioFile = 'assets/sounds/sound_moving_bg.wav';
    } else if (widget.screenName == 'NavigationProgress') {
      _audioFile = 'assets/sounds/sound_moving_bg.wav';
    } else if (widget.screenName == 'NavigationPause') {
      _audioFile = 'assets/voices/koriServingNavPause.wav';
    } else if (widget.screenName == 'Docking') {
      _audioFile = 'assets/sounds/docking.wav';
    } else if (widget.screenName == 'Charging') {
      _audioFile = 'assets/sounds/dock3.wav';
    } else {
      _audioFile = "";
    }

    _initAudio();
    if (widget.screenName != null) {
      if(widget.screenName != 'Shipping'){
        Future.delayed(const Duration(seconds: 1), () {
          _audioPlayer.play();
        });
      }
    }
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
    if (widget.screenName != null) {
      if(widget.screenName != "Shipping"){
        _audioPlayer = AudioPlayer()..setAsset(_audioFile);
        _audioPlayer.setVolume(1);
        if(_audioFile == 'assets/sounds/sound_moving_bg.wav' || _audioFile == 'assets/sounds/docking.wav'){
          _audioPlayer.setLoopMode(LoopMode.all);
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
    if (widget.screenName != null) {
      if (widget.screenName != "Shipping"){
        _audioPlayer.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    return Stack(children: [
      widget.homeButton == true
          ? Positioned(
              left: 50,
              top: 10,
              child: FilledButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (widget.screenName == "Charging") {
                        _mainStatusProvider.restartService = true;
                        PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                            .Posting(context);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          navPage(
                            context: context,
                            page: const TraySelectionFinal(),
                          ).navPageToPage();
                        });
                      } else if (widget.screenName == 'Adv') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            Navigator.pop(context);
                          });
                        });
                      } else if(widget.screenName == 'Shipping'){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            navPage(context: context, page: const ShippingMenuFinal()).navPageToPage();
                          });
                        });
                      } else if (widget.screenName == 'facilityList'){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            navPage(context: context, page: const FacilityScreen()).navPageToPage();
                          });
                        });
                      }
                      else {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        if (widget.screenName != null) {
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            _audioPlayer.dispose();
                            navPage(
                              context: context,
                              page: const TraySelectionFinal(),
                            ).navPageToPage();
                          });
                        } else {
                          navPage(
                            context: context,
                            page: const TraySelectionFinal(),
                          ).navPageToPage();
                        }
                      }
                    });
                  },
                  style: FilledButton.styleFrom(
                      enableFeedback: false,
                      fixedSize: const Size(90, 90),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Colors.transparent),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Home.png',
                              ),
                              fit: BoxFit.fill)))))
          : Container(),
    ]);
  }
}
