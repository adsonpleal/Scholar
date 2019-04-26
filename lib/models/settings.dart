library settings;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'settings.g.dart';

abstract class Settings implements Built<Settings, SettingsBuilder> {
  bool get allowNotifications;

  Settings._();

  factory Settings([updates(SettingsBuilder b)]) => _$Settings((b) => b
    ..allowNotifications = true
    ..update(updates));

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Settings.serializer, this);
  }

  static Settings fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Settings.serializer, json);
  }

  static Serializer<Settings> get serializer => _$settingsSerializer;
}
