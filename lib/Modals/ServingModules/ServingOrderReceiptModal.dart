import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// ------------------------------ 보류 ---------------------------------------

class ServingOrderReceipt extends StatefulWidget {
  const ServingOrderReceipt({Key? key}) : super(key: key);

  @override
  State<ServingOrderReceipt> createState() => _ServingOrderReceiptState();
}

class _ServingOrderReceiptState extends State<ServingOrderReceipt> {
  late OrderModel _orderProvider;
  String backgroundImage = "assets/screens/Serving/koriZFinalOrderReceipt.png";

  List<String> selectedItemList = [];

  late String hamburger;
  late String hotDog;
  late String chicken;
  late String ramyeon;

  late String hamburgerEng;
  late String hotDogEng;
  late String chickenEng;
  late String ramyeonEng;

  late int hamburgerPrice;
  late int hotDogPrice;
  late int chickenPrice;
  late int ramyeonPrice;

  late int hamburgerTotalPrice;
  late int hotDogTotalPrice;
  late int chickenTotalPrice;
  late int ramyeonTotalPrice;

  late int totalPrice;

  late int hamburgerQT;
  late int hotDogQT;
  late int chickenQT;
  late int ramyeonQT;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hamburger = "assets/images/serving_item_imgs/hamburger.png";
    hotDog = "assets/images/serving_item_imgs/hotDog.png";
    chicken = "assets/images/serving_item_imgs/chicken.png";
    ramyeon = "assets/images/serving_item_imgs/ramyeon.png";

    hamburgerEng = "Hamburger";
    hotDogEng = "Hotdog";
    chickenEng = "Chicken";
    ramyeonEng = "Ramyeon";

    hamburgerPrice = 6700;
    hotDogPrice = 4800;
    chickenPrice = 18000;
    ramyeonPrice = 3500;

    hamburgerQT = 0;
    hotDogQT = 0;
    chickenQT = 0;
    ramyeonQT = 0;

    hamburgerTotalPrice = 0;
    hotDogTotalPrice = 0;
    chickenTotalPrice = 0;
    ramyeonTotalPrice = 0;

    totalPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);

    selectedItemList = _orderProvider.selectedItemsList!;

    hamburgerQT = _orderProvider.orderedHamburgerQT!;
    ramyeonQT = _orderProvider.orderedRamyeonQT!;
    chickenQT = _orderProvider.orderedChickenQT!;
    hotDogQT = _orderProvider.orderedHotdogQT!;

    hamburgerTotalPrice = _orderProvider.orderedHamburgerPrice!;
    ramyeonTotalPrice = _orderProvider.orderedRamyeonPrice!;
    chickenTotalPrice = _orderProvider.orderedChickenPrice!;
    hotDogTotalPrice = _orderProvider.orderedHotdogPrice!;

    totalPrice = _orderProvider.orderedTotalPrice!;

    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1561,
          width: 992,
          child: Stack(children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                // border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                  image: DecorationImage(image: AssetImage(backgroundImage))),
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 330, 0, 670),
              child: Scrollbar(
                thickness: 4.0,
                radius: const Radius.circular(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: selectedItemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(60, 25, 60, 0),
                        height: 240,
                        width: 400,
                        decoration: BoxDecoration(
                            color: const Color(0xff292929),
                            borderRadius: BorderRadius.circular(50)),
                        child: Stack(
                          children: [
                            // 영수증 상품 이미지
                            Positioned(
                                left: 60,
                                top: 30,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  // color: Colors.transparent,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(selectedItemList[
                                        index] ==
                                            "햄버거"
                                            ? hamburger
                                            : selectedItemList[index] == "라면"
                                            ? ramyeon
                                            : selectedItemList[index] ==
                                            "치킨"
                                            ? chicken
                                            : selectedItemList[index] ==
                                            "핫도그"
                                            ? hotDog
                                            : "")),
                                  ),
                                )),
                            // 영수증 개별 상품 품명
                            Positioned(
                                left: 300,
                                top: 40,
                                child: Container(
                                  width: 150,
                                  height: 60,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedItemList[index],
                                        style: const TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // 상품 영어 이름
                            Positioned(
                                left: 300,
                                top: 100,
                                child: Container(
                                  width: 120,
                                  height: 28,
                                  // color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? hamburgerEng
                                            : selectedItemList[index] == "라면"
                                            ? ramyeonEng
                                            : selectedItemList[index] ==
                                            "치킨"
                                            ? chickenEng
                                            : selectedItemList[index] ==
                                            "핫도그"
                                            ? hotDogEng
                                            : "",
                                        style: const TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 20,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // 상품 단가
                            Positioned(
                                left: 300,
                                top: 155,
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  // color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? '$hamburgerPrice 원'
                                            : selectedItemList[index] == "라면"
                                            ? '$ramyeonPrice 원'
                                            : selectedItemList[index] ==
                                            "치킨"
                                            ? '$chickenPrice 원'
                                            : selectedItemList[index] ==
                                            "핫도그"
                                            ? '$hotDogPrice 원'
                                            : "",
                                        style: const TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 25,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // 상품 개별 수량
                            Positioned(
                                left: 635,
                                top: 43,
                                child: Container(
                                  width: 155,
                                  height: 50,
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? '$hamburgerQT'
                                            : selectedItemList[index] == "라면"
                                            ? '$ramyeonQT'
                                            : selectedItemList[index] == "치킨"
                                            ? '$chickenQT'
                                            : selectedItemList[index] ==
                                            "핫도그"
                                            ? '$hotDogQT'
                                            : "",
                                        style: const TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 790,
                                top: 43,
                                child: Container(
                                  width: 45,
                                  height: 48,
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 1))),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '개',
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // 상품 별 총 액수
                            Positioned(
                                left: 555,
                                top: 140,
                                child: Container(
                                  width: 45,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '￦',
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 535,
                                top: 140,
                                child: Container(
                                  width: 250,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        selectedItemList[index] == "햄버거"
                                            ? '$hamburgerTotalPrice'
                                            : selectedItemList[index] == "라면"
                                            ? '$ramyeonTotalPrice'
                                            : selectedItemList[index] == "치킨"
                                            ? '$chickenTotalPrice'
                                            : selectedItemList[index] ==
                                            "핫도그"
                                            ? '$hotDogTotalPrice'
                                            : "",
                                        style: const TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 790,
                                top: 140,
                                child: Container(
                                  width: 45,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '원',
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 40,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            // 상품 총 가격
            Positioned(
                left: 610,
                top: 1020,
                child: Container(
                  width: 250,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 3))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$totalPrice",
                        style: const TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 860,
                top: 1020,
                child: Container(
                  width: 45,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3))
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            // 할인 가격
            Positioned(
                left: 610,
                top: 1090,
                child: Container(
                  width: 250,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 3))
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "- 0",
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 860,
                top: 1090,
                child: Container(
                  width: 45,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3))
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            // 결제 총 금액
            Positioned(
                left: 610,
                top: 1160,
                child: Container(
                  width: 250,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 3))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$totalPrice",
                        style: const TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 860,
                top: 1160,
                child: Container(
                  width: 45,
                  height: 48,
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    // border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3))
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            const OrderModuleButtonsFinal(screens: 3,)
          ]),
        ),
      ),
    );
  }
}
