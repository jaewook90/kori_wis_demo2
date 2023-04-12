import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';

class PaymentScreenFinal extends StatefulWidget {
  const PaymentScreenFinal({Key? key}) : super(key: key);

  @override
  State<PaymentScreenFinal> createState() => _PaymentScreenFinalState();
}

class _PaymentScreenFinalState extends State<PaymentScreenFinal> {

  String paymentBackground = 'assets/screens/Serving/koriZFinalSelectPayment.png';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        child: Dialog(
          backgroundColor: Color(0xff000000),
          child:
              Stack(children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(paymentBackground), fit: BoxFit.cover)),
                ),
                Positioned(
                    left: 80 * 0.75,
                    top: 215 * 0.75,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            // shape: RoundedRectangleBorder(
                            //     side: BorderSide(width: 1, color: Colors.white),
                            //     borderRadius: BorderRadius.circular(0))
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
                Positioned(
                    left: 1176 * 0.75,
                    top: 215 * 0.75,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            // shape: RoundedRectangleBorder(
                            //     side: BorderSide(width: 1, color: Colors.white),
                            //     borderRadius: BorderRadius.circular(0))
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
                Positioned(
                    left: 520 * 0.75,
                    top: 575 * 0.75,
                    child: Container(
                      width: 300,
                      height: 65,
                      color: Colors.transparent,
                      child: Text('11,500 원', style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 53,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),),
                    )),
                OrderModuleButtonsFinal(screens: 2,)
              ]),

        ));
  }
}
