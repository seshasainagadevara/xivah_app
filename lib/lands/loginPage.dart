import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/farming/pageRouteController.dart';
import 'package:xivah/farmingEvents/login_events.dart';
import 'package:xivah/farmingNotifiers/firebase_user_notifier.dart';
import 'package:xivah/lands/location_set.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  FirebaseUserNotifier _firebaseUserNotifier;
  @override
  void initState() {
    super.initState();
    _firebaseUserNotifier = FirebaseUserNotifier.forLogin();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn));
    _animationController.forward();
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
    return Scaffold(
      body: ChangeNotifierProvider<FirebaseUserNotifier>(
        create: (BuildContext context) => _firebaseUserNotifier,
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[
                  Konstants.clrBackground2.withOpacity(0.5),
                  Konstants.clrBackground1.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                        _animation.value * width, 0.0, 0.0),
                    child: Material(
                      color: Konstants.whiteBackground,
                      borderRadius: BorderRadius.circular(30.0),
                      elevation: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(30.0),
                        height: MediaQuery.of(context).size.height * 0.60,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                    text: "Swagatham",
                                    style: Konstants.textStyleSubHead2),
                              ),
                            ),
                            SvgPicture.asset(
                              Konstants.loginPic,
                              height: 120.0,
                              width: 120.0,
                              alignment: Alignment.center,
                            ),
                            Konstants.sizedBoxh10,
                            Container(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: "Login to discover more !",
                                    style: Konstants.textStyleSubHead),
                              ),
                            ),
                            Hero(
                              tag: 123,
                              child: MaterialButton(
                                onPressed: () {
                                  _firebaseUserNotifier.getUser();
                                },
                                splashColor:
                                    Konstants.clrBackground1.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Konstants.clrBackground1
                                          .withOpacity(0.7),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                highlightElevation: 5,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(
                                          "images/gicon.png",
                                        ),
                                        height: 25.0,
                                        fit: BoxFit.cover,
                                        //color: Colors.greenAccent,
                                      ),
                                      Konstants.sizedBoxw10,
                                      Text(
                                        'In with Google',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Konstants.clrBackground1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Consumer<FirebaseUserNotifier>(
              builder: (BuildContext context, FirebaseUserNotifier value, _) {
                if (value?.loginEvents is LoadingLogin) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: width,
                    color: Konstants.clrBlack87,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Konstants.clrBackground2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                } else if (value?.loginEvents is ErrorLogin) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                        content: Text(
                          "Hint: Check internet! try again.",
                          style: Konstants.textStyleBtnText,
                        ),
                      ),
                    ),
                  );
                } else if (value?.loginEvents is LoggedIn) {
                  _animationController.reverse();
                  Future.delayed(
                    Duration(milliseconds: 300),
                    () async {
                      await Navigator.of(context).pushReplacement(
                          PageRouteControll(LocationSetScreen()));
                    },
                  );
                }
                return Konstants.nothing;
              },
            ),
          ],
        ),
      ),
    );
  }
}
