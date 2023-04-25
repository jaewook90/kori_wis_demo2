import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier {
  List<String>? orderedItems;
  List<String>? selectedItemsList;
  List<bool>? SelectedItemsQT;
  int? SelectedQT;

  int? orderedHamburgerPrice;
  int? orderedRamyeonPrice;
  int? orderedHotdogPrice;
  int? orderedChickenPrice;

  int? orderedTotalPrice;

  int? orderedHamburgerQT;
  int? orderedRamyeonQT;
  int? orderedHotdogQT;
  int? orderedChickenQT;

  OrderModel({
    this.orderedItems,
    this.orderedHamburgerPrice,
    this.orderedRamyeonPrice,
    this.orderedHotdogPrice,
    this.orderedChickenPrice,

    this.orderedTotalPrice,

    this.orderedHamburgerQT,
    this.orderedRamyeonQT,
    this.orderedHotdogQT,
    this.orderedChickenQT,
  });

}