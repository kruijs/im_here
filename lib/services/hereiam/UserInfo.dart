import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';

/// !Start the watcher by running flutter pub run build_runner watch in the project root.
/// !running flutter pub run build_runner build in the project root, 
/// you generate JSON serialization code
@JsonSerializable()
class UserInfo {

  String? name;
  String? color;

  UserInfo({ this.name, this.color });

  bool equals(UserInfo? other) {
    return this.name == other?.name
        && this.color == other?.color;
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}