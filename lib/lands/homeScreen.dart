import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:xivah/constants/konstants.dart';
import 'package:xivah/farming/internet_connection_checker.dart';
import 'package:xivah/farming/market_controller.dart';
import 'package:xivah/farming/pageRouteController.dart';
import 'package:xivah/farmingEvents/connection_status_data.dart';
import 'package:xivah/farmingEvents/locationFetchEvents.dart';
import 'package:xivah/farmingNotifiers/location_notifier.dart';
import 'package:xivah/lands/subLands/internetConnectionWidget.dart';

import 'subLands/drawer/side_app_drawer.dart';
import 'subLands/market_tab.dart';

class HomeScreen extends StatefulWidget {
  final bool fromLocScreen;
  HomeScreen({Key key, this.fromLocScreen}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InternetChecker _internetChecker;
  WidgetsBinding _binding;
  MarketController _marketController;
  LocationNotifier _locationNotifier;

  @override
  void initState() {
    _internetChecker = InternetChecker();
    if (!widget.fromLocScreen) {
      _locationNotifier = LocationNotifier();
      _locationNotifier.fetchLocation();
    }
//    _marketController = MarketController.updateCart();
//    Future.delayed(
//        Duration(milliseconds: 800), () => _marketController.updateCart());
//    _binding = WidgetsBinding.instance
//      ..addObserver(LifeCycleEventHandler(
//          detachedCall: () async => _marketController.updateCart()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromLocScreen)
      return Scaffold(
          backgroundColor: Konstants.whiteBackground, body: _scrnStack());
    else
      return _notFromLocScrn();
  }

  //screen content when not from loc set screen

  Widget _notFromLocScrn() {
    return ChangeNotifierProvider<LocationNotifier>(
      create: (BuildContext context) => _locationNotifier,
      child: Scaffold(
        backgroundColor: Konstants.whiteBackground,
        body: Consumer<LocationNotifier>(
            builder: (BuildContext context, LocationNotifier value, _) {
          if (value == null) return Konstants.nothing;
          if (value.fetchEvents is LocationFetched)
            return _scrnStack();
          else if (value.fetchEvents is LocationNotFetched)
            Navigator.of(context).pushReplacement(PageRouteControll(HomeScreen(
              fromLocScreen: false,
            )));
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingJumpingLine.square(
                    size: 35.0,
                  ),
                ),
                Text(
                  "Getting things...",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: Konstants.clrBlack87),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _scrnStack() {
    return Stack(
      children: <Widget>[
        SideAppDrawer(),
        MarketTab(),
        _callFloatingDiaolg(),
      ],
    );
  }

  //internet error func
  Widget _callFloatingDiaolg() {
    return StreamBuilder<InternetConnection>(
        stream: _internetChecker.stream,
        initialData: InternetConnectionSuccess(),
        builder: (context, snapshot) {
          if (snapshot.data is InternetConnectionSuccess)
            return Konstants.nothing;

          if (snapshot.error is InternetConnectionError)
            return InternetConnectionWidget();
        });
  }
}

///  update the cart items and remove items if day changed

class LifeCycleEventHandler extends WidgetsBindingObserver {
  final Function detachedCall;

  LifeCycleEventHandler({this.detachedCall});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await detachedCall();
        debugPrint("resumed");
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
        debugPrint("inactive");
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        await detachedCall();
        // TODO: Handle this case.
        break;
    }
  }
}
