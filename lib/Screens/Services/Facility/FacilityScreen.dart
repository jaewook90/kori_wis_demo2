import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityListScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityScreen extends StatefulWidget {
  const FacilityScreen({Key? key}) : super(key: key);

  @override
  State<FacilityScreen> createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  int officeQTY = 16;
  late List<String> officeName;
  late List<String> officeDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    officeName = [
      '사무실1',
      '사무실2',
      '사무실3',
      '사무실4',
      '사무실5',
      '사무실6',
      '사무실7',
      '사무실8',
      '사무실9',
      '사무실10',
      '사무실11',
      '사무실12',
      '사무실13',
      '사무실14',
      '사무실15',
      '사무실16'
    ];

    officeDetail = [
      '여기는 701호 사물실 입니다.',
      '여기는 702호 사물실 입니다.',
      '여기는 703호 사물실 입니다.',
      '여기는 704호 사물실 입니다.',
      '여기는 705호 사물실 입니다.',
      '여기는 706호 사물실 입니다.',
      '여기는 707호 사물실 입니다.',
      '여기는 708호 사물실 입니다.',
      '여기는 709호 사물실 입니다.',
      '여기는 710호 사물실 입니다.',
      '여기는 711호 사물실 입니다.',
      '여기는 712호 사물실 입니다.',
      '여기는 713호 사물실 입니다.',
      '여기는 714호 사물실 입니다.',
      '여기는 715호 사물실 입니다.',
      '여기는 716호 사물실 입니다.'
    ];

    if ((Provider.of<MainStatusModel>(context, listen: false).facilityNum!.isEmpty ||
            Provider.of<MainStatusModel>(context, listen: false).facilityName!.isEmpty) ||
        Provider.of<MainStatusModel>(context, listen: false).facilityDetail!.isEmpty) {
      for (int i = 0; i < officeQTY; i++) {
        setState(() {
          Provider.of<MainStatusModel>(context, listen: false)
              .facilityNum!
              .add('${701 + i}');
          Provider.of<MainStatusModel>(context, listen: false)
              .facilityName!
              .add(officeName[i]);
          Provider.of<MainStatusModel>(context, listen: false)
              .facilityDetail!
              .add(officeDetail[i]);
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                const AppBarAction(homeButton: true),
                const AppBarStatus(),
                Positioned(
                    top: 25,
                    left: 170,
                    child: TextButton(
                      onPressed: () {
                        navPage(context: context, page: FacilityListScreen()).navPageToPage();
                      },
                      style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2)),
                      child: const Text(
                        '입주사 목록',
                        style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ))
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 110,
            left: (1080 * 0.1) / 2,
            child: Container(
              width: 1080 * 0.9,
              height: 1920 * 0.7,
              decoration: const BoxDecoration(
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2))),
              child: const Center(
                child: Text(
                  '시설 안내도',
                  style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'kor',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          for (int i = 0; i < 16; i++)
            Positioned(
              top: i == 0
                  ? 200
                  : i == 1
                      ? 250
                      : i == 2
                          ? 300
                          : i == 3
                              ? (i % 3) * 50 + 200
                              : i == 4
                                  ? (i % 3) * 50 + 200
                                  : i == 5
                                      ? (i % 3) * 50 + 200
                                      : i == 6
                                          ? (i % 3) * 50 + 200
                                          : i == 7
                                              ? (i % 3) * 50 + 200
                                              : i == 8
                                                  ? (i % 3) * 50 + 200
                                                  : i == 9
                                                      ? (i % 3) * 50 + 200
                                                      : i == 10
                                                          ? (i % 3) * 50 + 200
                                                          : i == 11
                                                              ? (i % 3) * 50 +
                                                                  200
                                                              : i == 12
                                                                  ? (i % 3) *
                                                                          50 +
                                                                      200
                                                                  : i == 13
                                                                      ? (i % 3) *
                                                                              50 +
                                                                          200
                                                                      : i == 14
                                                                          ? (i % 3) * 50 +
                                                                              200
                                                                          : i == 15
                                                                              ? (i % 3) * 50 + 200
                                                                              : 0,
              left: i == 0
                  ? 200
                  : i == 1
                      ? 200
                      : i == 2
                          ? 200
                          : i == 3
                              ? 300
                              : i == 4
                                  ? 300
                                  : i == 5
                                      ? 300
                                      : i == 6
                                          ? 400
                                          : i == 7
                                              ? 400
                                              : i == 8
                                                  ? 400
                                                  : i == 9
                                                      ? 500
                                                      : i == 10
                                                          ? 500
                                                          : i == 11
                                                              ? 500
                                                              : i == 12
                                                                  ? 600
                                                                  : i == 13
                                                                      ? 600
                                                                      : i == 14
                                                                          ? 600
                                                                          : i == 15
                                                                              ? 700
                                                                              : 0,
              child: FilledButton(
                  onPressed: () {
                    // setState(() {
                    //   // Provider.of<MainStatusModel>(context, listen: false).facilityNum!.add(habioSevenOffice[i].officeNum!);
                    //   Provider.of<MainStatusModel>(context, listen: false).facilityNum![i] = habioSevenOffice[i].officeNum!;
                    // });
                    // print(Provider.of<MainStatusModel>(context, listen: false).facilityNum![i]);
                    // print(habioSevenOffice[i].officeNum);
                    facilityInform(context, i);
                  },
                  child: Text('${i + 701}')),
            ),
        ],
      ),
    );
  }
}
