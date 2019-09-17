import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:firebase/firestore.dart';

class RestaurantsRepository {
  final Firestore _store = inject();

  CollectionReference get collection => _store.collection('restaurants');

  Stream<List<Restaurant>> get restaurantsStream => collection.onSnapshot.map(
        (snapshot) => snapshot.docs
            .map((documentSnapshot) =>
                Restaurant.fromJson(documentSnapshot.data()))
            .toList(),
      );

  Stream<Restaurant> restaurant(String restaurantId) =>
      collection.doc(restaurantId).onSnapshot.map((s) {
        if (s.data == null) return null;
        return Restaurant.fromJson(s.data());
      });
}
