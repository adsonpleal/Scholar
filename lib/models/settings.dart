import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(nullable: true)
class Settings extends Equatable {
  @JsonKey(defaultValue: true)
  final bool allowNotifications;

  Settings({this.allowNotifications}) : super([allowNotifications]);
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings changeValue({allowNotifications}) => Settings(
        allowNotifications: allowNotifications ?? this.allowNotifications,
      );
}
