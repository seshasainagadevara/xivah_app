import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String _name;
  String _mail;
  String _uid;
  int _timeStampMillis;

  UserData(this._name, this._mail, this._uid, this._timeStampMillis);

  factory UserData.fromFUSER(FirebaseUser firebaseUser) {
    return UserData(firebaseUser.displayName, firebaseUser.email,
        firebaseUser.uid, DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "mail": mail, "registeredOn": _timeStampMillis};
  }

  String get name => _name;

  String get uid => _uid;

  String get mail => _mail;
}
