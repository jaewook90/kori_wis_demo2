import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Widgets/BellboyModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class BellboyDestinationListModalFinal extends StatefulWidget {
  const BellboyDestinationListModalFinal({Key? key}) : super(key: key);

  @override
  State<BellboyDestinationListModalFinal> createState() =>
      _BellboyDestinationListModalFinalState();
}

class _BellboyDestinationListModalFinalState extends State<BellboyDestinationListModalFinal> {
  late NetworkModel _networkProvider;

  late var goalPosition = List<String>.empty();

  String itemSelectBG = 'assets/screens/Hotel/BellBoy/koriZFinalBellBoyRoomSelectList.png';

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    goalPosition = _networkProvider.goalPosition;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          child: Container(
            height: screenHeight*0.8,
            color: Colors.transparent,
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
                    left: 891.75,
                    top: 25.5,
                    child: Container(
                      width: 55,
                      height: 55,
                      color: Colors.transparent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: null,
                      ),
                    )),
                const BellboyModuleButtonsFinal(screens: 2,)
              ],
            ),
          )
      ),
    );
  }
}
