import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/Services/Shipping/ShippingMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';

class ShippingNavDone extends StatefulWidget {
  const ShippingNavDone({Key? key}) : super(key: key);

  @override
  State<ShippingNavDone> createState() => _ShippingNavDoneState();
}

class _ShippingNavDoneState extends State<ShippingNavDone> {

  late String countDownPopup = 'assets/screens/Shipping/koriZFinalShippingDone.png';

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        child:AlertDialog(
          content: Stack(
              children: [Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(countDownPopup), fit: BoxFit.fill)),
                child: null,
              ),
                Positioned(
                  left: 0,
                  top: 192,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, color: Colors.redAccent),
                            borderRadius:
                            BorderRadius.circular(0)),
                        fixedSize: Size(724*0.75, 128*0.75)),
                    onPressed: (){
                      navPage(context: context, page: ShippingMenuFinal(), enablePop: false).navPageToPage();
                    },
                    child: null,
                  ),
                ),
              ]
          ),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
          // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
        )
    );
  }
}
