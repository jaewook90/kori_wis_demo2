import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelection2.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class AdScreen extends StatefulWidget {
  final bool? patrolMode;

  const AdScreen({Key? key, this.patrolMode}) : super(key: key);

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late final List<String> advImages;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  late Timer _pwrTimer;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;
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

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
              Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();

      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      if (batData !=
          Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }

      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag =
          Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus =
          Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pwrTimer.cancel();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.patrolMode == false
          ? AppBar(
              title: const Text(''),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              actions: [
                SizedBox(
                  width: 1080,
                  height: 108,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 46,
                        top: 10,
                        child: FilledButton(
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const TraySelectionSec(),
                                ).navPageToPage();
                              });
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
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 46,
                        top: 60,
                        child: Text(('${batData.toString()} %')),
                      ),
                      Positioned(
                        right: 50,
                        top: 20,
                        child: Container(
                          height: 45,
                          width: 50,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/appBar/appBar_Battery.png',
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      EMGStatus == 0
                          ? const Positioned(
                              right: 35,
                              top: 15,
                              child: Icon(Icons.block,
                                  color: Colors.red,
                                  size: 80,
                                  grade: 200,
                                  weight: 200),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
              toolbarHeight: 110,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Stack(
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
    );
  }
}
