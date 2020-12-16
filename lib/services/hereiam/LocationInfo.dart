import 'package:json_annotation/json_annotation.dart';
import 'package:latlong/latlong.dart';

import 'package:im_here/helpers/DateTimeExtensions.dart';

part 'LocationInfo.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable()
class LocationInfo {

  double long;
  double lat;

  String timestamp;

  LatLng get point  {
    return this.lat != null && this.long != null 
      ? LatLng(this.lat, this.long) 
      : null;
  }

  LocationInfo({ this.timestamp, this.long, this.lat });

  Duration get age {
    
    return timestamp != null 
      ? DateTime.now().difference(this.timestamp.parseIso6801String())
      : null;
  }

  bool equals(LocationInfo other) {
    return this.timestamp == other.timestamp
        && this.long == other.long  
        && this.lat == other.lat;
  }

  factory LocationInfo.fromJson(Map<String, dynamic> json) => _$LocationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}