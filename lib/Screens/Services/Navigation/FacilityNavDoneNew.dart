import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavProgNPauseNew.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';

class FacilityNavigationNewDone extends StatefulWidget {
  const FacilityNavigationNewDone({Key? key}) : super(key: key);

  @override
  State<FacilityNavigationNewDone> createState() =>
      _FacilityNavigationNewDoneState();
}

class _FacilityNavigationNewDoneState extends State<FacilityNavigationNewDone> {
  late String officePic;
  late String extendLine;
  late String arrivedIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    officePic = 'assets/images/facility/facNav/navDone/image.png';
    extendLine = 'assets/images/facility/facNav/navDone/line_5.svg';
    arrivedIcon = 'assets/images/facility/facNav/navDone/frame.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          // 도착 장소 정보창
          Padding(
            padding: const EdgeInsets.only(top: 59 * 3, left: 17 * 3),
            child: Container(
              width: 280 * 3,
              height: 62 * 3,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2 * 3),
                    child: Container(
                      width: 103 * 3,
                      height: 59 * 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(officePic))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 114 * 3),
                    child: Column(
                      children: [
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '710호',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                                letterSpacing: -0.24),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '(주)범건축종합건축사사무소',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 14 * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                                letterSpacing: -0.24),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 4 * 3,
                        ),
                        SizedBox(
                          width: (280 - 105) * 3,
                          child: Text(
                            '건축설계 및 관련 서비스업',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 12 * 3,
                                fontWeight: FontWeight.w100,
                                color: Color(0xffffffff),
                                letterSpacing: -0.21),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 상태 안내
          Padding(
            padding: const EdgeInsets.only(top: 157 * 3, left: 28 * 3),
            child: Container(
              width: 315 * 3,
              height: 24 * 3,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5 * 3, bottom: 4 * 3),
                    child: Container(
                        // height: 15*3,
                        child: const Text(
                      '안내가 완료 되었습니다!',
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * 3,
                          letterSpacing: -0.24,
                          color: Color(0xffffffff),
                          height: 1.001),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: (11.8 - 1.75) * 3, left: 141 * 3),
                    child: Opacity(
                        opacity: 0.6,
                        child: SvgPicture.asset(
                          extendLine,
                          width: 105 * 3,
                          height: 4 * 3,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 248*3),
                    child: Container(
                      width: 67 * 3,
                      height: 24 * 3,
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(color: Color(0x99666666), width: 1.5)),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5*3, left: 6.5*3),
                            child: SvgPicture.asset(arrivedIcon, width: 14*3, height: 14*3,),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4.5*3, left: 23.5*3),
                            child: Text(
                              '안내 완료',
                              style: TextStyle(
                                  fontFamily: 'kor',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 * 3,
                                  letterSpacing: -0.18,
                                  color: Color(0xffffffff),
                                  height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // 버튼
          Padding(
            padding: const EdgeInsets.only(top: 215 * 3, left: 17 * 3),
            child: SizedBox(
              width: 326 * 3,
              height: 34 * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor:
                          const Color(0xff000000).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Center(
                          child: Text(
                            '복귀',
                            style: TextStyle(
                              fontFamily: 'kor',
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * 3,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                  TextButton(
                      onPressed: () {
                        setState(() {

                        });
                      },
                      style: TextButton.styleFrom(
                          fixedSize: const Size(159 * 3, 34 * 3),
                          backgroundColor: const Color(0xff5e5ce6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Center(
                          child: Text(
                            '새로운 안내',
                           style: TextStyle(
                              fontFamily: 'kor',
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * 3,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
