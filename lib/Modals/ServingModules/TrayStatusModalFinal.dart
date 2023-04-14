import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

import '../../Providers/ServingModel.dart';

class TrayStatusModalFinal extends StatefulWidget {
  const TrayStatusModalFinal({Key? key})
      : super(key: key);

  @override
  State<TrayStatusModalFinal> createState() => _TrayStatusModalFinalState();
}

class _TrayStatusModalFinalState extends State<TrayStatusModalFinal> {

  late ServingModel _servingProvider;
  String trayStatusImg = 'assets/screens/Serving/koriZFinalTrayStatus.png';


  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextStyle? tableButtonFont = Theme.of(context).textTheme.headlineMedium;

    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.white)),),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1514,
          width: 993,
          child: Stack(
              children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(trayStatusImg)),
              ),
            ),
            Positioned(
                left: 1140,
                top: 195,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          // side: BorderSide(width: 1, color: Colors.white)
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                      _servingProvider.item1 = "";
                      _servingProvider.item2 = "";
                      _servingProvider.item3 = "";

                      print(_servingProvider.item1);
                      print(_servingProvider.item2);
                      print(_servingProvider.item3);
                    },
                    child: null,
                  ),
                )),
                ServingModuleButtonsFinal(screens: 4,),
          ]),
        ),
      ),
    );
  }
}


