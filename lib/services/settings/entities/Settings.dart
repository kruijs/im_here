import 'package:json_annotation/json_annotation.dart';

import 'package:im_here/services/settings/entities/Preferences.dart';

part 'Settings.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable(explicitToJson: true)
class Settings {

  Preferences preferences = new Preferences();

  Settings({this.preferences});

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}