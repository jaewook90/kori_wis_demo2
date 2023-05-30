import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectItemModalFinal extends StatefulWidget {
  const SelectItemModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectItemModalFinal> createState() => _SelectItemModalFinalState();
}

class _SelectItemModalFinalState extends State<SelectItemModalFinal> {
  late ServingModel _servingProvider;

  String itemSelectBG = 'assets/screens/Serving/koriZFinalItemSelect.png';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);


    return Container(
      padding: const EdgeInsets.fromLTRB(0, 90, 0, 180),
      height: 1536,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                height: 1536,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: AssetImage(itemSelectBG))),
              ),
              // 아이템 선택 종료 X버튼
              Positioned(
                  left: 880,
                  top: 23,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        Navigator.pop(context);
                        _servingProvider.item1 = "";
                        _servingProvider.item2 = "";
                        _servingProvider.item3 = "";
                      },
                      child: null,
                    ),
                  )),
              // 상품 버튼
              const ServingModuleButtonsFinal(
                screens: 1,
              ),
            ],
          )),
    );
  }
}