import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/OrderModules/itemOrderModalFinal.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Widgets/OrderModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

class CheckOutScreenFinal extends StatefulWidget {
  const CheckOutScreenFinal({Key? key}) : super(key: key);

  @override
  State<CheckOutScreenFinal> createState() => _CheckOutScreenFinalState();
}

class _CheckOutScreenFinalState extends State<CheckOutScreenFinal> {
  late OrderModel _orderProvider;
  String shoppingCartImg = 'assets/screens/Serving/koriZFinalShoppingCart.png';

  late String selectedItemImg;

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

  List<String> selectedItemList = [];

  void showOrderPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ItemOrderModalFinal();
        });
  }

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

    return Container(
      padding: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 1401,
          width: 998,
          child: Stack(children: [
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(image: AssetImage(shoppingCartImg))),
              child: Container(),
            ),
            Positioned(
                left: 52,
                top: 29.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      print("aaaaaaaaaaaaaaaaaaaaaaaaa");
                      print(_orderProvider.SelectedQT);
                      Navigator.pop(context);
                      // Navigator.pop(context);
                      // showOrderPopup(context);
                    },
                    child: null,
                  ),
                )),
            Positioned(
                left: 891,
                top: 29.8,
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: null,
                  ),
                )),
            // 1번 목록 예시
            Container(
              padding: EdgeInsets.fromLTRB(0, 85, 0, 280),
              child: Scrollbar(
                thickness: 4.0,
                radius: Radius.circular(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: selectedItemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(60, 25, 60, 0),
                        height: 240,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Color(0xff292929),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 1))),
                        child: Stack(
                          children: [
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
                                        '${selectedItemList[index]}',
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
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 20,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
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
                                        style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 25,
                                          color: Color(0xff777777),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 653,
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
                                left: 650,
                                top: 47,
                                child: Container(
                                    width: 155,
                                    height: 50,
                                    color: Colors.transparent,
                                    // decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 1))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            style: IconButton.styleFrom(
                                                fixedSize: Size(40, 40)),
                                            onPressed: () {
                                              setState(() {
                                                if (selectedItemList[index] ==
                                                    "햄버거") {
                                                  if(hamburgerQT>0){
                                                    hamburgerQT--;
                                                  }
                                                  hamburgerTotalPrice = hamburgerQT * hamburgerPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "라면") {
                                                  if(ramyeonQT>0){
                                                    ramyeonQT--;
                                                  }
                                                  ramyeonTotalPrice = ramyeonQT * ramyeonPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "치킨") {
                                                  if(chickenQT>0){
                                                    chickenQT--;
                                                  }
                                                  chickenTotalPrice = chickenQT * chickenPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "핫도그") {
                                                  if(hotDogQT>0){
                                                    hotDogQT--;
                                                  }
                                                  hotDogTotalPrice = hotDogQT * hotDogPrice;
                                                }
                                                totalPrice = hamburgerTotalPrice + ramyeonTotalPrice + chickenTotalPrice + hotDogTotalPrice;
                                                _orderProvider.orderedHamburgerPrice = hamburgerTotalPrice;
                                                _orderProvider.orderedRamyeonPrice = ramyeonTotalPrice;
                                                _orderProvider.orderedChickenPrice = chickenTotalPrice;
                                                _orderProvider.orderedHotdogPrice = hotDogTotalPrice;
                                                _orderProvider.orderedHamburgerQT = hamburgerQT;
                                                _orderProvider.orderedRamyeonQT = ramyeonQT;
                                                _orderProvider.orderedChickenQT = chickenQT;
                                                _orderProvider.orderedHotdogQT = hotDogQT;
                                                _orderProvider.orderedTotalPrice = totalPrice;
                                              });
                                            },
                                            icon: Icon(
                                              Icons
                                                  .remove_circle_outline_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                        IconButton(
                                            style: IconButton.styleFrom(
                                                fixedSize: Size(40, 40)),
                                            onPressed: () {
                                              setState(() {
                                                if (selectedItemList[index] ==
                                                    "햄버거") {
                                                  hamburgerQT++;
                                                  hamburgerTotalPrice = hamburgerQT * hamburgerPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "라면") {
                                                  ramyeonQT++;
                                                  ramyeonTotalPrice = ramyeonQT * ramyeonPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "치킨") {
                                                  chickenQT++;
                                                  chickenTotalPrice = chickenQT * chickenPrice;
                                                } else if (selectedItemList[
                                                index] ==
                                                    "핫도그") {
                                                  hotDogQT++;
                                                  hotDogTotalPrice = hotDogQT * hotDogPrice;
                                                }
                                                totalPrice = hamburgerTotalPrice + ramyeonTotalPrice + chickenTotalPrice + hotDogTotalPrice;
                                                _orderProvider.orderedHamburgerPrice = hamburgerTotalPrice;
                                                _orderProvider.orderedRamyeonPrice = ramyeonTotalPrice;
                                                _orderProvider.orderedChickenPrice = chickenTotalPrice;
                                                _orderProvider.orderedHotdogPrice = hotDogTotalPrice;
                                                _orderProvider.orderedTotalPrice = totalPrice;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            ))
                                      ],
                                    ))),
                            Positioned(
                                left: 555,
                                top: 140,
                                child: Container(
                                  width: 45,
                                  height: 48,
                                  color: Colors.transparent,
                                  child: Row(
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
                                left: 555,
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

            Positioned(
                left: 200,
                top: 1213,
                child: Container(
                  width: 210,
                  height: 80,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$totalPrice',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 55,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                left: 430,
                top: 1213,
                child: Container(
                  width: 55,
                  height: 80,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 55,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                )),
            OrderModuleButtonsFinal(
              screens: 1,
            )
          ]),
        ),
      ),
    );
  }
}