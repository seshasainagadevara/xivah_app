import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xivah/crops/firebaseusr_data.dart';
import 'package:xivah/farming/storingUserData.dart';
import 'package:xivah/farmingEvents/login_events.dart';

class FirebaseUserController {
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;
  SharedPreferences _sharedPreferences;

  FirebaseUserController.forLogIn()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  FirebaseUserController.loginCheck() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<LoginEvents> signInWithGoogle() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      return _firebaseAuth
          .signInWithCredential(await _googleSignIn.signIn().then(
              (googleUser) => googleUser.authentication
                  .then((googleAuth) => GoogleAuthProvider.getCredential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      ))))
          .then((value) async {
            if (value.additionalUserInfo.isNewUser)
              UserDataPusher(UID: value.user.uid)
                ..storeUserData(UserData.fromFUSER(value.user));
            else
              UserDataPusher(UID: value.user.uid)
                ..updateUserData({
                  "name": value.user.displayName,
                  "mail": value.user.email,
                });

            _sharedPreferences
                .setString("creds", value.user.uid)
                .then((value) => _sharedPreferences.reload());
          })
          .then((value) => LoggedIn())
          .catchError((error) => ErrorLogin());
    } catch (e) {
      return ErrorLogin();
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      SharedPreferences.getInstance().then((value) {
        value.clear();
        _firebaseAuth.signOut();
        GoogleSignIn()..signOut();
      })
    ]);
  }

  Future<LoginEvents> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    _sharedPreferences = await SharedPreferences.getInstance();
    if (currentUser != null && _sharedPreferences.containsKey("creds"))
      return LoggedIn();
    else
      return NotLoggedIn();
  }

  Future<FirebaseUser> getUser() {
    return _firebaseAuth.currentUser();
  }
}
