// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) {
  return UserLocation()
    ..key = json['key'] as String
    ..user = json['user'] == null
        ? null
        : UserInfo.fromJson(json['user'] as Map<String, dynamic>)
    ..location = json['location'] == null
        ? null
        : LocationInfo.fromJson(json['location'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'key': instance.key,
      'user': instance.user,
      'location': instance.location,
    };
