import 'package:flutter/material.dart';
import 'package:xivah/crops/arkahaData.dart';

class Konstants {
  static final List<ArkahaData> onBoardingSheets = [
    ArkahaData("images/place.svg", "Discover nearby !",
        "Discover and shop any product from your nearby stores."),
    ArkahaData("images/shopping_app.svg", "Shop with ease !",
        "Shop any product, available in and around your city."),
    ArkahaData("images/order_delivered.svg", "Delivery within minutes !",
        "Get your products within minutes of your order.")
  ];

  static final wifiErrorImg = "images/internet_searching.svg";
  static final location_img = "images/location.svg";
  static final loginPic = "images/login.svg";
  static const whiteBackground = Colors.white;
  static const nothing = Opacity(opacity: 0.0);
  static const clrBackground1 = Colors.indigo;
  static const clrBackground2 = Colors.blue;
  static const clrBlack87 = Colors.black87;
  static const clrBlack = Colors.black;
  static const clrBlack54 = Colors.black54;

  static const sizedBoxh10 = const SizedBox(
    height: 10.0,
  );
  static const sizedBoxh20 = const SizedBox(
    height: 20.0,
  );
  static const sizedBoxw10 = const SizedBox(
    width: 10.0,
  );
  static const sizedBoxw5 = const SizedBox(
    width: 5.0,
  );
  static const textStyleHeading = const TextStyle(
      fontSize: 17.0, fontWeight: FontWeight.w700, color: Konstants.clrBlack);
  static const textStyleSubHead = const TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: Konstants.clrBlack87);
  static const textStyleSubHead2 = const TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w500, color: Konstants.clrBlack54);

  static const textStyleBtnText = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: Konstants.whiteBackground);
}
