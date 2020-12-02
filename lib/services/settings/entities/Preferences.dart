import 'package:json_annotation/json_annotation.dart';

part 'Preferences.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable()
class Preferences {

  String displayName;
  String color;
  int updateIntervalSeconds;

  Preferences();

  factory Preferences.fromJson(Map<String, dynamic> json) => _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
