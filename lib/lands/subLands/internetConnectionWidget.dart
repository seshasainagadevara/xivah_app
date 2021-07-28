import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xivah/constants/konstants.dart';

class InternetConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
//      color: Colors.black87,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SvgPicture.asset(
                Konstants.wifiErrorImg,
                alignment: Alignment.center,
                width: 150,
                height: 150,
              ),
            ),
            Text(
              "Please check Internet connection",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}
