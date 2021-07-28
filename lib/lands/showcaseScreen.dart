import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/farming/internet_connection_checker.dart';
import 'package:xivah/farming/pageRouteController.dart';
import 'package:xivah/farmingEvents/connection_status_data.dart';
import 'package:xivah/farmingEvents/login_events.dart';
import 'package:xivah/farmingNotifiers/firebase_user_notifier.dart';
import 'package:xivah/farmingNotifiers/onBoardingPagesNotifier.dart';
import 'package:xivah/lands/loginPage.dart';
import 'package:xivah/lands/subLands/internetConnectionWidget.dart';
import 'package:xivah/lands/subLands/onBoardingPages.dart';

import 'homeScreen.dart';

class Arkaha extends StatefulWidget {
  const Arkaha({Key key}) : super(key: key);
  @override
  _ArkahaState createState() => _ArkahaState();
}

class _ArkahaState extends State<Arkaha> {
  final PageController _controller = PageController();
  OnBoardingPagesNotifier _boardingPagesNotifier;
  FirebaseUserNotifier _firebaseUserNotifier;
  final int _initialPos = 0;
  int _length;
  @override
  void initState() {
    _firebaseUserNotifier = FirebaseUserNotifier.forloginCheck();
    _length = Konstants.onBoardingSheets.length;
    _boardingPagesNotifier = OnBoardingPagesNotifier(_initialPos);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnBoardingPagesNotifier>(
          create: (BuildContext context) => _boardingPagesNotifier,
        ),
        StreamProvider<InternetConnection>(
          create: (BuildContext context) => InternetChecker().stream,
          catchError: (context, error) => error,
        ),
        ChangeNotifierProvider<FirebaseUserNotifier>(
            create: (BuildContext context) => _firebaseUserNotifier),
      ],
      child: Scaffold(
        backgroundColor: Konstants.whiteBackground,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Konstants.clrBackground1.withOpacity(0.2),
          child: Stack(
            children: <Widget>[
              Container(
                height: 70.0,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 50.0),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Text("XIVAH",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(color: Konstants.clrBlack, fontWeightDelta: 2)),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                      itemCount: _length,
                      controller: _controller,
                      onPageChanged: (index) {
                        _boardingPagesNotifier.controlDots(index);
                      },
                      itemBuilder: (BuildContext context, int index) =>
                          OnBoardingPage(
                        arkahaData: Konstants.onBoardingSheets[index],
                      ),
                    ),
                  ),
                  Consumer<OnBoardingPagesNotifier>(
                    builder: (BuildContext context, value, _) {
                      if (value == null)
                        return Konstants.nothing;
                      else if (value.position == _length - 1)
                        return InkWell(
                          onTap: () {
                            _firebaseUserNotifier.isLoggedIn();
                          },
                          child: Hero(
                            tag: "login",
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 350),
                              curve: Curves.easeInSine,
                              width: MediaQuery.of(context).size.width,
                              height: 65.0,
                              color: Konstants.clrBackground1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Shubharambh",
                                    style: Konstants.textStyleBtnText,
                                  ),
                                  Konstants.sizedBoxw10,
                                  Icon(
                                    CupertinoIcons.heart_solid,
                                    size: 20.0,
                                    color: Colors.red[400],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      return Container(
                        height: 65.0,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _texts("Skip",
                                CupertinoIcons.check_mark_circled_solid),
                            Row(
                              children: List.generate(_length, (index) {
                                if (index == value.position)
                                  return _dots(15.0);
                                else
                                  return _dots(8.0);
                              }),
                            ),
                            _texts("Next", CupertinoIcons.forward)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Consumer<FirebaseUserNotifier>(
                  builder: (BuildContext context, fvalue, _) {
                return Consumer<InternetConnection>(builder:
                    (BuildContext contex, InternetConnection ivalue, _) {
                  if (fvalue.loginEvents is LoadingLogin)
                    return Center(
                      child: LoadingBouncingGrid.square(
                        backgroundColor: Konstants.clrBackground1,
                        borderColor: Colors.white,
                      ),
                    );

                  if (ivalue is InternetConnectionSuccess &&
                      fvalue.loginEvents is LoggedIn) {
                    Future.delayed(
                        Duration(
                          milliseconds: 500,
                        ), () async {
                      await Navigator.of(context)
                          .pushReplacement(PageRouteControll(HomeScreen(
                        fromLocScreen: false,
                      )));
                    });
                  } else if (ivalue is InternetConnectionSuccess &&
                      fvalue.loginEvents is NotLoggedIn) {
                    Future.delayed(
                        Duration(
                          milliseconds: 500,
                        ), () async {
                      await Navigator.of(context)
                          .pushReplacement(PageRouteControll(LoginPage()));
                    });
                  } else if (ivalue is InternetConnectionError) {
                    return InternetConnectionWidget();
                  }
                  return Konstants.nothing;
                });
              })
            ],
          ),
        ),
//            bottomSheet:
      ),
    );
  }

  //pageview controll buttons
  Widget _texts(String label, IconData icon) {
    return InkWell(
      onTap: () async {
        if (label.contains("Skip")) {
          await _controller.animateToPage(_length - 1,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        } else {
          if (_controller.page.round() != (_length - 1)) {
            await _controller.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          } else {
            _boardingPagesNotifier.controlDots(_controller.page.round());
          }
        }
      },
      splashColor: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.0),
      child: Row(
        children: <Widget>[
          Align(
            child: RichText(
              text: TextSpan(
                  text: label,
                  style: TextStyle(
                      color: Konstants.clrBackground1,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0)),
            ),
          ),
          Konstants.sizedBoxw5,
          Icon(
            icon,
            size: 20.0,
            color: Colors.indigo,
          )
        ],
      ),
    );
  }

  //inidcator dots
  Widget _dots(double size) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 8.0,
        width: size,
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
