import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class TrackLocationService {

  LatLng? currentLatLang;
  LatLng? previousLatLang;

  void track() {
    Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      await setLangLong();
    });
  }

  Future<void> setLangLong() async {
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      currentLatLang = LatLng(currentLocation.latitude ?? 0.0,
          currentLocation.longitude ?? 0.0);
    } on Exception {
      currentLocation = null;
    }
  }
}
