import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'menu_entry.dart';
import 'serializers.dart';

part 'restaurant.g.dart';

abstract class Restaurant implements Built<Restaurant, RestaurantBuilder> {
  String get documentID;
  String get name;
  BuiltList<MenuEntry> get menu;
  @nullable
  BuiltList<MenuEntry> get menuDinner;

  Restaurant._();

  factory Restaurant([Function(RestaurantBuilder b) updates]) = _$Restaurant;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Restaurant.serializer, this);
  }

  static Restaurant fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Restaurant.serializer, json);
  }

  static Serializer<Restaurant> get serializer => _$restaurantSerializer;
}
