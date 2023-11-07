import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityListSearchScreenNew.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityListScreenNew extends StatefulWidget {
  final bool? hideThings;
  const FacilityListScreenNew({Key? key, this.hideThings}) : super(key: key);

  @override
  State<FacilityListScreenNew> createState() => _FacilityListScreenNewState();
}

class _FacilityListScreenNewState extends State<FacilityListScreenNew> {
  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;
  late List<String> officeDetail;

  late MainStatusModel _mainStatusProvider;

  final String backBTN = 'assets/images/facility/listView/btn.svg';
  final String searchBTN = 'assets/images/facility/listView/btn_2.svg';
  final String informName = 'assets/images/facility/listView/7_f.svg';
  final String informBottomBanner = 'assets/images/facility/listView/bottom.png';

  late String searchResult;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late bool btnClick;

  late bool listViewOffstage;

  final TextEditingController searchingController = TextEditingController();

  // String searchText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();
    btnClick = false;
    searchResult = '';
    officeName =
    ['(주)딜라이브', '아워팜', '브레인컴퍼니', 'DAWON\nTax Office', '(주)드림디엔에스', '(주)범건축종합\n건축사사무소', 'Daily Vegan', '(주)엘렉시', '신영비엠이(주)', 'HD인베스트', '(주)엑사로보틱스', '수성엔지니어링', '(주)딜라이브\n자재실', 'JS융합인재교육원(주)', '엘리베이터', '화장실1', '화장실2'];
    for (int i = 0;
        i <
            Provider.of<MainStatusModel>(context, listen: false)
                .facilityNum!
                .length;
        i++) {
      setState(() {
        officeNum =
            Provider.of<MainStatusModel>(context, listen: false).facilityNum!;
        officeDetail = Provider.of<MainStatusModel>(context, listen: false)
            .facilityDetail!;
      });
    }
    officeQTY = officeNum.length;
    // }

    listViewOffstage = widget.hideThings!;
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  void facilityInform(context, int number) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return FacilityModal(
            number: number,
          );
        });
  }

  void facilitySearching(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return FacilityListSearchScreenNew();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    print(officeNum);
    print(officeName);
    print(officeDetail);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 360 * 3,
            height: 44 * 3,
            child: Stack(children: [
              Positioned(
                top: 10 * 3,
                left: 17 * 3,
                child: Stack(children: [
                  SvgPicture.asset(
                    backBTN,
                    width: 29 * 3,
                    height: 24 * 3,
                    fit: BoxFit.cover,
                  ),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          fixedSize: const Size(29 * 3, 24 * 3),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _effectPlayer.seek(const Duration(seconds: 0));
                          _effectPlayer.play();
                          Future.delayed(const Duration(milliseconds: 230), () {
                            _effectPlayer.dispose();
                            navPage(
                                    context: context,
                                    page: const FacilityScreen())
                                .navPageToPage();
                          });
                        });
                      },
                      child: null),
                ]),
              ),
              Positioned(
                top: 10 * 3,
                left: 281 * 3,
                child: Offstage(
                  offstage: listViewOffstage,
                  child: Stack(children: [
                    SvgPicture.asset(
                      searchBTN,
                      width: 62 * 3,
                      height: 24 * 3,
                      fit: BoxFit.cover,
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(62 * 3, 24 * 3),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            Future.delayed(const Duration(milliseconds: 230), () {
                              _effectPlayer.dispose();
                              setState(() {
                                listViewOffstage = true;
                              });
                              facilitySearching(context);
                            });
                          });
                        },
                        child: null),
                  ]),
                ),
              ),
            ]),
          )
        ],
        toolbarHeight: 44 * 3,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(color: Color(0xff191919)),
        child: Stack(
          children: [
            Offstage(
              offstage: listViewOffstage,
              child: Padding(
                padding: EdgeInsets.only(left: 17 * 3, top: 52 * 3),
                child: SvgPicture.asset(
                  informName,
                  width: 113 * 3,
                  height: 17 * 3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 89*3, left: 17*3),
              child: Container(
                width: 326 * 3,
                height: 492 * 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < (officeQTY~/3); i++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for(int j = 0; j<3; j++)
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                        fixedSize: Size(106*3, 86*3),
                                        backgroundColor: Color(0xff333333).withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4*3),
                                        ),
                                        foregroundColor: Colors.white.withOpacity(1),
                                        splashFactory: NoSplash.splashFactory,
                                    ),
                                    onPressed: (){
                                      _effectPlayer.seek(const Duration(seconds: 0));
                                      _effectPlayer.play();
                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        setState(() {
                                          _mainStatusProvider.targetFacilityIndex = (3*i)+j;
                                          _mainStatusProvider.facilitySelectByBTN = true;
                                        });
                                        navPage(context: context, page: FacilityScreen()).navPageToPage();
                                        // facilityInform(context, 15);
                                      });
                                    },
                                    child: Column(
                                    children: [
                                      SizedBox(height: 17*3),
                                      Container(
                                        width: 34*3,
                                        height: 16*3,
                                        decoration: BoxDecoration(
                                            color: Color(0xff000000).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8*3)
                                        ),
                                        child: Text(
                                          '${_mainStatusProvider.facilityNum![(3*i)+j]}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 11*3,
                                              color: Color(0xff00d7d4),
                                              height: 1.4
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.5*3,),
                                      Container(
                                        width: 106*3,
                                        height: 27.5*3,
                                        child: Center(
                                          child: Text('${officeName[(3*i)+j]}', style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 12*3,
                                              letterSpacing: -0.21,
                                              color: Color(0xffffffff),
                                            height: 1.1
                                          ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  )
                              ],
                            ),
                            SizedBox(height: 4*3,)
                          ],
                        ),
                      Row(
                        children: [
                          for(int j = 0; j<officeQTY%3; j++)
                            Row(
                              children: [
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                      fixedSize: Size(106*3, 86*3),
                                      backgroundColor: Color(0xff333333).withOpacity(0.7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4*3),
                                      ),
                                    foregroundColor: Colors.white,
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  onPressed: (){
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 17*3),
                                      Container(
                                        width: 34*3,
                                        height: 16*3,
                                        decoration: BoxDecoration(
                                            color: Color(0xff000000).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8*3)
                                        ),
                                        child: Text(
                                          '${_mainStatusProvider.facilityNum![(officeQTY-officeQTY%3)+j]}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 11*3,
                                              color: Color(0xff00d7d4),
                                              height: 1.4
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.5*3,),
                                      Container(
                                        width: 106*3,
                                        height: 27.5*3,
                                        child: Center(
                                          child: Text('${officeName[(officeQTY-officeQTY%3)+j]}', style: TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 12*3,
                                              letterSpacing: -0.21,
                                              color: Color(0xffffffff),
                                              height: 1.1
                                          ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 4*3,
                                )
                              ],
                            )
                        ],
                      ),
                      SizedBox(
                        height: 86*3,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 573*3, left: 17*3),
              child: Container(
                width: 326*3,
                height: 50*3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: AssetImage(informBottomBanner))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
