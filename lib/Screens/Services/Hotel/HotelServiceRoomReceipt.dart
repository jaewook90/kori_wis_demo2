import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:provider/provider.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelRoomReceipt extends StatefulWidget {
  const HotelRoomReceipt({Key? key}) : super(key: key);

  @override
  State<HotelRoomReceipt> createState() => _HotelRoomReceiptState();
}

class _HotelRoomReceiptState extends State<HotelRoomReceipt> {
  late OrderModel _orderProvider;

  String backgroundImage = "assets/screens/Hotel/koriZFInalPaymentDone.png";

  late String paymentDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentDate = "2023.04.19 (수) 12:00"; // 추후 달력 연계
  }

  @override
  Widget build(BuildContext context) {
    _orderProvider = Provider.of<OrderModel>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    left: 130,
                    top: 10,
                    child: FilledButton(
                      onPressed: () {
                        navPage(
                            context: context,
                            page: const MainScreenFinal(),
                            enablePop: false)
                            .navPageToPage();
                      },
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(90, 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor: Colors.transparent),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Home.png',
                                ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Stack(
            children: [
              //예약번호
              Positioned(
                top: 755,
                left: 600,
                child: Container(
                  height: 50,
                  width: 400,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(_orderProvider.roomReserveNum!, style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  )
                ),
              ),
              //예약자 정보
              //이름
              Positioned(
                top: 835,
                left: 600,
                child: Container(
                    height: 50,
                    width: 400,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(_orderProvider.roomReserveName!, style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                ),
              ),
              //연락처
              Positioned(
                top: 925,
                left: 600,
                child: Container(
                    height: 50,
                    width: 400,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(_orderProvider.roomReserveContact!, style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                ),
              ),
              //결제정보
              //결제일
              Positioned(
                top: 1055,
                left: 350,
                child: Container(
                    height: 50,
                    width: 500,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('결제일시 $paymentDate', style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          color: Color(0xff797979)
                        ),),
                      ],
                    )
                ),
              ),
              //가격
              Positioned(
                top: 1132,
                left: 600,
                child: Container(
                    height: 50,
                    width: 400,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${_orderProvider.orderedRoomPrice!} 원', style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                ),
              ),
              //할인가격
              Positioned(
                top: 1215,
                left: 600,
                child: Container(
                    height: 50,
                    width: 400,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('- ${_orderProvider.roomReserveDiscount!} 원', style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                ),
              ),
              const HotelModuleButtonsFinal(screens: 3,)
            ],
          ),
        ),
      ),
    );
  }
}
