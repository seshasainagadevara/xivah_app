import 'package:geolocator/geolocator.dart';
import 'package:xivah/crops/fetch_loc_data.dart';
import 'package:xivah/crops/location_data.dart';

class LocationController {
  final Geolocator _geolocator;

  LocationController()
      : _geolocator = Geolocator()..forceAndroidLocationManager = true;

  Future<FetchLocModel> getCurrentLocation() async {
    try {
      Position _position = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      UserLocationData _locData = await _getAddressFromCoords(_position);
      return FetchLocModel(true, _locData);
    } catch (e) {
      print("loc error : ${e.toString()}");
      return FetchLocModel(false, null);
    }
  }

  Future<UserLocationData> _getAddressFromCoords(Position position) async {
    List<Placemark> _placemark =
        await _geolocator.placemarkFromPosition(position);
    Placemark _place = _placemark[0];

    print(_place.toJson().toString());

    return UserLocationData.fromPositionFuser(placemark: _place);
  }
}
