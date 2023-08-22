import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServiceSelectModal.dart';

class ShippingMainScreen extends StatefulWidget {
  const ShippingMainScreen({Key? key}) : super(key: key);

  @override
  State<ShippingMainScreen> createState() => _ShippingMainScreenState();
}

class _ShippingMainScreenState extends State<ShippingMainScreen> {

  void serviceSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ServiceSelectModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FilledButton(onPressed: (){
          serviceSelectPopup(context);
        }, child: null),
        Center(
          child: Text('택배 및 딜리버리 서비스 페이지',
              style: TextStyle(fontFamily: 'kor', fontSize: 160)),
        ),
      ]),
    );
  }
}
