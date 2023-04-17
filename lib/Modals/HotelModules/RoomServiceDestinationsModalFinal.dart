import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:kori_wis_demo/Widgets/ShippingModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class RoomServiceDestinationListModalFinal extends StatefulWidget {
  const RoomServiceDestinationListModalFinal({Key? key}) : super(key: key);

  @override
  State<RoomServiceDestinationListModalFinal> createState() =>
      _RoomServiceDestinationListModalFinalState();
}

class _RoomServiceDestinationListModalFinalState extends State<RoomServiceDestinationListModalFinal> {
  late NetworkModel _networkProvider;

  String? startUrl;
  String? navUrl;
  String? chgUrl;
  String? stpUrl;
  String? rsmUrl;

  late var goalPosition = List<String>.empty();

  String itemSelectBG = 'assets/screens/Hotel/BellBoy/koriZFinalBellBoyRoomSelectList.png';

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    goalPosition = _networkProvider.goalPosition;
    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Dialog(
        backgroundColor: Color(0xff000000),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Color(0xFFB7B7B7),
              style: BorderStyle.solid,
              width: 1,
            )),
        alignment: Alignment.topCenter,
        child: Container(
          width: screenWidth,
          height: screenHeight*0.8,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(itemSelectBG), fit: BoxFit.fill)),
              ),
              Positioned(
                  left: 1189 * 0.75,
                  top: 34 * 0.75,
                  child: Container(
                    width: 55,
                    height: 55,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: null,
                    ),
                  )),
              RoomServiceModuleButtonsFinal(screens: 3,)
            ],
          ),
        )
      ),
    );
  }
}
