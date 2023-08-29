import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';

class AdminPWModal extends StatefulWidget {
  const AdminPWModal({Key? key}) : super(key: key);

  @override
  State<AdminPWModal> createState() => _AdminPWModalState();
}

class _AdminPWModalState extends State<AdminPWModal> {
  late MainStatusModel _mainStatusProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  final TextEditingController pwrController = TextEditingController();

  late bool _pwrCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pwrCheck = true;
    _initAudio();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    return Center(
      child: Container(
          // padding: const EdgeInsets.only(top: 607),
          width: 540,
          height: 600,
          decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Colors.grey, width: 4),
              ),
              borderRadius: BorderRadius.circular(50),
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          child: AlertDialog(
            alignment: Alignment.topCenter,
            content: Stack(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('패스워드 입력',
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    height: 60,
                    width: 400,
                    child: TextField(
                      onTap: () {
                        setState(() {
                          pwrController.text = '';
                        });
                      },
                      controller: pwrController,
                      style: const TextStyle(
                          fontFamily: 'kor', fontSize: 25, color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        height: 30,
                        child: Offstage(
                          offstage: _pwrCheck,
                          child: Text('비밀번호를 틀렸습니다', style: TextStyle(
                            fontFamily: 'kor',
                            fontSize: 20,
                            color: Colors.white
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.lightBlue, width: 2),
                                borderRadius: BorderRadius.circular(30)),
                            fixedSize: const Size(125, 120)),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _effectPlayer.seek(const Duration(seconds: 0));
                            _effectPlayer.play();
                            if(pwrController.text == '0000'){
                              setState(() {
                                _mainStatusProvider.debugMode = false;
                                pwrController.text = '';
                              });
                              navPage(context: context, page: TraySelectionFinal()).navPageToPage();
                            }else{
                              setState(() {
                                _pwrCheck = false;
                              });
                            }
                          });
                        },
                        child: const Center(
                          child: Text(
                            '확인',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            backgroundColor: Colors.transparent,
            contentTextStyle: Theme.of(context).textTheme.headlineLarge,
          )),
    );
  }
}
