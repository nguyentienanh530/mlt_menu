import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_model.freezed.dart';
part 'food_model.g.dart';

@freezed
class FoodModel with _$FoodModel {
  factory FoodModel(
      {@Default('') String id,
      @Default('') String name,
      @Default('') String categoryID,
      @Default(0) num count,
      @Default('') String description,
      @Default(0) num discount,
      @Default('') String image,
      @Default(false) bool isDiscount,
      @Default([]) List photoGallery,
      @Default(0) num price,
      @Default('') String createAt}) = _FoodModel;

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);
}
