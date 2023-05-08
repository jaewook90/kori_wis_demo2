import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Hotel/BellBoy/BellBoyServiceMenuFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class BellBoyYNModalFinal extends StatefulWidget {
  const BellBoyYNModalFinal({Key? key}) : super(key: key);

  @override
  State<BellBoyYNModalFinal> createState() => _BellBoyYNModalFinalState();
}

class _BellBoyYNModalFinalState extends State<BellBoyYNModalFinal> {
  late NetworkModel _networkProvider;

  late String countDownPopup;

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    countDownPopup = 'assets/screens/Hotel/koriZFinalBellBoyPop.png';

    return Container(
        padding: const EdgeInsets.only(top: 607),
        child:AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(
              children: [
                Container(
                  width: 740,
                  height: 362,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(countDownPopup), fit: BoxFit.fill)),
                  child: null,
                ),
                Positioned(
                  left: 0,
                  top: 242,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(0)),
                        fixedSize: const Size(370, 120)),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: null,
                  ),
                ),
                Positioned(
                  left: 370,
                  top: 242,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(0)),
                        fixedSize: const Size(370, 120)),
                    onPressed: (){
                      setState(() {
                        _networkProvider.bellboyTF = true;
                      });
                      navPage(context: context, page: const BellBoyServiceMenu(), enablePop: false).navPageToPage();
                    },
                    child: null,
                  ),
                ),
              ]
          ),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        )
    );
  }
}
