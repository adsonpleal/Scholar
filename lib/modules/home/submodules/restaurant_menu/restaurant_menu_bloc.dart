import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

import 'restaurant_menu_state.dart';

part 'restaurant_menu_bloc.g.dart';

@GenerateBloc(RestaurantMenuState)
class RestaurantMenuBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<Restaurant> _restaurantSubscription;

  @override
  RestaurantMenuState get initialState => RestaurantMenuState.initial();

  RestaurantMenuBloc() {
    _initStream();
  }

  Stream<RestaurantMenuState> _mapRestaurantChangedToState(
    Restaurant restaurant,
  ) async* {
    yield currentState.rebuild((b) => b
      ..restaurant.replace(restaurant)
      ..selectedEntryIndex = 0
      ..showDinner = false);
  }

  Stream<RestaurantMenuState> _mapToggleDinnerToState() async* {
    yield currentState.rebuild((b) => b..showDinner = !b.showDinner);
  }

  Stream<RestaurantMenuState> _mapShowNextMenuEntryToState() async* {
    yield currentState.rebuild((b) => b..selectedEntryIndex += 1);
  }

  Stream<RestaurantMenuState> _mapShowPreviousMenuEntryToState() async* {
    yield currentState.rebuild((b) => b..selectedEntryIndex -= 1);
  }

  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    super.dispose();
  }

  void _initStream() {
    _restaurantSubscription = _userData.restaurantStream?.listen(
      dispatchRestaurantChangedEvent,
    );
  }
}
