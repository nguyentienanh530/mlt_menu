import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mlt_menu/features/order/data/model/food_order.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

List<Map<String, dynamic>> foodDtoListToJson(List<FoodOrder> foods) {
  return foods.map((food) => food.toJson()).toList();
}

// enum OrdersStatus { isWanting, isNew, isPaymented }

@freezed
class OrderModel with _$OrderModel {
  factory OrderModel(
      {final String? id,
      final String? status,
      final String? tableID,
      @Default('') String tableName,
      final String? orderTime,
      final String? payTime,
      final num? totalPrice,
      // ignore: invalid_annotation_target
      @JsonKey(toJson: foodDtoListToJson)
      @Default(<FoodOrder>[])
      List<FoodOrder> foods}) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
