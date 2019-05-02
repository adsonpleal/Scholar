import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'menu_entry.g.dart';

abstract class MenuEntry implements Built<MenuEntry, MenuEntryBuilder> {
  DateTime get date;
  BuiltList<String> get plates;

  MenuEntry._();

  factory MenuEntry([Function(MenuEntryBuilder b) updates]) = _$MenuEntry;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MenuEntry.serializer, this);
  }

  static MenuEntry fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MenuEntry.serializer, json);
  }

  static Serializer<MenuEntry> get serializer => _$menuEntrySerializer;
}