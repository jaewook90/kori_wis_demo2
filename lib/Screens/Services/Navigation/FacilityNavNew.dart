import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavDoneNew.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavProgNPauseNew.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';

class FacilityNavigationNew extends StatefulWidget {
  const FacilityNavigationNew({Key? key}) : super(key: key);

  @override
  State<FacilityNavigationNew> createState() => _FacilityNavigationNewState();
}

class _FacilityNavigationNewState extends State<FacilityNavigationNew> {
  final String facilityName = 'assets/images/facility/facNav/habio_7_f.svg';
  final String navMapBG = 'assets/images/facility/facNav/360_map.svg';
  final String navTopBG = 'assets/images/facility/facNav/bg.svg';

  final String navTopDot1 = 'assets/images/facility/facNav/ellipse_33.svg';
  final String navTopDot2 = 'assets/images/facility/facNav/ellipse_34.svg';
  final String navTopDot3 = 'assets/images/facility/facNav/ellipse_35.svg';

  late bool navDone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navDone = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: const [
          SizedBox(
            width: 1080,
            height: 132,
            child: AppBarStatus(
              iconPoseSide: 255 * 3,
              iconPoseTop: 11 * 3,
            ),
          )
        ],
        toolbarHeight: 132,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 447),
              child: SvgPicture.asset(navMapBG, width: 1080, height: 1473),
            ),
            SvgPicture.asset(
              navTopBG,
              width: 1080,
              height: 309 * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36, left: 54),
              child:
                  SvgPicture.asset(facilityName, width: 84 * 3, height: 21 * 3),
            ),
            Offstage(
              offstage: navDone,
              child: Stack(
                children: [
                  // 주행 정보 묶음 출발지, 도착지, 이동상태
                  Padding(
                    padding: const EdgeInsets.only(top: 72 * 3, left: 20 * 3),
                    child: SizedBox(
                      width: 323 * 3,
                      height: 75 * 3,
                      child: Stack(
                        children: [
                          // 데코 점
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 26 * 3, left: 6 * 3),
                            child: SvgPicture.asset(navTopDot1,
                                width: 6, height: 6),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 35 * 3, left: 6 * 3),
                            child: SvgPicture.asset(navTopDot2,
                                width: 6, height: 6),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 44 * 3, left: 6 * 3),
                            child: SvgPicture.asset(navTopDot3,
                                width: 6, height: 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FacilityNavigationNewProgNPause()
                ],
              ),
            ),
            Offstage(
                offstage: !navDone,
                child:
                    // 주행 정보 묶음 출발지, 도착지, 이동상태
                    const FacilityNavigationNewDone()),
            Padding(
              padding: const EdgeInsets.only(top: 1500, left: 500),
              child: FilledButton(
                  onPressed: () {
                    navPage(context: context, page: const FacilityScreen())
                        .navPageToPage();
                  },
                  child: null),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1500, left: 700),
              child: FilledButton(
                  onPressed: () {
                    setState(() {
                      if(navDone == false){
                        navDone = true;
                      }else{
                        navDone = false;
                      }
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal
                  ),
                  child: null),
            )
            // SvgPicture.asset(navTopBG, width: 1080, height: 269*3)
          ],
        ),
      ),
    );
  }
}
