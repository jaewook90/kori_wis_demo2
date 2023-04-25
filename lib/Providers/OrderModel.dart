import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier {
  List<String>? orderedItems;
  List<String>? selectedItemsList;
  List<bool>? SelectedItemsQT;
  int? SelectedQT;


  OrderModel({
    this.orderedItems,
  });

}