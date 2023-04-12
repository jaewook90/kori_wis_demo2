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
      child: Dialog(
        backgroundColor: Color(0xff000000),
        child: Stack(
            children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(trayStatusImg), fit: BoxFit.cover),
            ),
          ),
          Positioned(
              left: 1140 * 0.75,
              top: 195 * 0.75,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '테이블 선택 화면',
                style: TextStyle(
                    fontSize: 80, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}


