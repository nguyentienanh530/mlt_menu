import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrderOnTable(
      {String? tableID}) {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("tableID", isEqualTo: tableID)
          .where("status", isEqualTo: 'new')
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> getOrders(
  //     {required String nameTable}) {
  //   try {
  //     return _firebaseFirestore
  //         .collection("AllOrder")
  //         .where("table", isEqualTo: nameTable)
  //         .where("isPay", isEqualTo: false)
  //         .get();
  //   } on FirebaseException catch (e) {
  //     throw '$e';
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  Future<void> createOrder({required Map<String, dynamic> dataJson}) async {
    try {
      var documentReference =
          await _firebaseFirestore.collection('orders').add(dataJson);
      await updateOrder(jsonData: {'id': documentReference.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrders(
      {required String tableID}) async {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("tableID", isEqualTo: tableID)
          .where("status", isEqualTo: 'new')
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getHistoryOrder() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("isPay", isEqualTo: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllOrder() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where('status', isEqualTo: 'new')
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrderWanting() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where('isPay', isEqualTo: false)
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrderByID(
      {required String orderID}) async {
    try {
      return await _firebaseFirestore.collection("orders").doc(orderID).get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateOrder({required Map<String, dynamic> jsonData}) async {
    var orderID = jsonData['id'];
    try {
      await _firebaseFirestore
          .collection('orders')
          .doc(orderID)
          .update(jsonData);
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteOrder({required String orderID}) async {
    try {
      await _firebaseFirestore.collection('orders').doc(orderID).delete();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> paymentOrder({required String idOrder}) async {
    try {
      await _firebaseFirestore
          .collection('orders')
          .doc(idOrder)
          .update({'isPay': true, "datePay": DateTime.now().toString()});
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }
}
