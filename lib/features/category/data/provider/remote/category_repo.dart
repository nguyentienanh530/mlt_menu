import 'package:category_repository/category_repository.dart';
import 'package:mlt_menu/common/firebase/firebase_base.dart';
import 'package:mlt_menu/features/category/data/model/category_model.dart';

import '../../../../../common/firebase/firebase_result.dart';

class CategoryRepo extends FirebaseBase<CategoryModel> {
  final CategoryRepository _categoryRepository;

  CategoryRepo(this._categoryRepository);

  Future<FirebaseResult<List<CategoryModel>>> getCategories() async {
    return await getItems(
        await _categoryRepository.getAllCategory(), CategoryModel.fromJson);
  }
}
