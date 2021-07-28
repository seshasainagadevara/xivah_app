import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/crops/arkahaData.dart';

class OnBoardingPage extends StatelessWidget {
  final ArkahaData arkahaData;
  OnBoardingPage({Key key, this.arkahaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              arkahaData.assetName,
              alignment: Alignment.center,
              width: 200,
              height: 200,
            ),
          ),
          Konstants.sizedBoxh10,
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                text: arkahaData.title,
                style: Konstants.textStyleHeading,
              ),
            ),
          ),
          Konstants.sizedBoxh20,
          Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: arkahaData.description,
                  style: Konstants.textStyleSubHead),
            ),
          ),
        ],
      ),
    );
  }
}
