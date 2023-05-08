import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Widgets/RoomServiceModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class SelectRoomItemModalFinal extends StatefulWidget {
  const SelectRoomItemModalFinal({Key? key}) : super(key: key);

  @override
  State<SelectRoomItemModalFinal> createState() => _SelectRoomItemModalFinalState();
}

class _SelectRoomItemModalFinalState extends State<SelectRoomItemModalFinal> {
  late ServingModel _servingProvider;

  String? itemName;

  List<String> orderedItems = [];

  List<String> menuItems = ['수건', '헤어', '가운', '스킨'];

  String itemSelectBG = 'assets/screens/Hotel/RoomService/koriZFinalRoomItemSelect.png';

  late List<String> menuImgItems;

  // 배경 화면
  late String backgroundImage;

  // 코리 바디 및 트레이 사진
  late String koriBody;
  late String servingTray1;
  late String servingTray2;
  late String servingTray3;

  // 상품 사진
  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  // 상품 구분 번호
  int itemNumber = 0;

  // 상품 목록
  late List<List> itemImagesList; // 트레이 1, 2, 3 다발 리스트
  late List<String> itemImages;
  late int trayNumber;

  // 트레이 하이드 앤 쇼
  bool? offStageTray1;
  bool? offStageTray2;
  bool? offStageTray3;

  // 음식 하이드 앤 쇼
  bool? servedItem1;
  bool? servedItem2;
  bool? servedItem3;

  //트레이별 선택 테이블 넘버
  String? table1;
  String? table2;
  String? table3;

  //트레이별 선택 메뉴
  String? item1;
  String? item2;
  String? item3;

  late bool receiptModeOn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    itemName = _servingProvider.menuItem;

    return Container(
      padding: const EdgeInsets.only(top: 90),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.white))
      ),
      child: Dialog(
          backgroundColor: const Color(0xff000000),
          child: Stack(
            children: [
              Container(
                height: 1536,
                decoration: BoxDecoration(
                    border: const Border.fromBorderSide(BorderSide(color: Colors.white)),
                    image: DecorationImage(
                        image: AssetImage(itemSelectBG))),
              ),
              Positioned(
                  left: 877,
                  top: 25,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.transparent,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        Navigator.pop(context);
                        _servingProvider.item1 = "";
                        _servingProvider.item2 = "";
                        _servingProvider.item3 = "";
                      },
                      child: null,
                    ),
                  )),
              const RoomServiceModuleButtonsFinal(
                screens: 1,
              ),
            ],
          )),
    );
  }
}