import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kori_wis_demo/Widgets/MainScreenButtonsFinal.dart';

class MainScreenFinal extends StatefulWidget {
  const MainScreenFinal({Key? key, this.parsePoseData}) : super(key: key);
  final dynamic parsePoseData;

  @override
  State<MainScreenFinal> createState() => _MainScreenFinalState();
}

class _MainScreenFinalState extends State<MainScreenFinal> with TickerProviderStateMixin {
  // late NetworkModel _networkProvider;

  // dynamic newPoseData;
  // dynamic poseData;

  DateTime? currentBackPressTime;
  final String _text = "뒤로가기 버튼을 한 번 더 누르시면 앱이 종료됩니다.";

  final String _wallpape = "assets/screens/koriZFinalHome.png";
  final String _fingerIcon = "assets/icons/pushIcon.png";


  // 버튼 디자인 위에 올리기
  double pixelRatio = 0.75;

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
    fToast = FToast();
    fToast?.init(context);

    // poseDataUpdate(widget.parsePoseData);
  }

  // void poseDataUpdate(dynamic parsePoseData) {
  //   newPoseData = parsePoseData;
  //   if (newPoseData != null) {
  //     poseData = newPoseData;
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _textAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // if (poseData == null) {
    //   poseData = _networkProvider.getPoseData;
    // }
    //
    // _networkProvider.getPoseData = poseData;

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(milliseconds: 1300)) {
          currentBackPressTime = now;
          fToast?.showToast(
              toastDuration: Duration(milliseconds: 1300),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      color: Color(0xff191919),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageIcon(
                            AssetImage('assets/logos/ExaIcon.png'),
                            size: 25,
                            color: Color(0xffB7B7B7),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Text(
                            _text,
                            style: Theme.of(context).textTheme.headlineLarge,
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
          title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // leading:
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/icons/appBar/appBar_Battery.png',
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
              Center(
                child: Text(
                  "시간",
                  style: TextStyle(fontFamily: 'kor', fontSize: 60),
                ),
              )
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
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(_wallpape))),
            child: Container(),
          ),
          MainScreenButtonsFinal(screens: 0),
          Positioned(
              left: 670 * pixelRatio,
              top: 1829 * pixelRatio,
              child: FadeTransition(
                opacity: _animation,
                child: SizedBox(
                  child: ImageIcon(
                    AssetImage(_fingerIcon),
                    color: Color(0xffB7B7B7),
                    size: 100,
                  ),
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 1970 * pixelRatio),
            child: Row(
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
