// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodModelImpl _$$FoodModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      categoryID: json['categoryID'] as String? ?? '',
      count: json['count'] as num? ?? 0,
      description: json['description'] as String? ?? '',
      discount: json['discount'] as num? ?? 0,
      image: json['image'] as String? ?? '',
      isDiscount: json['isDiscount'] as bool? ?? false,
      isShowFood: json['isShowFood'] as bool? ?? false,
      photoGallery: json['photoGallery'] as List<dynamic>? ?? const [],
      price: json['price'] as num? ?? 0,
      createAt: json['createAt'] as String? ?? '',
    );

Map<String, dynamic> _$$FoodModelImplToJson(_$FoodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryID': instance.categoryID,
      'count': instance.count,
      'description': instance.description,
      'discount': instance.discount,
      'image': instance.image,
      'isDiscount': instance.isDiscount,
      'isShowFood': instance.isShowFood,
      'photoGallery': instance.photoGallery,
      'price': instance.price,
      'createAt': instance.createAt,
    };
