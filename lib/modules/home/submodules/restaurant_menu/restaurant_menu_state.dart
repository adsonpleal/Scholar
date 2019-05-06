import 'package:app_tcc/models/menu_entry.dart';
import 'package:app_tcc/models/restaurant.dart';
import 'package:built_value/built_value.dart';

part 'restaurant_menu_state.g.dart';

abstract class RestaurantMenuState
    implements Built<RestaurantMenuState, RestaurantMenuStateBuilder> {
  @nullable
  Restaurant get restaurant;

  int get selectedEntryIndex;
  bool get showDinner;

  RestaurantMenuState._();

  bool get hasDinner => restaurant.menuDinner.isNotEmpty;
  bool get hasPlates => restaurant.menu.isNotEmpty;
  bool get showPrevious => selectedEntryIndex != 0;
  bool get showNext => selectedEntryIndex != restaurant.menu.length - 1;
  bool get isValid => restaurant != null && menuEntry != null;

  MenuEntry get menuEntry {
    final selectedMenu = showDinner ? restaurant.menuDinner : restaurant.menu;
    if (selectedMenu.isEmpty) return null;
    return selectedMenu[selectedEntryIndex];
  }

  factory RestaurantMenuState(
      [Function(RestaurantMenuStateBuilder b) updates]) = _$RestaurantMenuState;

  factory RestaurantMenuState.initial() => RestaurantMenuState((b) => b
    ..selectedEntryIndex = 0
    ..showDinner = false);
}
