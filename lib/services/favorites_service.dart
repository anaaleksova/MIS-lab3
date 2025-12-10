import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'favorites';

  Future<void> addFavorite(FavoriteMeal meal) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(meal.idMeal)
          .set(meal.toMap());
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String mealId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(mealId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  Future<bool> isFavorite(String mealId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(mealId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<FavoriteMeal>> getFavorites() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('addedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FavoriteMeal.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  Stream<List<FavoriteMeal>> getFavoritesStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FavoriteMeal.fromMap(doc.data()))
        .toList());
  }

  Future<void> clearAllFavorites() async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore.collection(_collectionName).get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }
}