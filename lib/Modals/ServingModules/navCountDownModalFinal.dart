import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class NavCountDownModalFinal extends StatefulWidget {
  const NavCountDownModalFinal({Key? key}) : super(key: key);

  @override
  State<NavCountDownModalFinal> createState() => _NavCountDownModalFinalState();
}

class _NavCountDownModalFinalState extends State<NavCountDownModalFinal> {
  late ServingModel _servingProvider;
  late NetworkModel _networkProvider;

  late String countDownPopup;

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if(_networkProvider.serviceState==0){
      countDownPopup = 'assets/screens/Shipping/koriZFinalShipCountdown.png';
    }else if(_networkProvider.serviceState==1){
      countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
    }else if(_networkProvider.serviceState==2){
      countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
    }

    return Container(
        padding: EdgeInsets.only(top: 607),
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
                        // side: BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius:
                        BorderRadius.circular(0)),
                    fixedSize: Size(370, 120)),
                onPressed: (){
                  if(_networkProvider.serviceState==0){
                    Navigator.pop(context);
                  }else if(_networkProvider.serviceState==1){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
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
                  _servingProvider.playAd = false;
                  navPage(context: context, page: NavigatorProgressModuleFinal(), enablePop: false).navPageToPage();
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
