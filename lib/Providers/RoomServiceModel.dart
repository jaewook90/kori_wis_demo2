import 'package:flutter/material.dart';

class RoomServiceModel with ChangeNotifier {
  bool? tray1;
  bool? tray2;
  bool? tray3;
  List<String>? trayList;
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
  //서빙 모드
  bool? receiptModeOn;
  bool? playAd;

  bool? servingBeginningIsNot;

  List<String>? itemImageList;

  String? menuItem;

  String? item1;
  String? item2;
  String? item3;
  String? namelessItem;
  List<String>? itemList;

  String? roomNumber;
  String? table1;
  String? table2;
  String? table3;
  String? generalTable;
  List<String>? tableList;
  bool? trayCheckAll;

  bool? setTrayTF;

  bool? trayDebug;

  RoomServiceModel({
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

    this.playAd,

    this.servingBeginningIsNot,

    this.servedItem1,
    this.servedItem2,
    this.servedItem3,
    this.item1,
    this.item2,
    this.item3,
    this.namelessItem,
    this.roomNumber,
    this.table1,
    this.table2,
    this.table3,
    this.generalTable,
    this.tableList,
    this.itemList,
    this.trayList,
    this.trayCheckAll,
    this.receiptModeOn,

    this.trayDebug

  });

  void initServing() {
    tray1 = false;
    tray2 = false;
    tray3 = false;
    menuItem = null;
    item1 = null;
    item2 = null;
    item3 = null;
    roomNumber = null;
    table1 = null;
    table2 = null;
    table3 = null;
    tableList!.isEmpty;
    itemList!.isEmpty;
    trayCheckAll = false;

    notifyListeners();
  }

  void setTray1() {
    tray1 = true;
    item1 = menuItem;
    table1 = roomNumber;

    notifyListeners();
  }

  void setTray2() {
    tray2 = true;
    item2 = menuItem;
    table2 = roomNumber;

    notifyListeners();
  }

  void setTray3() {
    tray3 = true;
    item3 = menuItem;
    table3 = roomNumber;

    notifyListeners();
  }

  void setItemTray1() {
    // tray1 = true;
    item1 = menuItem;
    notifyListeners();
  }

  void setItemTray2() {
    // tray2 = true;
    item2 = menuItem;
    notifyListeners();
  }

  void setItemTray3() {
    // tray3 = true;
    item3 = menuItem;
    notifyListeners();
  }


  void setTrayAll() {
    tray1 = true;
    tray2 = true;
    tray3 = true;
    item1 = menuItem;
    item2 = menuItem;
    item3 = menuItem;
    table1 = roomNumber;
    table2 = roomNumber;
    table3 = roomNumber;

    menuItem = "";
    roomNumber = "";

    notifyListeners();
  }

  void clearTray1(){
    tray1 = false;
    servedItem1 = true;
    tray1Select = false;
    item1 = "";
    table1 = "";
    itemImageList![0]='';
    notifyListeners();
  }

  void clearTray2(){
    tray2 = false;
    servedItem2 = true;
    tray2Select = false;
    item2 = "";
    table2 = "";
    itemImageList![1]='';
    notifyListeners();
  }

  void clearTray3(){
    tray3 = false;
    servedItem3 = true;
    tray3Select = false;
    item3 = "";
    table3 = "";
    itemImageList![2]='';
    notifyListeners();
  }

  void clearAllTray(){

    tray1 = false;
    tray2 = false;
    tray3 = false;
    item1 = '';
    item2 = '';
    item3 = '';
    table1 = '';
    table2 = '';
    table3 = '';
    servedItem1 = true;
    servedItem2 = true;
    servedItem3 = true;
    tray1Select = false;
    tray2Select = false;
    tray3Select = false;
    // itemImageList=['a', 'b', 'c'];
    notifyListeners();
  }

  void cancelTraySelection(){
    tray1Select = false;
    tray2Select = false;
    tray3Select = false;
    notifyListeners();
  }

  void playAD(){
    if(playAd == true){
      playAd = false;
    }else{
      playAd = true;
    }
    notifyListeners();
  }

  void stickTray1(){
    if(attachedTray1 == true){
      attachedTray1 = false;
    }else{
      attachedTray1 = true;
      clearTray1();
    }
    notifyListeners();
  }

  void stickTray2(){
    if(attachedTray2 == true){
      attachedTray2 = false;
    }else{
      attachedTray2 = true;
      clearTray2();
    }
    notifyListeners();
  }

  void stickTray3(){
    if(attachedTray3 == true){
      attachedTray3 = false;
    }else{
      attachedTray3 = true;
      clearTray3();
    }
    notifyListeners();
  }

  void servedItemTray1(){
    if(servedItem1 == true){
      servedItem1 = false;
    }else{
      servedItem1 = true;
    }
    notifyListeners();
  }

  void servedItemTray2(){
    if(servedItem2 == true){
      servedItem2 = false;
    }else{
      servedItem2 = true;
    }
    notifyListeners();
  }

  void servedItemTray3(){
    if(servedItem3 == true){
      servedItem3 = false;
    }
    notifyListeners();
  }
}
