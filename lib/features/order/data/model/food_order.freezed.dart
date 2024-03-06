// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodOrder _$FoodOrderFromJson(Map<String, dynamic> json) {
  return _FoodOrder.fromJson(json);
}

/// @nodoc
mixin _$FoodOrder {
  String get foodID => throw _privateConstructorUsedError;
  String get foodName => throw _privateConstructorUsedError;
  String get foodImage => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  num get totalPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodOrderCopyWith<FoodOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodOrderCopyWith<$Res> {
  factory $FoodOrderCopyWith(FoodOrder value, $Res Function(FoodOrder) then) =
      _$FoodOrderCopyWithImpl<$Res, FoodOrder>;
  @useResult
  $Res call(
      {String foodID,
      String foodName,
      String foodImage,
      int quantity,
      String note,
      num totalPrice});
}

/// @nodoc
class _$FoodOrderCopyWithImpl<$Res, $Val extends FoodOrder>
    implements $FoodOrderCopyWith<$Res> {
  _$FoodOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodID = null,
    Object? foodName = null,
    Object? foodImage = null,
    Object? quantity = null,
    Object? note = null,
    Object? totalPrice = null,
  }) {
    return _then(_value.copyWith(
      foodID: null == foodID
          ? _value.foodID
          : foodID // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      foodImage: null == foodImage
          ? _value.foodImage
          : foodImage // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodOrderImplCopyWith<$Res>
    implements $FoodOrderCopyWith<$Res> {
  factory _$$FoodOrderImplCopyWith(
          _$FoodOrderImpl value, $Res Function(_$FoodOrderImpl) then) =
      __$$FoodOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String foodID,
      String foodName,
      String foodImage,
      int quantity,
      String note,
      num totalPrice});
}

/// @nodoc
class __$$FoodOrderImplCopyWithImpl<$Res>
    extends _$FoodOrderCopyWithImpl<$Res, _$FoodOrderImpl>
    implements _$$FoodOrderImplCopyWith<$Res> {
  __$$FoodOrderImplCopyWithImpl(
      _$FoodOrderImpl _value, $Res Function(_$FoodOrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodID = null,
    Object? foodName = null,
    Object? foodImage = null,
    Object? quantity = null,
    Object? note = null,
    Object? totalPrice = null,
  }) {
    return _then(_$FoodOrderImpl(
      foodID: null == foodID
          ? _value.foodID
          : foodID // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      foodImage: null == foodImage
          ? _value.foodImage
          : foodImage // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodOrderImpl implements _FoodOrder {
  _$FoodOrderImpl(
      {this.foodID = '',
      this.foodName = '',
      this.foodImage = '',
      this.quantity = 1,
      this.note = '',
      this.totalPrice = 0});

  factory _$FoodOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodOrderImplFromJson(json);

  @override
  @JsonKey()
  final String foodID;
  @override
  @JsonKey()
  final String foodName;
  @override
  @JsonKey()
  final String foodImage;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final String note;
  @override
  @JsonKey()
  final num totalPrice;

  @override
  String toString() {
    return 'FoodOrder(foodID: $foodID, foodName: $foodName, foodImage: $foodImage, quantity: $quantity, note: $note, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodOrderImpl &&
            (identical(other.foodID, foodID) || other.foodID == foodID) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.foodImage, foodImage) ||
                other.foodImage == foodImage) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodID, foodName, foodImage, quantity, note, totalPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodOrderImplCopyWith<_$FoodOrderImpl> get copyWith =>
      __$$FoodOrderImplCopyWithImpl<_$FoodOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodOrderImplToJson(
      this,
    );
  }
}

abstract class _FoodOrder implements FoodOrder {
  factory _FoodOrder(
      {final String foodID,
      final String foodName,
      final String foodImage,
      final int quantity,
      final String note,
      final num totalPrice}) = _$FoodOrderImpl;

  factory _FoodOrder.fromJson(Map<String, dynamic> json) =
      _$FoodOrderImpl.fromJson;

  @override
  String get foodID;
  @override
  String get foodName;
  @override
  String get foodImage;
  @override
  int get quantity;
  @override
  String get note;
  @override
  num get totalPrice;
  @override
  @JsonKey(ignore: true)
  _$$FoodOrderImplCopyWith<_$FoodOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
