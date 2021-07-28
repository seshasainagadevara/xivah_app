import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/farming/pageRouteController.dart';
import 'package:xivah/farmingEvents/locationFetchEvents.dart';
import 'package:xivah/farmingNotifiers/location_notifier.dart';
import 'package:xivah/lands/homeScreen.dart';

class LocationSetScreen extends StatefulWidget {
  @override
  _LocationSetScreenState createState() => _LocationSetScreenState();
}

class _LocationSetScreenState extends State<LocationSetScreen>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  Tween _tween;
  LocationNotifier _locationNotifier;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tween = Tween(begin: -1.0, end: 0.0);
    _animation = _tween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutSine));
    _animationController.forward();
    _locationNotifier = LocationNotifier();
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
    return ChangeNotifierProvider<LocationNotifier>(
      create: (BuildContext context) => _locationNotifier,
      child: Scaffold(
          backgroundColor: Konstants.whiteBackground,
          body: Container(
            height: height,
            width: width,
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform: Matrix4.translationValues(
                          0.0, _animation.value * height, 0.0),
                      child: ClipPath(
                        clipper: CustomClipperr(),
                        child: Container(
                          color: Konstants.clrBackground1.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 123,
                        child: SvgPicture.asset(
                          Konstants.location_img,
                          height: height * 0.40,
                          width: width / 2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text:
                                    "One step ahead to discover stores around you.",
                                style: Konstants.textStyleSubHead),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: width,
                      child: MaterialButton(
                        splashColor: Konstants.clrBackground1.withOpacity(0.2),
                        color: Konstants.clrBackground1,
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        textColor: Colors.white,
                        onPressed: () => _locationNotifier.fetchLocation(),
                        child: Text("Set location",
                            style: Konstants.textStyleBtnText),
                      ),
                    ),
                  ),
                ),
                Consumer<LocationNotifier>(
                  builder: (BuildContext context, LocationNotifier value, _) {
                    if (value == null)
                      return Konstants.nothing;
                    else if (value.fetchEvents is LocationLoading)
                      return Container(
                        color: Konstants.clrBlack54,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Konstants.clrBackground1),
                            backgroundColor: Konstants.whiteBackground,
                          ),
                        ),
                      );
                    else if (value.fetchEvents is LocationNotFetched) {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.transparent,
                                duration: Duration(seconds: 3),
                                elevation: 0.0,
                                content: Container(
                                  height: 50.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Center(
                                    child: Text(
                                      "Accept location request.",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  ),
                                  color: Colors.red,
                                ),
                              )));
                    } else if (value.fetchEvents is LocationFetched)
                      _animationController.reverse();
                    Future.delayed(
                      Duration(
                        milliseconds: 300,
                      ),
                      () async => await Navigator.of(context).pushReplacement(
                        PageRouteControll(HomeScreen(fromLocScreen: true)),
                      ),
                    );

                    return Konstants.nothing;
                  },
                )
              ],
            ),
          )),
    );
  }
}

class CustomClipperr extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(0.0, size.height / 2);
    path.quadraticBezierTo(
        size.width * 0.40, size.height / 3, size.width / 2, size.height / 2);
    path.quadraticBezierTo(0.60 * size.width, size.height * 0.50 + 80,
        size.width, size.height / 2);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
