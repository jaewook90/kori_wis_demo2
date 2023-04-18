import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/MenuButtons.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';

// ------------------------------ 보류 ---------------------------------------

class ServingOrderReceipt extends StatefulWidget {
  ServingOrderReceipt({Key? key}) : super(key: key);

  @override
  State<ServingOrderReceipt> createState() => _ServingOrderReceiptState();
}

class _ServingOrderReceiptState extends State<ServingOrderReceipt> {

  String backgroundImage = "assets/screens/Serving/koriZFinalOrderReceipt.png";

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1561,
          width: 992,
          child: Stack(children: [
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                  image: DecorationImage(image: AssetImage(backgroundImage))),
              child: Container(),
            ),
            OrderModuleButtonsFinal(screens: 3,)
          ]),
        ),
      ),
    );
  }
}
