import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kori_wis_demo/Providers/BLEModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/ServingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectItemModalFinal extends StatefulWidget {
  const SelectItemModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectItemModalFinal> createState() => _SelectItemModalFinalState();
}

class _SelectItemModalFinalState extends State<SelectItemModalFinal> {
  late ServingModel _servingProvider;
  late BLEModel _bleProvider;

  String itemSelectBG = 'assets/screens/Serving/koriZFinalItemSelect.png';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _bleProvider = Provider.of<BLEModel>(context, listen: false);


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
                        // navPage(context: context, page: TrayEquipped(
                        //   characteristic: QualifiedCharacteristic(
                        //       characteristicId: Provider.of<BLEModel>(context, listen: false).trayDetectorCharacteristicId!,
                        //       serviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorServiceId!,
                        //       deviceId: Provider.of<BLEModel>(context, listen: false).trayDetectorDeviceId!),
                        // ), enablePop: false).navPageToPage();
                        setState(() {
                          _bleProvider.onTraySelectionScreen = true;
                          _servingProvider.item1 = "";
                          _servingProvider.item2 = "";
                          _servingProvider.item3 = "";
                        });
                        Navigator.pop(context);
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