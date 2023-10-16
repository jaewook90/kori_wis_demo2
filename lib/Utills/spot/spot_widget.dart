import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Utills/spot/spot_model.dart';

class SpotWidget extends StatelessWidget {
  const SpotWidget(
      {Key? key, required this.spot, required this.color, required this.onTap})
      : super(key: key);

  final Spot spot;

  final Color color;
  final Function(Spot) onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(spot);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),//or 15.0
        child: Container(
          height: 10,
          width: 10,
          // color: color,
          decoration: BoxDecoration(
            color: color,
            border: Border.fromBorderSide(
              BorderSide(
                color: color,
                width: 1
              )
            )
          ),
        ),
      ),
    );
  }
}
