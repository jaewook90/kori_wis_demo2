import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
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

  final TextEditingController searchingController = TextEditingController();

  // String searchText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    print(officeNum);
    print(officeName);
    print(officeDetail);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: const [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                AppBarAction(homeButton: true),
                AppBarStatus(),
              ],
            ),
          )
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              children: [
                TextField(
                  controller: searchingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    hintText: '검색어를 입력해주세요.',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    prefixIcon:
                        Icon(Icons.search, size: 60, color: Colors.black),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'kor',
                    fontSize: 40,
                  ),
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      searchingController.text = value;
                    });
                  },
                  onTap: (){
                    setState(() {
                      searchingController.text='';
                    });
                  },
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: officeQTY,
                  itemBuilder: (context, index) {
                    if (searchingController.text.isNotEmpty &&
                        (!officeName[index]
                            .toLowerCase()
                            .contains(searchingController.text.toLowerCase())&&!officeNum[index]
                            .contains(searchingController.text))) {
                      return SizedBox.shrink();
                    }
                    else {
                      return Card(
                        elevation: 3,
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(officeNum[index].toString()),
                              VerticalDivider(
                                color: Colors.white,
                                thickness: 3,
                                width: 40,
                              ),
                              Text(officeName[index]),
                            ],
                          ),
                          // hoverColor: Colors.transparent,
                          tileColor: Colors.transparent,
                          textColor: Colors.white,
                          onTap: () {
                            facilityInform(context, index);
                          },
                        ),
                      );
                    }
                  },
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
