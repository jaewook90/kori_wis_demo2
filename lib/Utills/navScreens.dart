import 'package:flutter/material.dart';

class navPage {
  final BuildContext context;
  final Widget page;
  // final bool enablePop;

  // navPage({required this.context, required this.page, required this.enablePop});
  navPage({required this.context, required this.page});

  void navPageToPage() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, page) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeOutSine;

            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return FadeTransition(
              opacity: animation.drive(tween),
              child: page,
            );
          },
        ));
  }
}
