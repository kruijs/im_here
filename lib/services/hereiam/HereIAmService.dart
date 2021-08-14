import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:im_here/services/hereiam/UserInfo.dart';

import 'package:im_here/services/device/DeviceUidProvider.dart';
import 'package:im_here/services/LocationProvider.dart';

import 'package:im_here/services/hereiam/LocationInfo.dart';
import 'package:im_here/services/hereiam/UserLocation.dart';

class HereIAmService extends ChangeNotifier {

  final DeviceUidProvider _deviceUidProvider;
  final String _serviceUri;
  final LocationProvider _location;

  final List<UserLocation> _locations = [];

  Timer? _timerSettings;
  Timer? _timerLocation;

  String? _mac;
  String? _name;
  String? _color;

  bool _sendingfailed = false;
  bool _loadingfailed = false;

  HereIAmService(this._serviceUri, this._location, this._deviceUidProvider) {
    this._location.addListener(this.sendCurrentLocation);
  }

  @override
  void dispose() {
    this._timerSettings?.cancel();
    this._timerLocation?.cancel();
    this._location.removeListener(this.sendCurrentLocation);
    super.dispose();
  }

  Future<void> initialize(String name, String color, int sendLocationInterval) async {

    print("HereIAmService:initialize");

    if (this._timerSettings != null) {
      this._timerSettings?.cancel();
      this._timerSettings = null;
    }
    
    if (this._timerLocation != null) {
      this._timerLocation?.cancel();
      this._timerLocation = null;
    }
    
    this._name = name;
    this._color = color;

    this._mac = await this._deviceUidProvider.getDeviceUid();
    
    await this.sendSettings();
    
    await this._location.getCurrentLocation();
    await this.sendCurrentLocation();
    
    this._timerSettings = Timer.periodic(
      Duration(seconds: sendLocationInterval * 2), 
      (t) async => await this.sendSettings());
      
    this._timerLocation = Timer.periodic(
      Duration(seconds: sendLocationInterval), 
      (t) async => await this.sendCurrentLocation());
  }

  bool get isInitialized {
    return this._mac != null;
  }

  bool get sendingfailed {
    return this._sendingfailed == true;
  }
  
  bool get loadingfailed {
    return this._loadingfailed == true;
  }

  LatLng? get currentLocation {
    return this._location.current;
  }

  List<UserLocation> get locations  {
    return this._locations;
  }

  Future<void> sendCurrentLocation() async {

    if (!this.isInitialized
      || this._location.current == null) {
      return;
    }

    print("HereIAmService:sendCurrentLocation");

    var location = LocationInfo(
      timestamp: DateTime.now().toIso8601String().split('.').first,
      long: this._location.current?.longitude,
      lat: this._location.current?.latitude
    );
   
    var data = location.toJson();

    var locations = await this._post({ "location": data });
    _setLocations(locations);
  }
  
  Future<void> sendSettings() async {

    print("HereIAmService:sendSettings");

    if (!this.isInitialized
      || this._location.current == null) {
      return;
    }

    var user = UserInfo(
      name: this._name,
      color: this._color);
   
    var data = user.toJson();
    await this._post({ "user": data });
  }
  
  void _setLocations(List<UserLocation> locations) {

    var changed = false;
    
    for (var i = 0; i < locations.length; i++) {
      if (this._locations.length < i + 1) {
        changed = true;
        this._locations.add(locations[i]);
      } else {
        if (!this._locations[i].equals(locations[i])) {
          changed = true;
          this._locations[i] = locations[i];
        }
      }
    }

    if (this._locations.length > locations.length) {
      changed = true;
      this._locations.removeRange(locations.length, this._locations.length - locations.length);
    }

    if (changed) {
      this.notifyListeners();
    }

  }
/*
  Future<List<UserLocation>> _getLocations() async {
  
    print("HereIAmService:getLocations");

    var uri = '${this._serviceUri}/data';

    try
    {
      print("GET " + uri);
      Response<Map> response = await Dio().get(uri);
      
      this._loadingfailed = false;
      
      return this._getLocationsFromResponse(response);

    } catch (ex) {

      print(ex);
      if (this._loadingfailed != true) {
        this._loadingfailed = true;
        this.notifyListeners();
      }

      return [];
    }
  }
*/
  List<UserLocation> _getLocationsFromResponse(Response<Map> response) {
     var data = response.data;

      List<UserLocation>  result = [];
      if (data != null) {

        data.entries
            .forEach((entry) {
              var info = UserLocation.fromJson(entry.value);
              if (info.location?.point != null) {
                  info.key = entry.key;
                  result.add(info);
              }
            });
      }

      return result;
  }

  Future<List<UserLocation>> _post(Map data) async {
    var uri = '${this._serviceUri}/data/${this._mac}';
    
    try
    {
      print("POST " + uri);
      Response<Map> response = await Dio().post(
        uri, 
        data: data, 
        options: Options(
          followRedirects: false,
          validateStatus: (status) { return (status ?? 200) < 500; }
        )
      );

      this._sendingfailed = false;

      return this._getLocationsFromResponse(response);
      
    } catch (ex) {

      print(ex);
      if (this._sendingfailed != true) {
        this._sendingfailed = true;
        this.notifyListeners();
      }

    }

    return [];
  }
}