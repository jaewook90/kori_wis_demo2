import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectTableModalFinal extends StatefulWidget {
  const SelectTableModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectTableModalFinal> createState() => _SelectTableModalFinalState();
}

class _SelectTableModalFinalState extends State<SelectTableModalFinal> {
  late ServingModel _servingProvider;

  String tableSelectBG = 'assets/screens/Serving/koriZFinalTableSelect.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 90),
      child: Dialog(
          backgroundColor: Colors.transparent,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0), borderSide: const BorderSide()),
          child: Stack(children: [
            Container(
              height: 1536,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(tableSelectBG), fit: BoxFit.cover),
              ),
            ),
            Positioned(
                left: 836,
                top: 18,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          // side: BorderSide(width: 1, color: Colors.white)
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                      _servingProvider.item1 = "";
                      _servingProvider.item2 = "";
                      _servingProvider.item3 = "";
                      setState(() {
                        if (_servingProvider.trayCheckAll == true) {
                          _servingProvider.tray1 = false;
                          _servingProvider.tray2 = false;
                          _servingProvider.tray3 = false;
                        }
                      });
                    },
                    child: null,
                  ),
                )),
            const ServingModuleButtonsFinal(
              screens: 2,
            ),
          ])),
    );
  }
}
