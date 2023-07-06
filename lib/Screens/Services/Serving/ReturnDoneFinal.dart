import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/getAPI.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';


class ReturnDoneScreen extends StatefulWidget {
  const ReturnDoneScreen({Key? key}) : super(key: key);

  @override
  State<ReturnDoneScreen> createState() => _ReturnDoneScreenState();
}

class _ReturnDoneScreenState extends State<ReturnDoneScreen> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late BLEModel _bleProvider;

  String backgroundImage = "assets/screens/Serving/koriZFinalReturn.png";
  String? startUrl;
  String? navUrl;

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);
    
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    left: 120,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const TrayEquipped(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      style: FilledButton.styleFrom(
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
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: Stack(children: [
              Positioned(
                top: 450,
                left: 0,
                child: GestureDetector(
                    onTap: () {
                        print('Serving Return to waiting point');
                        PostApi(
                            url: startUrl,
                            endadr: navUrl,
                            keyBody:
                            _servingProvider.waitingPoint)
                            .Posting(context);
                        navPage(
                            context: context,
                            page: TrayEquipped(
                              characteristic: QualifiedCharacteristic(
                                  characteristicId: Provider.of<BLEModel>(context, listen: false).trayDetectorCharacteristicId!,
                                  serviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorServiceId!,
                                  deviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId!),
                            ),
                            enablePop: false)
                            .navPageToPage();

                    },
                    child: Container(
                        height: 1200,
                        width: 1080,
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.transparent, width: 1))))),
              ),
              Container(
                child: const ServingModuleButtonsFinal(screens: 4),
              ),
            ])));
  }
}