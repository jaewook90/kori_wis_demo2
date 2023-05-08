import 'package:flutter/material.dart';

class HotelModel with ChangeNotifier {
  bool? bellboyTF;

  // from roomService

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

  List<String>? itemImageList;

  String? menuItem;

  String? item1;
  String? item2;
  String? item3;

  String? roomNumber;
  String? room1;
  String? room2;
  String? room3;

  bool? trayCheckAll;

  bool? trayDebug;

  HotelModel({

    this.menuItem,
    this.itemImageList,

    this.attachedTray1,
    this.attachedTray2,
    this.attachedTray3,
    this.tray1Select,
    this.tray2Select,
    this.tray3Select,

    this.servedItem1,
    this.servedItem2,
    this.servedItem3,
    this.item1,
    this.item2,
    this.item3,
    this.roomNumber,
    this.room1,
    this.room2,
    this.room3,
    this.trayCheckAll,
    this.receiptModeOn,

    this.trayDebug
  });

  void setTrayAll() {
    item1 = menuItem;
    item2 = menuItem;
    item3 = menuItem;
    room1 = roomNumber;
    room2 = roomNumber;
    room3 = roomNumber;

    menuItem = "";
    roomNumber = "";

    notifyListeners();
  }

  void clearTray1(){
    servedItem1 = true;
    tray1Select = false;
    item1 = "";
    room1 = "";
    itemImageList![0]='';
    notifyListeners();
  }

  void clearTray2(){
    servedItem2 = true;
    tray2Select = false;
    item2 = "";
    room2 = "";
    itemImageList![1]='';
    notifyListeners();
  }

  void clearTray3(){
    servedItem3 = true;
    tray3Select = false;
    item3 = "";
    room3 = "";
    itemImageList![2]='';
    notifyListeners();
  }

  void clearAllTray(){
    item1 = '';
    item2 = '';
    item3 = '';
    room1 = '';
    room2 = '';
    room3 = '';
    servedItem1 = true;
    servedItem2 = true;
    servedItem3 = true;
    tray1Select = false;
    tray2Select = false;
    tray3Select = false;
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
}