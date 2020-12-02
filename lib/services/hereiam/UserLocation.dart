import 'package:json_annotation/json_annotation.dart';

import 'package:im_here/services/hereiam/UserInfo.dart';
import 'package:im_here/services/hereiam/LocationInfo.dart';

part 'UserLocation.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable()
class UserLocation {

  UserInfo user;
  LocationInfo location;

  UserLocation({ this.user, this.location });

  bool equals(UserLocation other) {
    return this.user.equals(other.user)
        && this.location.equals(other.location);
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}