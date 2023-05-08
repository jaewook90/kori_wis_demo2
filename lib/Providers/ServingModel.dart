import 'package:flutter/material.dart';

class ServingModel with ChangeNotifier {
  //트레이 장착 여부//
  bool? attachedTray1;
  bool? attachedTray2;
  bool? attachedTray3;
  //트레이 장착 여부//


  //트레이 별 상품 이름 //
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;
  //트레이 별 상품 이름 //


  //트레이 선택
  bool? tray1Select;
  bool? tray2Select;
  bool? tray3Select;
  //트레이 선택


  //서빙 모드
  bool? receiptModeOn;


  //트레이 표시 상품 이미지
  List<String>? itemImageList;
  //트레이 표시 상품 이미지

  //트레이 선택 후 상품 선택 시 메뉴 이름
  String? menuItem;
  //트레이 선택 시 메뉴 이름

  String? item1;
  String? item2;
  String? item3;

  // 테이블 넘버 선택 및 트레이에 번호 표시 //
  String? table1;
  String? table2;
  String? table3;
  // 테이블 넘버 선택 및 트레이에 번호 표시 //

  bool? trayCheckAll;

  // 디버그모드 온/오프 서빙 //
  bool? trayDebug;
  // 디버그모드 온/오프 서빙 //

  ServingModel({
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
    this.table1,
    this.table2,
    this.table3,

    this.trayCheckAll,
    this.receiptModeOn,
    this.trayDebug
  });


  // 트레이 온/오프 //
  void stickTray1(){
    if(attachedTray1 == true){
      attachedTray1 = false;
    }else{
      attachedTray1 = true;
    }
    notifyListeners();
  }
  void stickTray2(){
    if(attachedTray2 == true){
      attachedTray2 = false;
    }else{
      attachedTray2 = true;
    }
    notifyListeners();
  }
  void stickTray3(){
    if(attachedTray3 == true){
      attachedTray3 = false;
    }else{
      attachedTray3 = true;
    }
    notifyListeners();
  }
  // 트레이 온/오프 //

  // 각 트레이 설정 초기화 //
  void clearTray1(){
    servedItem1 = true;
    tray1Select = false;
    item1 = "";
    table1 = "";
    itemImageList![0]='';
    notifyListeners();
  }

  void clearTray2(){
    servedItem2 = true;
    tray2Select = false;
    item2 = "";
    table2 = "";
    itemImageList![1]='';
    notifyListeners();
  }

  void clearTray3(){
    servedItem3 = true;
    tray3Select = false;
    item3 = "";
    table3 = "";
    itemImageList![2]='';
    notifyListeners();
  }
  // 각 트레이 설정 리셋 //

  // 트레이 상품, 테이블 미 선택 후 일괄 이송 시
  void setTrayAll() {
    // tray1 = true;
    // tray2 = true;
    // tray3 = true;
    item1 = menuItem;
    item2 = menuItem;
    item3 = menuItem;

    menuItem = "";
    // tableNumber = "";

    notifyListeners();
  }
  // 트레이 상품, 테이블 미 선택 후 일괄 이송 시

  // 서빙 서비스 재시작 시 모든 트레이 초기화
  void clearAllTray(){
    item1 = null;
    item2 = null;
    item3 = null;
    table1 = null;
    table2 = null;
    table3 = null;
    servedItem1 = true;
    servedItem2 = true;
    servedItem3 = true;
    tray1Select = false;
    tray2Select = false;
    tray3Select = false;
    // itemImageList=['a', 'b', 'c'];
    notifyListeners();
  }
  // 서빙 서비스 재시작 시 모든 트레이 초기화
}
