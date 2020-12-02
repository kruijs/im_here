// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences()
    ..displayName = json['displayName'] as String
    ..color = json['color'] as String
    ..updateIntervalSeconds = json['updateIntervalSeconds'] as int;
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'color': instance.color,
      'updateIntervalSeconds': instance.updateIntervalSeconds,
    };
