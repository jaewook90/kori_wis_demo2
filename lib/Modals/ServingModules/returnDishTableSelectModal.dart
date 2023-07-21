import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/ReturnDish.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class ReturnDishTableModal extends StatefulWidget {
  const ReturnDishTableModal({Key? key}) : super(key: key);

  @override
  State<ReturnDishTableModal> createState() => _ReturnDishTableModalState();
}

class _ReturnDishTableModalState extends State<ReturnDishTableModal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late String returnTable;
  late int serviceState;

  String tableSelectBG = 'assets/screens/Serving/koriZFinalTableSelect.png';

  String positionURL = "";
  String hostAdr = "";

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;
  late double buttonRadius;

  late int buttonNumbers;

  String? startUrl;
  String? navUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    hostAdr = _networkProvider.startUrl!;
    positionURL = _networkProvider.positionURL;

    buttonPositionWidth = [190, 190, 190, 190, 590, 590, 590, 590];
    buttonPositionHeight = [387, 723, 1044, 1368, 387, 723, 1044, 1368];

    buttonNumbers = buttonPositionHeight.length;

    buttonSize = [218, 124];

    buttonRadius = 0;

    return Container(
      child: Dialog(
          backgroundColor: Colors.transparent,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide()),
          child: Stack(children: [
            Container(
              height: 1920,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(tableSelectBG), fit: BoxFit.cover),
              ),
            ),
            Positioned(
                left: 855,
                top: 147,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: null,
                  ),
                )),
            for (int i = 0; i < buttonNumbers; i++)
              Positioned(
                  left: buttonPositionWidth[i],
                  top: buttonPositionHeight[i],
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonRadius)),
                        fixedSize: Size(buttonSize[0], buttonSize[1])),
                    onPressed: () {
                      setState(() {
                        returnTable = _networkProvider.getPoseData![i];
                        _servingProvider.returnTargetTable = returnTable;
                      });
                      PostApi(
                              url: startUrl,
                              endadr: navUrl,
                              keyBody: returnTable)
                          .Posting(context);
                      Navigator.pop(context);
                      navPage(
                              context: context,
                              page: const ReturnProgressModuleFinal(),
                              enablePop: true)
                          .navPageToPage();
                    },
                    child: null,
                  ))
          ])),
    );
  }
}
