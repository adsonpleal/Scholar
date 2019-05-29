import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasRestaurant', () {
    test('is false when values are null', () {
      final profileState = ProfileState();
      expect(profileState.hasRestaurant, false);
    });

    test('is true when values are null', () {
      final settings = Settings((b) => b
        ..restaurantId = 'restaurantId'
        ..connected = false
        ..allowNotifications = false);
      final List<Restaurant> restaurants = [];
      final profileState = ProfileState((b) => b
        ..settings.replace(settings)
        ..restaurants = restaurants);
      expect(profileState.hasRestaurant, true);
    });
  });

  group('selectedRestaurant', () {
    test('is null when values are null', () {
      final profileState = ProfileState((b) => b..restaurants = []);
      expect(profileState.selectedRestaurant, null);
    });

    test('is a Restaurant when values are right', () {
      final settings = Settings((b) => b
        ..restaurantId = 'restaurantId'
        ..connected = false
        ..allowNotifications = false);
      final restaurant = Restaurant((b) => b
        ..documentID = 'restaurantId'
        ..name = 'name'
        ..menu.replace([]));
      final List<Restaurant> restaurants = [restaurant];
      final profileState = ProfileState((b) => b
        ..settings.replace(settings)
        ..restaurants = restaurants);
      expect(profileState.selectedRestaurant, restaurant);
    });
  });
}
