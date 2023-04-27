import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class PaymentScreenFinal extends StatefulWidget {
  const PaymentScreenFinal({Key? key}) : super(key: key);

  @override
  State<PaymentScreenFinal> createState() => _PaymentScreenFinalState();
}

class _PaymentScreenFinalState extends State<PaymentScreenFinal> {
  late NetworkModel _networkProvider;
  late OrderModel _orderProvider;

  String paymentBackground =
      'assets/screens/Serving/koriZFinalSelectPayment.png';

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.only(top: 100),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 1401,
            width: 992,
            child: Stack(children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(paymentBackground),
                        alignment: Alignment.topCenter)),
              ),
              Positioned(
                  left: 52,
                  top: 31,
                  child: Container(
                    width: 48,
                    height: 48,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: null,
                    ),
                  )),
              Positioned(
                  left: 888,
                  top: 31,
                  child: Container(
                    width: 48,
                    height: 48,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {
                        if (_networkProvider.serviceState == 2) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      child: null,
                    ),
                  )),
              Stack(children: [
                Positioned(
                    left: 370,
                    top: 315.5,
                    child: Container(
                      width: 230,
                      height: 65,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _networkProvider.serviceState == 1
                                ? '${_orderProvider.orderedTotalPrice}'
                                : '${_orderProvider.orderedRoomPrice}',
                            style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 53,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    left: 600,
                    top: 315.5,
                    child: Container(
                      width: 55,
                      height: 65,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '원',
                            style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 53,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
              OrderModuleButtonsFinal(
                screens: 2,
              )
            ]),
          ),
        ));
  }
}
