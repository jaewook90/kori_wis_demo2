import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class PaymentScreenFinal extends StatefulWidget {
  const PaymentScreenFinal({Key? key}) : super(key: key);

  @override
  State<PaymentScreenFinal> createState() => _PaymentScreenFinalState();
}

class _PaymentScreenFinalState extends State<PaymentScreenFinal> {
  late MainStatusModel _statusProvider;
  late OrderModel _orderProvider;
  late BLEModel _bleProvider;

  String paymentBackground =
      'assets/screens/Serving/koriZFinalSelectPayment.png';

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);


    return Container(
        padding: const EdgeInsets.only(top: 100),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 1401,
            width: 992,
            child: Stack(children: [
              Container(
                width: 1080,
                height: 1920,
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
                        if (_statusProvider.serviceState == 2) {
                          Navigator.pop(context);
                        } else {
                          navPage(context: context, page: TrayEquipped(
                            characteristic: QualifiedCharacteristic(
                                characteristicId: Provider.of<BLEModel>(context, listen: false).trayDetectorCharacteristicId!,
                                serviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorServiceId!,
                                deviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId!),
                          ), enablePop: false).navPageToPage();
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
                            _statusProvider.serviceState == 1
                            // 서빙 주문 총액
                                ? '${_orderProvider.orderedTotalPrice}'
                            // 체크인 방 금액
                                : '${_orderProvider.orderedRoomPrice}',
                            style: const TextStyle(
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
                      child: const Row(
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
              const OrderModuleButtonsFinal(
                screens: 2,
              )
            ]),
          ),
        ));
  }
}
