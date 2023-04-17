import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kori_wis_demo/Screens/ServiceScreenFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/HotelModuleButtonsFinal.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kori_wis_demo/Widgets/MenuButtons.dart';

// ------------------------------ 보류 ---------------------------------------

class HotelRoomInfoNCart extends StatefulWidget {
  HotelRoomInfoNCart({Key? key}) : super(key: key);

  @override
  State<HotelRoomInfoNCart> createState() => _HotelRoomInfoNCartState();
}

class _HotelRoomInfoNCartState extends State<HotelRoomInfoNCart> {
  String backgroundImage = "assets/screens/Hotel/koriZFinalCart.png";

  void showCalendarPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            // insetPadding: EdgeInsets.all(100),
            child: Container(
              height: 600,
              width: 980,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: Colors.white,
                        width: 400,
                        height: 400,
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime.utc(2021, 04, 19),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: DateTime.now(),
                          rowHeight: 40,
                          daysOfWeekStyle: DaysOfWeekStyle(
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
                                TextStyle(fontSize: 25, color: Colors.blue),
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMMM(locale).format(date),
                          ),
                          calendarStyle: CalendarStyle(
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
                      ),
                      Container(
                        color: Colors.white,
                        width: 400,
                        height: 400,
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime.utc(2021, 04, 19),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: DateTime.now(),
                          rowHeight: 40,
                          daysOfWeekStyle: DaysOfWeekStyle(
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
                                TextStyle(fontSize: 25, color: Colors.blue),
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMMM(locale).format(date),
                          ),
                          calendarStyle: CalendarStyle(
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 900,
                  top: 0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel_outlined), color: Colors.white, iconSize: 60,),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Color(0xffB7B7B7),
          iconSize: screenHeight * 0.03,
          alignment: Alignment.centerRight,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            onPressed: () {
              navPage(
                      context: context,
                      page: ServiceScreenFinal(),
                      enablePop: false)
                  .navPageToPage();
            },
            icon: Icon(
              Icons.home_outlined,
            ),
            color: Color(0xffB7B7B7),
            iconSize: screenHeight * 0.03,
            alignment: Alignment.center,
          ),
          Icon(Icons.battery_charging_full,
              color: Colors.teal, size: screenHeight * 0.03),
          SizedBox(width: screenWidth * 0.03)
        ],
        toolbarHeight: screenHeight * 0.045,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            HotelModuleButtonsFinal(
              screens: 2,
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
                    fixedSize: Size(140, 50)),
                onPressed: () {
                  showCalendarPopup(context);
                },
                child: null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
