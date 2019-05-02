import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantsRepository {
  final Firestore _store = inject();

  CollectionReference get collection => _store.collection('restaurants');

  Stream<List<Restaurant>> get restaurantsStream => collection.snapshots().map(
        (snapshot) => snapshot.documents
            .map((documentSnapshot) =>
                Restaurant.fromJson(documentSnapshot.data))
            .toList(),
      );

  Stream<Restaurant> restaurant(String restaurantId) => collection
      .document(restaurantId)
      .snapshots()
      .map((s) => Restaurant.fromJson(s.data));
}
