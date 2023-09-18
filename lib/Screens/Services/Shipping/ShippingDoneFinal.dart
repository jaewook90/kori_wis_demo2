import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class ShippingDoneFinal extends StatefulWidget {
  const ShippingDoneFinal({Key? key}) : super(key: key);

  @override
  State<ShippingDoneFinal> createState() => _ShippingDoneFinalState();
}

class _ShippingDoneFinalState extends State<ShippingDoneFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  String backgroundImage = "assets/screens/Shipping/koriZFinalShippingDone.png";

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            AppBarStatus(),
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage), fit: BoxFit.cover)),
              child: Stack(children: [
                Positioned(
                  left: 107.3,
                  top: 1372.5,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        fixedSize: const Size(866, 160)),
                    child: null,
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        _networkProvider.servTable =
                            _servingProvider.targetTableNum;
                        print(_servingProvider.targetTableNum);
                        PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody: _servingProvider.targetTableNum)
                            .Posting(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Future.delayed(const Duration(milliseconds: 230),
                                  () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const NavigatorProgressModuleFinal(),
                                ).navPageToPage();
                              });
                        });
                      });
                    },
                  ),
                ),
                // const ShippingModuleButtonsFinal(
                //   screens: 3,
                // )
              ])),
        ));
  }
}
