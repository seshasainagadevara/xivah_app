import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class CarouselShow extends StatefulWidget {
  final dynamic _corouselData;
  Function onTap;

  CarouselShow(this._corouselData, {this.onTap});

  @override
  _CarouselShowState createState() => _CarouselShowState();
}

class _CarouselShowState extends State<CarouselShow> {
  List<dynamic> _data;
  Function _onTap;

  @override
  void initState() {
    _data = widget._corouselData;
    _onTap = widget.onTap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Carousel(
      dotSize: 0.0,
      animationDuration: const Duration(milliseconds: 900),
      animationCurve: Curves.linearToEaseOut,
      indicatorBgPadding: 0.0,
      onImageTap: _onTap,
      images: _data.map((cData) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: _width,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: cData.imageUrl,
              fit: BoxFit.contain,
            ),
//          child: FadeInImage.memoryNetwork(
//            placeholder: kTransparentImage,
//            image: cData.imageUrl,

//            fit: BoxFit.fitWidth,
//          ),
          ),
        );
      }).toList(),
    );
  }
}
