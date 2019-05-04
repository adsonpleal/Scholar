library home_state;

import 'package:app_tcc/models/menu_entry.dart';
import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'home_state.g.dart';

abstract class HomeState implements Built<HomeState, HomeStateBuilder> {
  @nullable
  BuiltList<Subject> get subjects;
  @nullable
  Restaurant get restaurant;
  @nullable
  SingleEvent<bool> get showInfoAlert;
  int get selectedEntryIndex;
  bool get showDinner;

  HomeState._();

  bool get hasDinner => restaurant.menuDinner.isNotEmpty;
  bool get hasPlates => restaurant != null && restaurant.menu.isNotEmpty;

  MenuEntry get menuEntry {
    final selectedMenu = showDinner ? restaurant.menuDinner : restaurant.menu;
    return selectedMenu[selectedEntryIndex];
  }

  bool get showPrevious => selectedEntryIndex != 0;

  bool get showNext => selectedEntryIndex != restaurant.menu.length - 1;

  factory HomeState([Function(HomeStateBuilder b) updates]) = _$HomeState;

  factory HomeState.initial() => HomeState((b) => b
    ..selectedEntryIndex = 0
    ..showDinner = false);
}
