import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/HotelModel.dart';
import 'package:kori_wis_demo/Providers/OrderModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await initializeDateFormatting();

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>MainStatusModel(
          serviceState: 0,
          playAd: false,
        )),
        ChangeNotifierProvider(
            create: (context) => HotelModel(
                trayDebug: false,
                receiptModeOn: false,
                attachedTray1: false,
                attachedTray2: false,
                attachedTray3: false,
                servedItem1: true,
                servedItem2: true,
                servedItem3: true,
                tray1Select: false,
                tray2Select: false,
                tray3Select: false,
                item1: '',
                item2: '',
                item3: '',
                room1: "",
                room2: "",
                room3: "",
                itemImageList: ['a', 'b', 'c'],
                menuItem: "미지정",
                roomNumber: "10"
            )),
        ChangeNotifierProvider(
            create: (context) => ServingModel(
              trayDebug: false,
                receiptModeOn: false,
                attachedTray1: false,
                attachedTray2: false,
                attachedTray3: false,
                servedItem1: true,
                servedItem2: true,
                servedItem3: true,
                tray1Select: false,
                tray2Select: false,
                tray3Select: false,
                item1: '',
                item2: '',
                item3: '',
                table1: "",
                table2: "",
                table3: "",
                itemImageList: ['a', 'b', 'c'],
                menuItem: "미지정",
            )),
        ChangeNotifierProvider(create: (context) => OrderModel(
          orderedChickenPrice: 0,
          orderedChickenQT: 0,
          orderedHamburgerPrice: 0,
          orderedHamburgerQT: 0,
          orderedHotdogPrice: 0,
          orderedHotdogQT: 0,
          orderedRamyeonPrice: 0,
          orderedRamyeonQT: 0,
          orderedTotalPrice: 0
        )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KORi-Z Robot App',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff191919),
          // fontFamily: 'kor',
          textTheme: TextTheme(
            //영어폰트용
            titleLarge:
            GoogleFonts.roboto(color: Color(0xffF0F0F0), fontSize: 45),
            titleMedium:
            GoogleFonts.roboto(color: Color(0xffB7B7B7), fontSize: 32),
            bodyLarge:
            GoogleFonts.roboto(color: Color(0xffB7B7B7), fontSize: 28),
            bodyMedium:
            GoogleFonts.roboto(color: Color(0xffB7B7B7), fontSize: 24),
            bodySmall:
            GoogleFonts.roboto(color: Color(0xffB7B7B7), fontSize: 20),

            //한글폰트용
            displayLarge: TextStyle(
              fontFamily: 'kor',
              fontWeight: FontWeight.bold,
              fontSize: 90,
              color: Color(0xffF0F0F0),
            ),

            displayMedium: TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 85,
                color: Color(0xffF0F0F0)),

            displaySmall: TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 65,
                color: Color(0xffF0F0F0)),
            // 네비게이션모듈 : 배경 글씨, 목적지명

            headlineLarge: TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color(0xffF0F0F0)),

            headlineMedium: TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xffF0F0F0)),

            headlineSmall: TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xffF0F0F0)),
          ),
        ),
        home: IntroScreen(),
      ),
    );
  }
}
