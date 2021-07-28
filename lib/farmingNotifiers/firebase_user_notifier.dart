import 'package:flutter/foundation.dart';
import 'package:xivah/farming/firebaseController.dart';
import 'package:xivah/farmingEvents/login_events.dart';

class FirebaseUserNotifier with ChangeNotifier {
  FirebaseUserController _firebaseUserController;
  LoginEvents _loginEvents;

  FirebaseUserNotifier.forLogin() {
    _firebaseUserController = FirebaseUserController.forLogIn();
  }
  FirebaseUserNotifier.forloginCheck() {
    _firebaseUserController = FirebaseUserController.loginCheck();
  }

  getUser() async {
    _loginEvents = LoadingLogin();
    notifyListeners();
    _firebaseUserController.signInWithGoogle().then((value) {
      _loginEvents = value;
      notifyListeners();
    });
  }

  isLoggedIn() async {
    print("clicked");
    _loginEvents = LoadingLogin();
    notifyListeners();
    await Future.delayed(
      Duration(seconds: 1),
    );
    _firebaseUserController.isSignedIn().then((value) {
      _loginEvents = value;
      notifyListeners();
    });
  }

  LoginEvents get loginEvents => _loginEvents;
}
