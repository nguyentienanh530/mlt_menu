import 'package:food_repository/food_repository.dart';
import 'package:mlt_menu_food/common/firebase/firebase_base.dart';
import 'package:mlt_menu_food/common/firebase/firebase_result.dart';
import 'package:mlt_menu_food/features/food/data/model/food_model.dart';

class FoodRepo extends FirebaseBase<FoodModel> {
  final FoodRepository _foodRepository;

  FoodRepo({required FoodRepository foodRepository})
      : _foodRepository = foodRepository;

  Future<FirebaseResult<List<FoodModel>>> getFoods() async {
    return await getItems(await _foodRepository.getFoods(), FoodModel.fromJson);
  }

  Future<FirebaseResult<List<FoodModel>>> getNewFoodsOnLimit(
      {required int limit}) async {
    return await getItems(
        await _foodRepository.getNewFoodsOnLimit(limit: limit),
        FoodModel.fromJson);
  }

  Future<FirebaseResult<List<FoodModel>>> getPopularFoodsOnLimit(
      {required int limit}) async {
    return await getItems(
        await _foodRepository.getPopularFoodsOnLimit(limit: limit),
        FoodModel.fromJson);
  }

  Future<FirebaseResult<List<FoodModel>>> getPopularFoods() async {
    return await getItems(
        await _foodRepository.getPopularFoods(), FoodModel.fromJson);
  }

  Future<FirebaseResult<List<FoodModel>>> getNewFoods() async {
    return await getItems(
        await _foodRepository.getNewFoods(), FoodModel.fromJson);
  }

  Future<FirebaseResult<List<FoodModel>>> getFoodsOnCategory(
      {required String categoryID}) async {
    return await getItems(
        await _foodRepository.getFoodsOnCategory(categoryID: categoryID),
        FoodModel.fromJson);
  }
}
