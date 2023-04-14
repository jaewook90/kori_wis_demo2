import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/ServingModules/navCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class TrayCheckingModalFinal extends StatefulWidget {
  const TrayCheckingModalFinal({Key? key}) : super(key: key);

  @override
  State<TrayCheckingModalFinal> createState() => _TrayCheckingModalFinalState();
}

class _TrayCheckingModalFinalState extends State<TrayCheckingModalFinal> {

  late ServingModel _servingProvider;

  String itemSelectBG = 'assets/screens/Serving/koriZFinalTrayChecking.png';

  void showCountDownPopup(context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NavCountDownModalFinal();
        });
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.only(top: 607),
      child:AlertDialog(
        alignment: Alignment.topCenter,
        content: Stack(
          children: [Container(
            width: 740,
            height: 362,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(itemSelectBG), fit: BoxFit.fill)),
            child: null,
          ),
            Positioned(
              left: 0,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        // side: BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius:
                        BorderRadius.circular(0)),
                    fixedSize: Size(370, 120)),
                onPressed: (){
                  _servingProvider.cancelTraySelection();
                  navPage(context: context, page: TraySelectionFinal(), enablePop: false).navPageToPage();
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
                        // side: BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius:
                        BorderRadius.circular(0)),
                    fixedSize: Size(370, 120)),
                onPressed: (){
                  showCountDownPopup(context);
                },
                child: null,
              ),
            ),
          ]
        ),
        backgroundColor: Colors.transparent,
        contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        // actionsPadding: EdgeInsets.only(top: screenHeight * 0.001),
      )
    );
  }
}
