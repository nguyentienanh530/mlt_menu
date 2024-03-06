// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodOrderImpl _$$FoodOrderImplFromJson(Map<String, dynamic> json) =>
    _$FoodOrderImpl(
      foodID: json['foodID'] as String? ?? '',
      foodName: json['foodName'] as String? ?? '',
      foodImage: json['foodImage'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      note: json['note'] as String? ?? '',
      totalPrice: json['totalPrice'] as num? ?? 0,
    );

Map<String, dynamic> _$$FoodOrderImplToJson(_$FoodOrderImpl instance) =>
    <String, dynamic>{
      'foodID': instance.foodID,
      'foodName': instance.foodName,
      'foodImage': instance.foodImage,
      'quantity': instance.quantity,
      'note': instance.note,
      'totalPrice': instance.totalPrice,
    };
