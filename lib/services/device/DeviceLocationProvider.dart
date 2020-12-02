import 'dart:async';

import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import 'package:im_here/services/LocationProvider.dart';

class DeviceLocationProvider extends LocationProvider {

  LatLng _current;

  final Location _location = new Location();
  StreamSubscription<LocationData> _subscription;

  DeviceLocationProvider() {
    this._subscription = this._location.onLocationChanged
        .listen(this.locationChanged);
  }

  LatLng get current => _current;

  @override
  void dispose() {    

    if( this._subscription != null) {
      this._subscription.cancel();
    }

    super.dispose();
  }

  void locationChanged(LocationData data) {
    
    if (this._current == null
    || this._current.latitude != data.latitude
    || this._current.longitude != data.longitude) {
      
      print("DeviceLocationProvider:locationChanged");
      this._current = new LatLng(data.latitude, data.longitude);
      this.notifyListeners();

    }
  }

  Future<LatLng> getCurrentLocation() async {
    
    print("DeviceLocationProvider:getCurrentLocation");

    if (await this.isEnabled()
     && await this.isPermitted()) {
      var result = await this._location.getLocation();
      return LatLng(result.latitude, result.longitude);
    }

    return null;
  }

  Future<bool> isEnabled() async {
    var enabled = await this._location.serviceEnabled();
    if (!enabled) {
      enabled = await this._location.requestService();
    }

    return enabled;
  }

  Future<bool> isPermitted() async {
    return await this._location.hasPermission() == PermissionStatus.granted
        || await this._location.requestPermission() == PermissionStatus.granted;
  }
}
