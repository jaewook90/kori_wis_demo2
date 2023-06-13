import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class ItemOrderModalFinal extends StatefulWidget {
  const ItemOrderModalFinal({Key? key}) : super(key: key);

  @override
  State<ItemOrderModalFinal> createState() => _ItemOrderModalFinalState();
}

class _ItemOrderModalFinalState extends State<ItemOrderModalFinal> {
  late OrderModel _orderProvider;
  late BLEModel _bleProvider;

  String orderBookImg = 'assets/screens/Serving/koriZFinalOrderBook.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);

    setState(() {
      _orderProvider.SelectedQT = 0;
    });

    return Container(
      padding: const EdgeInsets.only(top: 100),
      color: Colors.transparent,
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1561,
          width: 992,
          child: Stack(children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(image: AssetImage(orderBookImg))),
              child: Container(),
            ),
            Positioned(
                left: 888,
                top: 30.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        _bleProvider.onTraySelectionScreen = true;
                      });
                      Navigator.pop(context);
                      // navPage(context: context, page: TrayEquipped(
                      //   characteristic: QualifiedCharacteristic(
                      //       characteristicId: Provider.of<BLEModel>(context, listen: false).trayDetectorCharacteristicId!,
                      //       serviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorServiceId!,
                      //       deviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId!),
                      // ), enablePop: false).navPageToPage();
                    },
                    child: null,
                  ),
                )),
            const OrderModuleButtonsFinal(screens: 0,)
          ]),
        ),
      ),
    );
  }
}