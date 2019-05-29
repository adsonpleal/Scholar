library settings;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'settings.g.dart';

abstract class Settings implements Built<Settings, SettingsBuilder> {
  bool get allowNotifications;
  bool get connected;
  @nullable
  String get restaurantId;

  Settings._();

  factory Settings([Function(SettingsBuilder b) updates]) = _$Settings;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Settings.serializer, this);
  }

  static Settings fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Settings.serializer, json);
  }

  static Serializer<Settings> get serializer => _$settingsSerializer;
}
