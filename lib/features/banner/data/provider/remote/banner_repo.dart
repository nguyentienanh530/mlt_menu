import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mlt_client_mobile/common/firebase/firebase_base.dart';
import 'package:mlt_client_mobile/common/firebase/firebase_result.dart';
import 'package:mlt_client_mobile/features/banner/data/model/banner_model.dart';

class BannerRepo extends FirebaseBase<BannerModel> {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<FirebaseResult<List<BannerModel>>> getBanners() async {
    return await getItems(await getBannerFromFirebase(), BannerModel.fromJson);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBannerFromFirebase() async {
    try {
      return await _firebaseFirestore.collection('banner').get();
    } on FirebaseException catch (e) {
      throw '$e';
    }
  }
}
