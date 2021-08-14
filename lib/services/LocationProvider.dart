import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationProvider extends ChangeNotifier {

  LatLng? get current;
  Future<LatLng?> getCurrentLocation();
}