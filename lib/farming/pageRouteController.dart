import 'package:flutter/material.dart';

class PageRouteControll extends PageRouteBuilder {
  final Widget widget;

  PageRouteControll(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 800),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInSine,
                )),
                child: child,
              );
            });
}
