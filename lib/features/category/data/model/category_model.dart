import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  factory CategoryModel(
      {@Default('') String id,
      @Default('') String name,
      @Default('') String image,
      @Default('') String description}) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
