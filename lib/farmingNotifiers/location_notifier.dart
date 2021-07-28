import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xivah/farming/firebaseController.dart';
import 'package:xivah/farming/location_Controller.dart';
import 'package:xivah/farming/storingUserData.dart';
import 'package:xivah/farmingEvents/locationFetchEvents.dart';

class LocationNotifier extends ChangeNotifier {
  LocationController _locationController;
  SharedPreferences _sharedPreferences;
  LocationFetchEvents _fetchEvents;
  FirebaseUserController _firebaseUserController;
  UserDataPusher _dataPusher;

  LocationNotifier() {
    _firebaseUserController = FirebaseUserController.loginCheck();
    _locationController = LocationController();
    _getUser();
  }
  _getUser() async {
    await _firebaseUserController.getUser().then((firebaseUser) async {
      _sharedPreferences = await SharedPreferences.getInstance();
      _dataPusher = UserDataPusher(UID: firebaseUser.uid);
    });
  }

  fetchLocation() async {
    _notifier(LocationLoading());
    await _locationController.getCurrentLocation().then((loc) {
      if (loc.isFetched && loc.userLocationData != null) {
        _sharedPreferences
            .setString("geopoint", loc.userLocationData.latLong.toString())
            .then((value) {
          return _dataPusher
              .storeUserLocationData(loc.userLocationData)
              .then((value) {
            if (value)
              _notifier(LocationFetched());
            else
              _notifier(LocationNotFetched());
          });
        });
      } else if (!loc.isFetched) {
        print("location error");
        _notifier(LocationNotFetched());
      }
    });
  }

  _notifier(LocationFetchEvents event) {
    _fetchEvents = event;
    notifyListeners();
  }

  LocationFetchEvents get fetchEvents => _fetchEvents;
}
