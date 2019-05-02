library profile_state;

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:built_value/built_value.dart';

part 'profile_state.g.dart';

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  @nullable
  SingleEvent<String> get route;

  @nullable
  User get user;

  @nullable
  Settings get settings;

  @nullable
  List<Restaurant> get restaurants;

  bool get loading;

  bool get hasRestaurant =>
      settings?.restaurantId != null && restaurants != null;

  Restaurant get selectedRestaurant => restaurants?.firstWhere(
        (restaurant) => restaurant.documentID == settings?.restaurantId,
        orElse: () => null,
      );

  ProfileState._();

  factory ProfileState([Function(ProfileStateBuilder b) updates]) =>
      _$ProfileState((b) => b
        ..loading = false
        ..update(updates));

  factory ProfileState.initial() => ProfileState();

  factory ProfileState.login() =>
      ProfileState((b) => b..route = SingleEvent(Routes.login));
}
