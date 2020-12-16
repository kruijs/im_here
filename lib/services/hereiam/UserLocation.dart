import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:im_here/services/hereiam/UserInfo.dart';
import 'package:im_here/services/hereiam/LocationInfo.dart';

import 'package:im_here/helpers/ColorExtensions.dart';

part 'UserLocation.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable()
class UserLocation {

  String key;
  UserInfo user = UserInfo();
  LocationInfo location = LocationInfo();

  UserLocation();

  Color get markerColor {

    var age = this.location.age;

    var isoffline = age == null || age > Duration(minutes: 10);

    return this.user != null
      ? this.user.color.parseToColor().withAlpha(isoffline ? 100 : 255)
      : null;
  }

  bool equals(UserLocation other) {
    return this.user != null && this.user.equals(other.user)
        && this.location != null && this.location.equals(other.location);
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}