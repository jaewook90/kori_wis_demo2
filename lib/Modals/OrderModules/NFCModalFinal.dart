import 'package:flutter/material.dart';

class NFCModuleScreenFinal extends StatefulWidget {
  const NFCModuleScreenFinal({Key? key}) : super(key: key);

  @override
  State<NFCModuleScreenFinal> createState() => _NFCModuleScreenFinalState();
}

class _NFCModuleScreenFinalState extends State<NFCModuleScreenFinal> {
  String NFCimg = 'assets/screens/Serving/koriZFinalNFC.png';

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.white)),),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          // backgroundColor: Color(0xff000000),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Color(0xFFB7B7B7),
                style: BorderStyle.solid,
                width: 1,
              )),
          child: Container(
            height: 1401,
            width: 1072.5,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(width: 2, color: Colors.white)),
                  image: DecorationImage(image: AssetImage(NFCimg)),
            ),
        ),
              Positioned(
                  left: 53,
                  top: 35,
                  child: Container(
                    width: 48,
                    height: 48,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(0))
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: null,
                    ),
                  )),
              Positioned(
                  left: 890,
                  top: 35,
                  child: Container(
                    width: 48,
                    height: 48,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(0))
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: null,
                    ),
                  )),
      ]),
          ),
    ));
  }
}
