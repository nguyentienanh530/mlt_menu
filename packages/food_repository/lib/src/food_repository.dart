import 'package:cloud_firestore/cloud_firestore.dart';

class FoodRepository {
  final FirebaseFirestore _firebaseFirestore;

  FoodRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getFoods() async {
    try {
      return await _firebaseFirestore.collection('food').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNewFoodsOnLimit(
      {required int limit}) async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .orderBy('createAt', descending: true)
          .limit(limit)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNewFoods() async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .orderBy('createAt', descending: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPopularFoodsOnLimit(
      {required int limit}) async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .orderBy('count', descending: true)
          .limit(limit)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPopularFoods() async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .orderBy('count', descending: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFoodByID(
      {required String foodID}) {
    try {
      return _firebaseFirestore.collection('food').doc(foodID).get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createFood(Map<String, dynamic> data) async {
    try {
      var doc = await _firebaseFirestore.collection('food').add(data);
      await updateFood(foodID: doc.id, data: {'id': doc.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future deleteFood({required String idFood}) async {
    try {
      return await _firebaseFirestore.collection('food').doc(idFood).delete();
    } catch (e) {
      return false;
    }
  }

  Future<void> updateFood(
      {required String foodID, required Map<String, dynamic> data}) async {
    try {
      await _firebaseFirestore.collection('food').doc(foodID).update(data);
    } catch (e) {
      throw '$e';
    }
  }
}
