import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSavingTest extends StatefulWidget {
  const DataSavingTest({Key? key}) : super(key: key);

  @override
  State<DataSavingTest> createState() => _DataSavingTestState();
}

class _DataSavingTestState extends State<DataSavingTest> {

  final TextEditingController _textEditingController = TextEditingController();
  late SharedPreferences _prefs; // SharedPreferences 객체

  @override
  void initState() {
    super.initState();
    _initSharedPreferences(); // SharedPreferences 초기화
  }

  // SharedPreferences 초기화 함수
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 데이터를 저장하는 함수
  Future<void> _saveData() async {
    _prefs.setString('myData', _textEditingController.text);  // 'myData' 키에 데이터 저장
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('저장완료')),  // 저장 완료 메시지 출력
    );
  }

  // 데이터를 로드하는 함수
  Future<void> _loadData() async {
    final myData = _prefs.getString('myData'); // 'myData' 키에 저장된 데이터 로드
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로드완료: $myData', style: TextStyle(fontSize: 60),)), // 로드 완료 메시지와 함께 데이터 출력
    );
  }

  Future<void> _resetData() async {
    _prefs.clear(); // 'myData' 키에 저장된 데이터 로드
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('초기화 완료', style: TextStyle(fontSize: 60),)), // 로드 완료 메시지와 함께 데이터 출력
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 10,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(90, 90),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
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
        ],
        toolbarHeight: 110,
        iconTheme: IconThemeData(size: 70, color: Color(0xfffefeff)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: 1080,
        height: 1920,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController, // 입력한 데이터를 가져오기 위한 컨트롤러
              decoration: InputDecoration(
                hintText: '저장할 데이터를 입력하세요.', // 힌트 텍스트
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveData, // 데이터 저장 버튼
                  child: Text('저장하기'),
                ),
                ElevatedButton(
                  onPressed: _loadData, // 데이터 로드 버튼
                  child: Text('불러오기'),
                ),
                ElevatedButton(
                  onPressed: _resetData, // 데이터 로드 버튼
                  child: Text('초기화'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
