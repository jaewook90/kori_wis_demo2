import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:provider/provider.dart';

//허가 유틸 헤더
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await initializeDateFormatting();

  Permission.location.request();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MainStatusModel(
                  debugMode: true,
                  robotX: 0,
                  robotY: 0,
                  robotTheta: 0,
                  batBal: 0,
                  chargeFlag: 0,
                  emgButton: 1,
                  mainSoundMute: true,
                  restartService: false,
                  autoCharge: 20,
                  facilityDetail: ['유선 방송업', '곡물 및 유지작물 도매업', '의류도소매업', '세무업무', '보안시스템 전문기업', '건축설계 및 관련 서비스업', '건강식품 전문업체', '데이터 기반 AI 솔루션 전문회사', '기타 엔지니어링 서비스업', '대부업', '산업용 로봇 제조업', '설계, 감리, 환경디자인/부동산 개발', '유선 방송업', '교육서비스업'],
                  facilityName: [],
                  facilityNum: [],
                  facilityNavDone: false,
                  lastFacilityNum: '',
                  lastFacilityName: '',
                  facilityOfficeSelected: false,
              facilityArrived: false,
                facilitySelectByBTN: false,
              facilityOnSearchScreen: false,
                EMGModalChange: false
                )),
        ChangeNotifierProvider(
            create: (context) => NetworkModel(
                  startUrl: '',
                  getPoseData: [],
                )),
        ChangeNotifierProvider(
            create: (context) => ServingModel(
                  waitingPoint: 'wait',
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KORi-Z Robot App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff191919),
          textTheme: TextTheme(
            //영어폰트용
            titleLarge: GoogleFonts.roboto(
                color: const Color(0xffF0F0F0), fontSize: 45),
            titleMedium: GoogleFonts.roboto(
                color: const Color(0xffB7B7B7), fontSize: 32),
            bodyLarge: GoogleFonts.roboto(
                color: const Color(0xffB7B7B7), fontSize: 28),
            bodyMedium: GoogleFonts.roboto(
                color: const Color(0xffB7B7B7), fontSize: 24),
            bodySmall: GoogleFonts.roboto(
                color: const Color(0xffB7B7B7), fontSize: 20),

            //한글폰트용
            displayLarge: const TextStyle(
              fontFamily: 'kor',
              fontWeight: FontWeight.bold,
              fontSize: 90,
              color: Color(0xffF0F0F0),
            ),

            displayMedium: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 85,
                color: Color(0xffF0F0F0)),

            displaySmall: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 65,
                color: Color(0xffF0F0F0)),
            // 네비게이션모듈 : 배경 글씨, 목적지명

            headlineLarge: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color(0xffF0F0F0)),

            headlineMedium: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xffF0F0F0)),

            headlineSmall: const TextStyle(
                fontFamily: 'kor',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xffF0F0F0)),
          ),
        ),
        home: const IntroScreen(),
      ),
    ),
  );
}
