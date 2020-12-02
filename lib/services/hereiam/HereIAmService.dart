import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:im_here/services/hereiam/UserInfo.dart';
import 'package:latlong/latlong.dart';

import 'package:im_here/services/device/MacProvider.dart';
import 'package:im_here/services/device/DeviceLocationProvider.dart';

import 'package:im_here/services/hereiam/LocationInfo.dart';
import 'package:im_here/services/hereiam/UserLocation.dart';

class HereIAmService extends ChangeNotifier {

  final MacProvider _macProvider;
  final String _serviceUri;
  final DeviceLocationProvider _location;

  final List<UserLocation> _locations = [];

  Timer _timer;
  String _mac;
  String _name;
  String _color;

  bool _sendingfailed;
  bool _loadingfailed;

  HereIAmService(this._serviceUri, this._location, this._macProvider) {
    this._location.addListener(this.sendCurrentLocation);
  }

  @override
  void dispose() {
    this._timer.cancel();
    this._location.removeListener(this.sendCurrentLocation);
    super.dispose();
  }

  Future<void> initialize(String name, String color) async {

    print("HereIAmService:initialize");

    if (this._timer != null) {
      this._timer.cancel();
      this._timer = null;
    }
    
    this._name = name;
    this._color = color;

    this._mac = await this._macProvider.getMac();
    
    await this.sendSettings();
    
    await this._location.getCurrentLocation();
    await this.sendCurrentLocation();
    
    this._timer = Timer.periodic(
      Duration(seconds: 3), 
      (t) async => await this._updateLocations());
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

  LatLng get currentLocation {
    return this._location.current;
  }

  List<UserLocation> get locations  {
    return this._locations;
  }

  Future<void> sendCurrentLocation() async {

    print("HereIAmService:sendCurrentLocation");

    if (!this.isInitialized
      || this._location.current == null) {
      return;
    }

    var location = LocationInfo(
      DateTime.now().toIso8601String(),
      this._location.current.longitude,
      this._location.current.latitude);
   
    var data = location.toJson();
    await this._post({ "location": data });
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

  Future<void> _updateLocations() async {

    var changed = false;
    var locations = await this._getLocations();

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

  Future<List<UserLocation>> _getLocations() async {
  
    print("HereIAmService:getLocations");

    var uri = '${this._serviceUri}/data';

    try
    {
      print("GET " + uri);
      Response<Map> response = await Dio().get(uri);
      Map data = response.data;

      var result = List<UserLocation>();
      if (data != null && data.entries != null) {

        data.entries
            .forEach((entry) {
              var info = UserLocation.fromJson(entry.value);
              if (info != null
                && info.location != null
                && info.location.point != null) {
                  result.add(info);
              }
            });  

      }

      this._loadingfailed = false;
      
      return result;

    } catch (ex) {
      print(ex);
      
      if (this._loadingfailed != true) {
        this._loadingfailed = true;
        this.notifyListeners();
      }

      return null;
    }
  }

  Future<void> _post(Map data) async {
    var uri = '${this._serviceUri}/data/${this._mac}';
    
    try
    {
      print("POST " + uri);
      await Dio().post(
        uri, 
        data: data, 
        options: Options(
          followRedirects: false,
          validateStatus: (status) { return status < 500; }
        )
      );

      this._sendingfailed = false;
      
    } catch (ex) {
      print(ex);
      if (this._sendingfailed != true) {
        this._sendingfailed = true;
        this.notifyListeners();
      }
    }
  }
}