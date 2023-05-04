import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';

class ShippingDestinationModalFinal extends StatefulWidget {
  const ShippingDestinationModalFinal({Key? key}) : super(key: key);

  @override
  State<ShippingDestinationModalFinal> createState() =>
      _ShippingDestinationModalFinalState();
}

class _ShippingDestinationModalFinalState
    extends State<ShippingDestinationModalFinal> {
  String itemSelectBG = 'assets/screens/Shipping/koriZFinalShippingList.png';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.8,
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(itemSelectBG), fit: BoxFit.fill)),
                ),
                Positioned(
                    left: 891.75,
                    top: 25.5,
                    child: Container(
                      width: 55,
                      height: 55,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
                const ShippingModuleButtonsFinal(
                  screens: 2,
                )
              ],
            ),
          )),
    );
  }
}
