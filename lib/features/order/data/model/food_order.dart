import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_order.freezed.dart';
part 'food_order.g.dart';

@freezed
class FoodOrder with _$FoodOrder {
  factory FoodOrder(
      {@Default('') String foodID,
      @Default('') String foodName,
      @Default('') String foodImage,
      @Default(1) int quantity,
      @Default(false) bool isDiscount,
      @Default(0) num discount,
      @Default(0) num foodPrice,
      @Default('') String note,
      @Default(0) num totalPrice}) = _FoodOrder;

  factory FoodOrder.fromJson(Map<String, dynamic> json) =>
      _$FoodOrderFromJson(json);
}
