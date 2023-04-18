import 'package:flutter/material.dart';

class KoriAppBar extends StatelessWidget implements PreferredSizeWidget{
  const KoriAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // leading:
      actions: [
        Container(
          width: 1080,
          height: 108,
          child: Stack(
            children: [
              Stack(children: [
                Positioned(
                    left: 30,
                    top: 18,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Backward.png',
                              ),
                              fit: BoxFit.fill)),
                    )),
                // Positioned(
                //     left: 30,
                //     top: 18,
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: Container(),
                //     ))
              ]),
              Stack(
                children: [
                  Positioned(
                      left: 130,
                      top: 25,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/appBar/appBar_Home.png',
                                ),
                                fit: BoxFit.fill)),
                      )),
                ],
              ),
              Stack(children: [
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
                    )),
              ]),
            ],
          ),
        )
        // SizedBox(width: screenWidth * 0.03)
      ],
      toolbarHeight: 110,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}