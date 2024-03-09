import 'package:cloud_firestore/cloud_firestore.dart';

class FoodRepository {
  final FirebaseFirestore _firebaseFirestore;

  FoodRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getFoods() async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .where('isShowFood', isEqualTo: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFoodsOnCategory(
      {required String categoryID}) async {
    try {
      return await _firebaseFirestore
          .collection('food')
          .where('isShowFood', isEqualTo: true)
          .where('categoryID', isEqualTo: categoryID)
          .get();
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
          .where('isShowFood', isEqualTo: true)
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
          .where('isShowFood', isEqualTo: true)
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
          .where('isShowFood', isEqualTo: true)
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
          .where('isShowFood', isEqualTo: true)
          .orderBy('count', descending: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
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
