import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';

class AdScreen extends StatefulWidget {
  final bool? patrolMode;

  const AdScreen({Key? key, this.patrolMode}) : super(key: key);

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late final List<String> advImages;

  late Timer _timer;

  late bool adVoiceOnOff;

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/Ad/daechan.wav';

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.patrolMode == false){
      adVoiceOnOff = false;
    }else{
      adVoiceOnOff = true;
    }
    advImages = [
      "assets/images/adPics/daechan/ad1.png",
      "assets/images/adPics/daechan/ad2.png",
      "assets/images/adPics/daechan/ad3.png",
      "assets/images/adPics/daechan/ad4.png",
      "assets/images/adPics/daechan/ad5.png",
      "assets/images/adPics/daechan/ad6.png",
      "assets/images/adPics/daechan/ad7.png",
    ];
    _initAudio();

    _timer = Timer.periodic(const Duration(seconds:30), (timer) {
      _audioPlayer.seek(const Duration(seconds: 0));
    });
  }

  void _initAudio() async {
    // AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _audioPlayer.setVolume(1);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _audioPlayer.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(milliseconds: 100), () {
      if (adVoiceOnOff == true) {
        if(_audioPlayer.playing != true){
          _audioPlayer.seek(const Duration(seconds: 0));
          _audioPlayer.play();
        }
      } else {
        _audioPlayer.stop();
      }
    });

    return Scaffold(
      appBar: widget.patrolMode == false
          ? AppBar(
              title:  Text(''),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              actions:  [
                Offstage(
                  offstage: adVoiceOnOff,
                  child: SizedBox(
                    width: 1080,
                    height: 108,
                    child: Stack(
                      children: [
                        AppBarAction(homeButton: true),
                        AppBarStatus(),
                      ],
                    ),
                  ),
                )
              ],
              toolbarHeight: 110,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: (){
          if(adVoiceOnOff == false){
            setState(() {
              adVoiceOnOff = true;
            });
          }else{
            {
              setState(() {
                adVoiceOnOff = false;
              });
            }
          }
        },
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                      child: Image.asset(
                    advImages[index],
                    fit: BoxFit.cover,
                  ));
                },
                itemCount: advImages.length,
                autoplay: true,
                autoplayDelay: 8000,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomRight,
                    builder: FractionPaginationBuilder(
                        color: Colors.white,
                        fontSize: 20,
                        activeColor: Colors.white,
                        activeFontSize: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
