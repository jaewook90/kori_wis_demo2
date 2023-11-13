import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kori_wis_demo/Modals/unmovableCountDownModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavDone.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNavProgNPause.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/KoriZDocking.dart';
import 'package:kori_wis_demo/Utills/FacilityCurrentPose.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityNavigation extends StatefulWidget {
  const FacilityNavigation({Key? key}) : super(key: key);

  @override
  State<FacilityNavigation> createState() => _FacilityNavigationState();
}

class _FacilityNavigationState extends State<FacilityNavigation> {
  final String facilityName = 'assets/images/facility/facNav/habio_7_f.svg';
  final String navMap =
      'assets/images/facility/323_black_map_modified_v_1_2.svg';
  final String navMapBG = 'assets/images/facility/map_bg.svg';
  final String navTopBG = 'assets/images/facility/facNav/bg.svg';

  final String navTopDot1 = 'assets/images/facility/facNav/ellipse_33.svg';
  final String navTopDot2 = 'assets/images/facility/facNav/ellipse_34.svg';
  final String navTopDot3 = 'assets/images/facility/facNav/ellipse_35.svg';

  // late bool navDone;

  late MainStatusModel _mainStatusProvider;
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late int navStatus;

  late bool initNavStatus;
  late bool navPause;
  late bool navDone;

  String? startUrl;
  String? moveBaseStatusUrl;

  late bool arrivedServingTable;
  late String targetTableNum;
  late String servTableNum;

  //
  // final CountdownController _controller = CountdownController(autoStart: true);
  //
  // late AudioPlayer _audioPlayer;
  // final String _audioFile = 'assets/voices/KoriFacilityDone.wav';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navDone = false;
    initNavStatus = true;
    navStatus = 99;

    arrivedServingTable = false;
    targetTableNum = "";

    navPause = false;
    navDone = false;

  }

  void showCountDownPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const UnmovableCountDownModalFinal();
        });
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      // 이동 화면 첫 진입 여부 확인
      if (getApiData == 3) {
        while (getApiData != 3) {
          if (mounted) {
            Provider.of<NetworkModel>((context), listen: false).APIGetData =
                getApiData;
            setState(() {
              navStatus = Provider.of<NetworkModel>((context), listen: false)
                  .APIGetData['status'];
              initNavStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          Provider.of<NetworkModel>((context), listen: false).APIGetData =
              getApiData;
          setState(() {
            navStatus = Provider.of<NetworkModel>((context), listen: false)
                .APIGetData['status'];
            initNavStatus = false;
          });
        }
      }
    } else {
      if (mounted) {
        Provider.of<NetworkModel>((context), listen: false).APIGetData =
            getApiData;
        setState(() {
          navStatus = Provider.of<NetworkModel>((context), listen: false)
              .APIGetData['status'];
          initNavStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    navPause = _mainStatusProvider.facilityNavPause!;
    navDone = _mainStatusProvider.facilityNavDoneScroll!;

    startUrl = _networkProvider.startUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    servTableNum = _networkProvider.servTable!;

    arrivedServingTable = _mainStatusProvider.facilityArrived!;

    Future.delayed(const Duration(milliseconds: 1000), () {
      Getting(startUrl!, moveBaseStatusUrl!);
    });

    if (navStatus == 3 && arrivedServingTable == false) {
      setState(() {
        _mainStatusProvider.facilityArrived = true;
        navStatus = 0;
      });
      if (servTableNum != '시설1' && servTableNum != 'charging_pile') {
        Future.delayed(const Duration(milliseconds: 230), () {
          setState(() {
            _mainStatusProvider.facilityNavDone = true;
          });
        });
      } else if (servTableNum == '시설1') {
        _mainStatusProvider.lastFacilityNum = '';
        _mainStatusProvider.lastFacilityName = '';
        Future.delayed(const Duration(milliseconds: 230), () {
          navPage(context: context, page: const FacilityScreen())
              .navPageToPage();
        });
      } else if (servTableNum == 'charging_pile') {
        Future.delayed(const Duration(milliseconds: 230), () {
          navPage(
            context: context,
            page: const KoriDocking(),
          ).navPageToPage();
        });
      }
    }
    if (navStatus == 4 && arrivedServingTable == false) {
      setState(() {
        _mainStatusProvider.facilityArrived = true;
        navStatus = 0;
      });
      showCountDownPopup(context);
    }
    // });

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
            AnimatedPadding(
              padding: EdgeInsets.only(
                  top: navPause
                      ? 176 * 3
                      : navDone
                          ? 181 * 3
                          : 264 * 3,
                  left: 17 * 3),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: Stack(children: [
                SvgPicture.asset(
                  navMapBG,
                  width: 1080,
                  height: 1920,
                ),
                SvgPicture.asset(
                  navMap,
                  width: 978,
                  height: 447 * 3,
                  fit: BoxFit.cover,
                ),
              ]),
            ),
            AnimatedPositioned(
              top: navPause
                  ? 176 * 3
                  : navDone
                      ? 181 * 3
                      : 230 * 3,
              left: 17 * 3,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: const FacilityCurrentPositionScreen(),
            ),
            SvgPicture.asset(
              navTopBG,
              width: 1080,
              height: 309 * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36, left: 54),
              child:
                  SvgPicture.asset(facilityName, width: 82 * 3, height: 14 * 3),
            ),
            Offstage(
              offstage: _mainStatusProvider.facilityNavDone!,
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
                  const FacilityNavigationProgNPause()
                ],
              ),
            ),
            Offstage(
                offstage: !_mainStatusProvider.facilityNavDone!,
                child:
                    // 주행 정보 묶음 출발지, 도착지, 이동상태
                    const FacilityNavigationDone()),
          ],
        ),
      ),
    );
  }
}
