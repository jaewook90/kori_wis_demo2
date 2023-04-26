import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kori_wis_demo/Screens/MainScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:table_calendar/table_calendar.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelRoomInfoNCart extends StatefulWidget {
  const HotelRoomInfoNCart({Key? key, this.kindOfRoom}) : super(key: key);
  final String? kindOfRoom;

  @override
  State<HotelRoomInfoNCart> createState() => _HotelRoomInfoNCartState();
}

class _HotelRoomInfoNCartState extends State<HotelRoomInfoNCart> {
  static const String backgroundImage =
      "assets/screens/Hotel/koriZFinalCart.png";

  late final List<String> roomImages;
  late int roomKindNum;
  late List<String> roomInfo;

  List<int> roomPrice = [112500, 134000, 155000, 172500];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    roomImages = [
      "assets/images/hotel_room_img/room1.jpg",
      "assets/images/hotel_room_img/room2.jpg",
      "assets/images/hotel_room_img/room3.jpg",
      "assets/images/hotel_room_img/room4.jpg"
    ];

    if (widget.kindOfRoom == "스탠다드 더블") {
      roomKindNum = 0;
    } else if (widget.kindOfRoom == "스탠다드 트윈") {
      roomKindNum = 1;
    } else if (widget.kindOfRoom == "디럭스 더블") {
      roomKindNum = 2;
    } else if (widget.kindOfRoom == "디럭스 트윈") {
      roomKindNum = 3;
    }
    roomInfo = [widget.kindOfRoom!, roomPrice[roomKindNum].toString()];
  }

  void showCalendarPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 500),
              height: 600,
              width: 420,
              child: Stack(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 100, 0, 0),
                    child: Container(
                      color: Colors.white,
                      width: 400,
                      height: 400,
                      child: TableCalendar(
                        locale: 'ko_KR',
                        firstDay: DateTime.utc(2021, 04, 19),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        rowHeight: 40,
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle:
                              TextStyle(fontSize: 15, color: Colors.black),
                          weekendStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        daysOfWeekHeight: 20,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle:
                              const TextStyle(fontSize: 25, color: Colors.blue),
                          titleTextFormatter: (date, locale) =>
                              DateFormat.yMMMM(locale).format(date),
                        ),
                        calendarStyle: const CalendarStyle(
                          rangeEndTextStyle:
                              TextStyle(fontSize: 15, color: Colors.blue),
                          rangeStartTextStyle:
                              TextStyle(fontSize: 15, color: Colors.blue),
                          defaultTextStyle:
                              TextStyle(fontSize: 15, color: Colors.black),
                          holidayTextStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                          disabledTextStyle: TextStyle(fontSize: 15),
                          outsideTextStyle: TextStyle(fontSize: 15),
                          weekendTextStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ),
                    )),
                Positioned(
                  left: 350,
                  top: 25,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    color: Colors.white,
                    iconSize: 60,
                  ),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print(roomInfo);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                    left: 30,
                    top: 25,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    )),
                Positioned(
                  left: 20,
                  top: 18,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(80, 80),
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 25,
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
                Positioned(
                  left: 120,
                  top: 18,
                  child: FilledButton(
                    onPressed: () {
                      navPage(
                              context: context,
                              page: const MainScreenFinal(),
                              enablePop: false)
                          .navPageToPage();
                    },
                    child: null,
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(80, 80),
                        shape: RoundedRectangleBorder(
                            // side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
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
          // SizedBox(width: screenWidth * 0.03)
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            const HotelModuleButtonsFinal(
              screens: 2,
            ),
            Positioned(
              top: 160,
              left: 80,
              child: Container(
                height: 371,
                width: 919,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: Image.asset(
                          roomImages[index],
                          fit: BoxFit.cover,
                        ));
                  },
                  itemCount: roomImages.length,
                  pagination: const SwiperPagination(
                      alignment: Alignment.bottomRight,
                      builder: FractionPaginationBuilder(
                          color: Colors.white,
                          fontSize: 20,
                          activeColor: Colors.white,
                          activeFontSize: 25)),
                ),
              ),
            ),
            Positioned(
              top: 710,
              left: 872,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        // side: BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(140, 50)),
                onPressed: () {
                  showCalendarPopup(context);
                },
                child: null,
              ),
            ),
            Positioned(
                top: 570,
                left: 100,
                child: Container(
                  height: 60,
                  width: 400,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.red, width: 1))),
                  child: Text(
                    roomInfo[0],
                    style: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            Positioned(
                top: 580,
                left: 690,
                child: Container(
                  height: 60,
                  width: 300,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.red, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '원',
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 580,
                left: 650,
                child: Container(
                  height: 60,
                  width: 300,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.red, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        roomInfo[1],
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 560,
                left: 585,
                child: Container(
                  height: 60,
                  width: 300,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.red, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "51%",
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 25,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 560,
                left: 680,
                child: Container(
                  height: 60,
                  width: 300,
                  // decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.red, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '300000',
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 25,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
