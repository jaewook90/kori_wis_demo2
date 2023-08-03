import 'package:flutter/material.dart';

class ServingModel with ChangeNotifier {
  bool? mainInit;

  bool? tray1;
  bool? tray2;
  bool? tray3;
  bool? trayChange;

  //트레이 장착 여부
  bool? attachedTray1;
  bool? attachedTray2;
  bool? attachedTray3;

  //트레이 별 상품 이름
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;

  //트레이 선택
  bool? tray1Select;
  bool? tray2Select;
  bool? tray3Select;

  List<String>? itemImageList;

  String? menuItem;

  String? item1;
  String? item2;
  String? item3;

  String? targetTableNum;
  String? waitingPoint;
  String? table1;
  String? table2;
  String? table3;
  String? allTable;
  String? returnTargetTable;
  bool? trayCheckAll;

  String? patrol1;
  String? patrol2;

  ServingModel(
      {this.mainInit,
      this.tray1,
      this.tray2,
      this.tray3,
      this.menuItem,
      this.itemImageList,
      this.attachedTray1,
      this.attachedTray2,
      this.attachedTray3,
      this.tray1Select,
      this.tray2Select,
      this.tray3Select,
      this.waitingPoint,
      this.servedItem1,
      this.servedItem2,
      this.servedItem3,
      this.item1,
      this.item2,
      this.item3,
      this.table1,
      this.table2,
      this.table3,
      this.allTable,
      this.trayCheckAll});

  void clearTray1() {
    tray1 = false;
    servedItem1 = true;
    tray1Select = false;
    item1 = "";
    table1 = "";
    itemImageList![0] = '';
    notifyListeners();
  }

  void clearTray2() {
    tray2 = false;
    servedItem2 = true;
    tray2Select = false;
    item2 = "";
    table2 = "";
    itemImageList![1] = '';
    notifyListeners();
  }

  void clearTray3() {
    tray3 = false;
    servedItem3 = true;
    tray3Select = false;
    item3 = "";
    table3 = "";
    itemImageList![2] = '';
    notifyListeners();
  }

  void clearAllTray() {
    tray1 = false;
    tray2 = false;
    tray3 = false;
    item1 = "";
    item2 = "";
    item3 = "";
    table1 = "";
    table2 = "";
    table3 = "";
    servedItem1 = true;
    servedItem2 = true;
    servedItem3 = true;
    tray1Select = false;
    tray2Select = false;
    tray3Select = false;
    notifyListeners();
  }

  void stickTray1() {
    attachedTray1 = false;
    notifyListeners();
  }

  void stickTray2() {
    attachedTray2 = false;
    notifyListeners();
  }

  void stickTray3() {
    attachedTray3 = false;
    notifyListeners();
  }

  void dittachedTray1() {
    attachedTray1 = true;
    notifyListeners();
  }

  void dittachedTray2() {
    attachedTray2 = true;
    notifyListeners();
  }

  void dittachedTray3() {
    attachedTray3 = true;
    notifyListeners();
  }

}
