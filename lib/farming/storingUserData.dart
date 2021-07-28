import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xivah/crops/firebaseusr_data.dart';
import 'package:xivah/crops/location_data.dart';

class UserDataPusher {
  Firestore _firestore;
  DocumentReference _documentReference;
  UserDataPusher({String UID}) {
    String key = UID.applyCodeUnit();
    _firestore = Firestore.instance;
    _documentReference =
        _firestore.collection("xivah/client/users").document(key);
  }
  Future<bool> storeUserLocationData(UserLocationData userLocationData) async {
    try {
      await _firestore.runTransaction((transaction) => transaction.update(
          _documentReference, userLocationData.getUserDataMap()));
      return true;
    } catch (error) {
      print("error at: storing loc user");
      return false;
    }
  }

  Future storeUserData(UserData userData) async {
    try {
      await _firestore.runTransaction((transaction) =>
          transaction.set(_documentReference, userData.toMap()));
    } catch (error) {
      print("error at: storing user");
      return error;
    }
  }

  Future updateUserData(Map<String, dynamic> userdata) async {
    try {
      await _firestore.runTransaction(
          (transaction) => transaction.update(_documentReference, userdata));
    } catch (error) {
      print("error at: updating user");
      return error;
    }
  }
}

extension codeUnit on String {
  String applyCodeUnit() {
    int total = 0;
    int length = this.length;
    for (int i = 0; i < length; i++) {
      total += this.codeUnitAt(i);
    }
    return this + total.toString();
  }
}
