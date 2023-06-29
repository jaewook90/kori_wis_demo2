import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorPauseModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class NavModuleButtonsFinal extends StatefulWidget {
  final int? screens;
  final String? servGoalPose;

  const NavModuleButtonsFinal({
    Key? key,
    this.screens,
    this.servGoalPose,

  }) : super(key: key);

  @override
  State<NavModuleButtonsFinal> createState() => _NavModuleButtonsFinalState();
}

class _NavModuleButtonsFinalState extends State<NavModuleButtonsFinal> {
  late MainStatusModel _statusProvider;
  late NetworkModel _networkProvider;

  String? startUrl;
  String? stpUrl;
  String? rsmUrl;
  String? navUrl;
  String? chgUrl;

  String? currentGoal;

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late List<double> buttonSize1;
  late List<double> buttonSize2;

  late double buttonRadius1;
  late double buttonRadius2;

  late int buttonNumbers;

  int buttonWidth = 0;
  int buttonHeight = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
  }

  @override
  Widget build(BuildContext context) {
    _statusProvider = Provider.of<MainStatusModel>(context, listen: false);
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    stpUrl = _networkProvider.stpUrl;
    rsmUrl = _networkProvider.rsmUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    if(widget.servGoalPose != null){
      currentGoal = widget.servGoalPose;
    }

    if (widget.screens == 0) {
      // 이동 중
      buttonPositionWidth = [107];
      buttonPositionHeight = [1367];

      buttonSize = [866, 173];

      buttonRadius = 40;
    } else if (widget.screens == 1) {
      // 서빙 일시 정지
      buttonPositionWidth = [107, 107, 406, 705];
      buttonPositionHeight = [1311, 1501, 1501, 1501];

      buttonSize = [];
      buttonSize1 = [866, 160];
      buttonSize2 = [268, 205];

      buttonRadius1 = 40;
      buttonRadius2 = 32;
    }

    buttonNumbers = buttonPositionHeight.length;

    return Stack(children: [
      for (int i = 0; i < buttonNumbers; i++)
        Positioned(
          left: buttonPositionWidth[i],
          top: buttonPositionHeight[i],
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.screens == 1
                        ? i == 0
                        ? buttonRadius1
                        : buttonRadius2
                        : buttonRadius)),
                fixedSize: widget.screens == 1
                    ? i == 0
                    ? Size(
                    buttonSize1[buttonWidth], buttonSize1[buttonHeight])
                    : Size(
                    buttonSize2[buttonWidth], buttonSize2[buttonHeight])
                    : widget.screens == 2
                    ? i == 0
                    ? Size(buttonSize1[buttonWidth],
                    buttonSize1[buttonHeight])
                    : Size(buttonSize2[buttonWidth],
                    buttonSize2[buttonHeight])
                    : Size(
                    buttonSize[buttonWidth], buttonSize[buttonHeight])),
            onPressed: widget.screens == 0
                ? () {
              PostApi(
                  url: startUrl,
                  endadr: stpUrl,
                  keyBody: 'stop')
                  .Posting(context);
              navPage(
                  context: context,
                  page: NavigatorPauseModuleFinal(
                      servGoalPose: currentGoal
                  ),
                  enablePop: false)
                  .navPageToPage();
              // 일시정지 명령 추가 필요
            }
                : widget.screens == 1
                ? () {
              if (i == 0) {
                // 재시작 추가 필요
                PostApi(
                    url: startUrl,
                    endadr: rsmUrl,
                    keyBody: 'stop')
                    .Posting(context);
                navPage(
                    context: context,
                    page: const NavigatorProgressModuleFinal(),
                    enablePop: false)
                    .navPageToPage();
                _statusProvider.playAd = false;
              } else if (i == 1) {
                // 충전하러가기 기능
                PostApi(
                    url: startUrl,
                    endadr: chgUrl,
                    keyBody: 'charging_pile').Posting(context);
                _networkProvider.currentGoal = '충전스테이션';
                navPage(
                    context: context,
                    page: const NavigatorProgressModuleFinal(),
                    enablePop: false)
                    .navPageToPage();
                _statusProvider.playAd = false;
              } else if (i == 2) {
                // 추후에는 골 포지션 변경을 하며 자율주행 명령 추가
                _statusProvider.playAd = false;
              } else {
                // 추후에는 거점으로 복귀
                PostApi(
                    url: startUrl,
                    endadr: chgUrl,
                    keyBody: 'charging_pile').Posting(context);
                _networkProvider.currentGoal = '충전스테이션';
                navPage(
                    context: context,
                    page: const NavigatorProgressModuleFinal(),
                    enablePop: false)
                    .navPageToPage();
                _statusProvider.playAd = false;
              }
            }
                : null,
            child: null,
          ),
        ),
    ]);
  }
}
