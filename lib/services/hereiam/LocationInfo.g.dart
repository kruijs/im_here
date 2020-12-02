// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) {
  return LocationInfo(
    json['timestamp'] as String,
    (json['long'] as num)?.toDouble(),
    (json['lat'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LocationInfoToJson(LocationInfo instance) =>
    <String, dynamic>{
      'long': instance.long,
      'lat': instance.lat,
      'timestamp': instance.timestamp,
    };
