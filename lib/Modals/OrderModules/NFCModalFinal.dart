import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/ServingOrderReceiptModal.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomReceipt.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class NFCModuleScreenFinal extends StatefulWidget {
  const NFCModuleScreenFinal({Key? key}) : super(key: key);

  @override
  State<NFCModuleScreenFinal> createState() => _NFCModuleScreenFinalState();
}

class _NFCModuleScreenFinalState extends State<NFCModuleScreenFinal> {
  void showServingReceiptPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ServingOrderReceipt();
        });
  }

  late NetworkModel _networkProvider;
  String NFCimg = 'assets/images/koriZFinalNFC.webp';

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (_networkProvider.serviceState == 1) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          showServingReceiptPopup(context);
        } else if (_networkProvider.serviceState == 2) {
          navPage(context: context, page: HotelRoomReceipt(), enablePop: false)
              .navPageToPage();
        }
      },
      child: Container(
          padding: EdgeInsets.only(top: 100),
          child: Dialog(
            alignment: Alignment.topCenter,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 1401,
              width: 1072.5,
              decoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))
              ),
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(NFCimg)),
                  ),
                ),
                Positioned(
                    left: 53,
                    top: 35,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
                Positioned(
                    left: 890,
                    top: 35,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
              ]),
            ),
          )),
    );
  }
}
