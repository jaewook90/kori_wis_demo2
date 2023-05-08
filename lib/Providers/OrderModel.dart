import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier {
  List<String>? selectedItemsList;
  List<bool>? SelectedItemsQT;
  int? SelectedQT;

  int? orderedHamburgerPrice;
  int? orderedRamyeonPrice;
  int? orderedHotdogPrice;
  int? orderedChickenPrice;

  int? orderedTotalPrice;
  String? orderedRoomPrice;
  String? roomReserveNum;
  String? roomReserveName;
  String? roomReserveContact;
  String? roomReserveDiscount;

  int? orderedHamburgerQT;
  int? orderedRamyeonQT;
  int? orderedHotdogQT;
  int? orderedChickenQT;

  OrderModel({
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