import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationData {
  final GeoPoint latLong;
  final String country;
  final String city;
  final String countryCode;
  final String postalCode;
  final String district;
  final String subCity;
  final String streetAddr;
  final String state;

  UserLocationData(
      {this.latLong,
      this.country,
      this.city,
      this.countryCode,
      this.postalCode,
      this.district,
      this.subCity,
      this.state,
      this.streetAddr});

  factory UserLocationData.fromPositionFuser({Placemark placemark}) {
    return UserLocationData(
      latLong:
          GeoPoint(placemark.position.latitude, placemark.position.longitude),
      country: placemark.country,
      city: placemark.locality,
      countryCode: placemark.isoCountryCode,
      postalCode: placemark.postalCode,
      district: placemark.subAdministrativeArea,
      subCity: placemark.subLocality,
      streetAddr: placemark.thoroughfare,
      state: placemark.administrativeArea,
    );
  }

  Map<String, dynamic> getUserDataMap() {
    return {
      "geoPoint": latLong,
      "country": country,
      "city": city,
      "countryCode": countryCode,
      "postalCode": postalCode,
      "district": district,
      "subCity": subCity,
      "state": state,
      "streetAddress": streetAddr,
    };
  }
}
