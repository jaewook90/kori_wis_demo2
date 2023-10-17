import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityListScreen extends StatefulWidget {
  const FacilityListScreen({Key? key}) : super(key: key);

  @override
  State<FacilityListScreen> createState() => _FacilityListScreenState();
}

class _FacilityListScreenState extends State<FacilityListScreen> {
  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;
  late List<String> officeDetail;

  late String backgroundImage;

  late String searchResult;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  final TextEditingController searchingController = TextEditingController();

  // String searchText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();
    searchResult = '';
    backgroundImage = "assets/screens/Facility/FacilityList.png";
    for (int i = 0;
        i <
            Provider.of<MainStatusModel>(context, listen: false)
                .facilityNum!
                .length;
        i++) {
      setState(() {
        officeNum =
            Provider.of<MainStatusModel>(context, listen: false).facilityNum!;
        officeName =
            Provider.of<MainStatusModel>(context, listen: false).facilityName!;
        officeDetail = Provider.of<MainStatusModel>(context, listen: false)
            .facilityDetail!;
      });
    }
    officeQTY = officeNum.length;
    // }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                    right: 55,
                    top: 30,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(206, 85),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              // side: BorderSide(
                              //   color: Colors.tealAccent,
                              //   width: 1
                              // )
                            )),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            Future.delayed(const Duration(milliseconds: 230),
                                () {
                              _effectPlayer.dispose();
                              navPage(
                                      context: context,
                                      page: const FacilityScreen())
                                  .navPageToPage();
                            });
                          });
                        },
                        child: null)),
                const AppBarStatus(

                ),
              ],
            ),
          )
        ],
        toolbarHeight: 150,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 225),
              child: Column(
                children: [
                  Container(
                    width: 1080 * 0.95,
                    height: 80,
                    child: TextField(
                      controller: searchingController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff5e5e5e),
                        hintText: '원하시는 장소를 입력해주세요',
                        hintStyle: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 35,
                          color: Color(0xffaeaeae),
                        ),
                        hintTextDirection: TextDirection.ltr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                          borderSide: BorderSide(color: Colors.white, width: 5),
                        ),
                        prefix: SizedBox(
                          width: 15,
                        ),
                        suffixIcon: SizedBox(
                          width: 110,
                          child: Center(
                            child: searchResult.isEmpty ? IconButton(
                              onPressed: () {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                WidgetsBinding.instance.addPostFrameCallback((_){
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    _effectPlayer.dispose();
                                    setState(() {
                                      searchResult = searchingController.text;
                                    });
                                  });
                                });
                                FocusScope.of(context).unfocus();
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                    overlays: []);
                              },
                              icon: Icon(
                                Icons.search,
                                // size: 55,
                                color: Color(0xffaeaeae),
                              ),
                              iconSize: 55,
                            ) : IconButton(
                              onPressed: () {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                WidgetsBinding.instance.addPostFrameCallback((_){
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    _effectPlayer.dispose();
                                    setState(() {
                                      searchingController.text='';
                                      searchResult = '';
                                    });
                                  });
                                });
                                FocusScope.of(context).unfocus();
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                    overlays: []);
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                // size: 55,
                                color: Color(0xffaeaeae),
                              ),
                              iconSize: 55,
                            ),
                          ),
                        ),
                        // suffixIcon: SizedBox(
                        //   width: 80,
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.search,
                        //           size: 55, color: Color(0xffaeaeae)),
                        //     ],
                        //   ),
                        // ),
                      ),
                      textAlignVertical: TextAlignVertical.bottom,
                      style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 35,
                        color: Color(0xff000000),
                      ),
                      cursorColor: Colors.black,
                      // onChanged: (value) {
                      //   setState(() {
                      //     searchingController.text = value;
                      //   });
                      // },
                      onTap: () {
                        setState(() {
                          searchingController.text = '';
                        });
                      },
                      onSubmitted: (value) {
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                            overlays: []);
                        setState(() {
                          searchResult = searchingController.text;
                        });
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                            overlays: []);
                      },
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 30, left: (1080 * 0.05 / 4)),
                    itemCount: officeQTY,
                    itemBuilder: (context, index) {
                      if (searchResult.isNotEmpty &&
                          (!officeName[index]
                                  .toLowerCase()
                                  .contains(searchResult.toLowerCase()) &&
                              !officeNum[index].contains(searchResult))) {
                        return const SizedBox.shrink();
                      } else {
                        return Column(
                          children: [
                            Card(
                              elevation: 3,
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              child: ListTile(
                                title: Stack(children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(officeNum[index].toString(),
                                            style: const TextStyle(
                                              fontFamily: 'kor',
                                              fontSize: 35,
                                            )),
                                      ),
                                      Text(officeName[index],
                                          style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 35,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            border: const Border.fromBorderSide(
                                              BorderSide(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            SizedBox(
                                              height: 53,
                                              child: Text('안내시작',
                                                  style: TextStyle(
                                                      fontFamily: 'kor',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.8)),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                                height: 53,
                                                child: Icon(
                                                  Icons.play_arrow_outlined,
                                                  color: Colors.white,
                                                  size: 40,
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      )
                                    ],
                                  )
                                ]),
                                tileColor: Colors.transparent,
                                textColor: Colors.white,
                                onTap: () {
                                  _effectPlayer.seek(const Duration(seconds: 0));
                                  _effectPlayer.play();
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    facilityInform(context, index);
                                  });
                                },
                              ),
                            ),
                            const Divider(
                              height: 10,
                              indent: 30,
                              endIndent: 40,
                              thickness: 5,
                              color: Color(0xff2b2b2b),
                            )
                          ],
                        );
                      }
                    },
                  )),
                ],
              ),
            )
          ],
        ),
        // Stack(
        //   children: [
        //     Positioned(
        //       top: 225,
        //       left: 1080 * 0.05 / 2,
        //       child: Container(
        //         width: 1080 * 0.95,
        //         height: 50,
        //         // decoration: BoxDecoration(
        //         //   borderRadius: BorderRadius.circular(30),
        //         //   border: Border.fromBorderSide(
        //         //     BorderSide(
        //         //       width: 1,
        //         //       color: Colors.white
        //         //     )
        //         //   )
        //         // ),
        //         child: TextField(
        //           controller: searchingController,
        //           decoration: const InputDecoration(
        //             filled: true,
        //             fillColor: Color(0xff5e5e5e),
        //             hintText: '원하시는 장소를 입력해주세요',
        //             hintStyle: TextStyle(
        //               fontFamily: 'kor',
        //               fontSize: 25,
        //               color: Color(0xffaeaeae),
        //             ),
        //             hintTextDirection: TextDirection.ltr,
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(30)),
        //               borderSide: BorderSide(color: Colors.white, width: 5),
        //             ),
        //             // prefix: ,
        //             // suffixIcon: SizedBox(
        //             //   height: 50,
        //             //   width: 60,
        //             //   child: Center(
        //             //     child: IconButton(
        //             //       onPressed: () {
        //             //
        //             //       },
        //             //       icon: Icon(Icons.search,
        //             //           size: 35, color: Color(0xffaeaeae),),
        //             //     ),
        //             //   ),
        //             // ),
        //             suffixIcon: SizedBox(
        //               width: 60,
        //               child: Row(
        //                 children: [
        //                   Icon(Icons.search, size: 45, color: Color(0xffaeaeae)),
        //                 ],
        //               ),
        //             ),
        //           ),
        //           textAlignVertical: TextAlignVertical.bottom,
        //           style: const TextStyle(
        //             fontFamily: 'kor',
        //             fontSize: 25,
        //             color: Color(0xff000000),
        //           ),
        //           cursorColor: Colors.black,
        //           onChanged: (value) {
        //             setState(() {
        //               searchingController.text = value;
        //             });
        //           },
        //           onTap: () {
        //             setState(() {
        //               searchingController.text = '';
        //             });
        //           },
        //           onSubmitted: (value) {
        //             SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        //                 overlays: []);
        //           },
        //           onTapOutside: (event) {
        //             FocusScope.of(context).unfocus();
        //             SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        //                 overlays: []);
        //           },
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //       top: 300,
        //       child: Column(
        //         children: [
        //           Expanded(
        //               child: ListView.builder(
        //                 padding: EdgeInsets.only(top: 10, bottom: 10),
        //                 itemCount: officeQTY,
        //                 itemBuilder: (context, index) {
        //                   if (searchingController.text.isNotEmpty &&
        //                       (!officeName[index].toLowerCase().contains(
        //                           searchingController.text.toLowerCase()) &&
        //                           !officeNum[index]
        //                               .contains(searchingController.text))) {
        //                     return const SizedBox.shrink();
        //                   } else {
        //                     return Card(
        //                       elevation: 3,
        //                       color: Colors.transparent,
        //                       shadowColor: Colors.transparent,
        //                       surfaceTintColor: Colors.transparent,
        //                       child: ListTile(
        //                         title: Row(
        //                           children: [
        //                             SizedBox(
        //                               width: 120,
        //                               child: Text(officeNum[index].toString()),
        //                             ),
        //                             Text(officeName[index]),
        //                           ],
        //                         ),
        //                         // hoverColor: Colors.transparent,
        //                         tileColor: Colors.transparent,
        //                         textColor: Colors.white,
        //                         onTap: () {
        //                           facilityInform(context, index);
        //                         },
        //                       ),
        //                     );
        //                   }
        //                 },
        //               )),
        //         ],
        //       ),
        //     ),
        //     const VerticalDivider(
        //       color: Colors.white,
        //       thickness: 10,
        //       width: 1080,
        //     ),
        //     const Divider(
        //       color: Colors.white,
        //       thickness: 10,
        //       height: 1920,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
