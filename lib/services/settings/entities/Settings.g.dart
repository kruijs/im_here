// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    preferences: json['preferences'] == null
        ? null
        : Preferences.fromJson(json['preferences'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'preferences': instance.preferences?.toJson(),
    };
