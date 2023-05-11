import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_connector.dart';
import 'package:kori_wis_demo/Utills/ble/module/ble_device_interactor.dart';
import 'package:kori_wis_demo/Utills/ble/ui/device_detail/device_interaction_tab.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';
import 'package:provider/provider.dart';

class MainScreenFinal extends StatefulWidget {
  const MainScreenFinal({Key? key, this.parsePoseData, this.viewModel,
  }) : super(key: key);
  final dynamic parsePoseData;
  final DeviceInteractionViewModel? viewModel;

  @override
  State<MainScreenFinal> createState() => _MainScreenFinalState();
}

class _MainScreenFinalState extends State<MainScreenFinal>
    with TickerProviderStateMixin {

  late List<DiscoveredService> discoveredServices;

  DateTime? currentBackPressTime;
  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";

  final String _wallpape = "assets/screens/koriZFinalHome.png";
  final String _fingerIcon = "assets/icons/pushIcon.png";

  late final AnimationController _textAniCon = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _textAniCon,
    curve: Curves.easeOut,
  );

  FToast? fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discoveredServices = [];
    fToast = FToast();
    fToast?.init(context);
  }

  Future<void> discoverServices() async {
    final result = await widget.viewModel?.discoverServices();
    setState(() {
      discoveredServices = result!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(milliseconds: 1300)) {
          currentBackPressTime = now;
          fToast?.showToast(
              toastDuration: const Duration(milliseconds: 1300),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ImageIcon(
                            AssetImage('assets/icons/ExaIcon.png'),
                            size: 35,
                            color: Color(0xffB7B7B7),
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          Text(
                            _text,
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 35
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    )
                  ],
                ),
              ),
              gravity: ToastGravity.BOTTOM);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
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
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(_wallpape))),
            child: Container(),
          ),
          const MainScreenButtonsFinal(screens: 0),
          Positioned(
              left: 502.5,
              top: 1371.75,
              child: FadeTransition(
                opacity: _animation,
                child: SizedBox(
                  child: ImageIcon(
                    AssetImage(_fingerIcon),
                    color: const Color(0xffB7B7B7),
                    size: 100,
                  ),
                ),
              )),
          Container(
            margin: const EdgeInsets.only(top: 1477.5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '원하는 메뉴를 선택해주세요.',
                  style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 35,
                      color: Color(0xfff0f0f0)),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
