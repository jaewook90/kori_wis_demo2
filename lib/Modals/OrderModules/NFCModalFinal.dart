import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/ServingOrderReceiptModal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/HotelServiceRoomReceipt.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class NFCModuleScreenFinal extends StatefulWidget {
  const NFCModuleScreenFinal({Key? key}) : super(key: key);

  @override
  State<NFCModuleScreenFinal> createState() => _NFCModuleScreenFinalState();
}

class _NFCModuleScreenFinalState extends State<NFCModuleScreenFinal> {
  late OrderModel _orderProvider;
  void showServingReceiptPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ServingOrderReceipt();
        });
  }

  late MainStatusModel _statusProvider;
  String nfcImg = 'assets/images/koriZFinalNFC.jpg';

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    return GestureDetector( // 추후 제스쳐 터치가 아닌 NFC 신호 수신시로 변경
      onTap: () {
        if (_statusProvider.serviceState == 1) {
          // 서빙 상품 주문 영수증
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          showServingReceiptPopup(context);
        } else if (_statusProvider.serviceState == 2) {
          // 호텔 체크인 영수증
          navPage(context: context, page: HotelRoomReceipt(), enablePop: false)
              .navPageToPage();
          _orderProvider.roomReserveNum = '22042030001KORI';
          _orderProvider.roomReserveContact = '010-0000-0000';
          _orderProvider.roomReserveName = '이정근';
          _orderProvider.roomReserveDiscount = '0';
        }
      },
      child: Container(
          padding: const EdgeInsets.only(top: 100),
          child: Dialog(
            alignment: Alignment.topCenter,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 1401,
              width: 1072.5,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(30, 30, 30, 1),
                  border: const Border.fromBorderSide(
                      BorderSide(color: Colors.transparent, width: 1)),
              borderRadius: BorderRadius.circular(50)),
              child: Stack(children: [
                Positioned(
                  top: 100,
                  child: Container(
                    height: 1301,
                    width: 1072.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(nfcImg), fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 18,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(80, 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                Positioned(
                    left: 885,
                    top: 2,
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.transparent,
                      child: IconButton(
                        color: Colors.white,
                        iconSize: 90,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.clear)),
                    )),
              ]),
            ),
          )),
    );
  }
}
