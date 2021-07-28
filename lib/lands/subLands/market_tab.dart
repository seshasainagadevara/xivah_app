import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/lands/subLands/market_corousel.dart';

class MarketTab extends StatefulWidget {
  @override
  _MarketTabState createState() => _MarketTabState();
}

class _MarketTabState extends State<MarketTab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation, _borderRadiusTween;
  Icon _menu = Icon(Icons.menu);
  bool toggle = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0.0, end: 0.50).animate(CurvedAnimation(
      curve: Curves.easeOutSine,
      parent: _animationController,
    ));
    _borderRadiusTween = BorderRadiusTween(
            begin: BorderRadius.all(Radius.circular(0.0)),
            end: BorderRadius.all(Radius.circular(20.0)))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform:
              Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.70).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutSine,
            )),
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: _borderRadiusTween.value,
                color: Colors.white,
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: _menu,
                      onPressed: () {
                        toggle = !toggle;
                        if (toggle) {
                          _menu = Icon(Icons.call_missed);
                          _animationController.forward();
                        } else {
                          _menu = Icon(Icons.menu);
                          _animationController.reverse();
                        }
                      },
                    ),
                    actions: <Widget>[
                      // CartIcon(),
                    ],
                    iconTheme: IconThemeData(color: Colors.black87),
                    elevation: 0.0,
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    pinned: true,
                    centerTitle: true,
                    title: Text("Market", style: Konstants.textStyleHeading),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        MarketCarousel(),
//                MarketItems(),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "वसुधैव कुटुम्बकम् - Entire world is a family",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
//            MarketCarousel(),
//            MarketItems(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
