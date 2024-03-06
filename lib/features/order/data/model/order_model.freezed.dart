// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String? get id => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get tableID => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  String? get orderTime => throw _privateConstructorUsedError;
  String? get payTime => throw _privateConstructorUsedError;
  num? get totalPrice =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(toJson: foodDtoListToJson)
  List<FoodOrder> get foods => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String? id,
      String? status,
      String? tableID,
      String tableName,
      String? orderTime,
      String? payTime,
      num? totalPrice,
      @JsonKey(toJson: foodDtoListToJson) List<FoodOrder> foods});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? tableID = freezed,
    Object? tableName = null,
    Object? orderTime = freezed,
    Object? payTime = freezed,
    Object? totalPrice = freezed,
    Object? foods = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tableID: freezed == tableID
          ? _value.tableID
          : tableID // ignore: cast_nullable_to_non_nullable
              as String?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      orderTime: freezed == orderTime
          ? _value.orderTime
          : orderTime // ignore: cast_nullable_to_non_nullable
              as String?,
      payTime: freezed == payTime
          ? _value.payTime
          : payTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodOrder>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? status,
      String? tableID,
      String tableName,
      String? orderTime,
      String? payTime,
      num? totalPrice,
      @JsonKey(toJson: foodDtoListToJson) List<FoodOrder> foods});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? tableID = freezed,
    Object? tableName = null,
    Object? orderTime = freezed,
    Object? payTime = freezed,
    Object? totalPrice = freezed,
    Object? foods = null,
  }) {
    return _then(_$OrderModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tableID: freezed == tableID
          ? _value.tableID
          : tableID // ignore: cast_nullable_to_non_nullable
              as String?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      orderTime: freezed == orderTime
          ? _value.orderTime
          : orderTime // ignore: cast_nullable_to_non_nullable
              as String?,
      payTime: freezed == payTime
          ? _value.payTime
          : payTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodOrder>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  _$OrderModelImpl(
      {this.id,
      this.status,
      this.tableID,
      this.tableName = '',
      this.orderTime,
      this.payTime,
      this.totalPrice,
      @JsonKey(toJson: foodDtoListToJson)
      final List<FoodOrder> foods = const <FoodOrder>[]})
      : _foods = foods;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? status;
  @override
  final String? tableID;
  @override
  @JsonKey()
  final String tableName;
  @override
  final String? orderTime;
  @override
  final String? payTime;
  @override
  final num? totalPrice;
// ignore: invalid_annotation_target
  final List<FoodOrder> _foods;
// ignore: invalid_annotation_target
  @override
  @JsonKey(toJson: foodDtoListToJson)
  List<FoodOrder> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, status: $status, tableID: $tableID, tableName: $tableName, orderTime: $orderTime, payTime: $payTime, totalPrice: $totalPrice, foods: $foods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tableID, tableID) || other.tableID == tableID) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.orderTime, orderTime) ||
                other.orderTime == orderTime) &&
            (identical(other.payTime, payTime) || other.payTime == payTime) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality().equals(other._foods, _foods));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      tableID,
      tableName,
      orderTime,
      payTime,
      totalPrice,
      const DeepCollectionEquality().hash(_foods));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  factory _OrderModel(
          {final String? id,
          final String? status,
          final String? tableID,
          final String tableName,
          final String? orderTime,
          final String? payTime,
          final num? totalPrice,
          @JsonKey(toJson: foodDtoListToJson) final List<FoodOrder> foods}) =
      _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get status;
  @override
  String? get tableID;
  @override
  String get tableName;
  @override
  String? get orderTime;
  @override
  String? get payTime;
  @override
  num? get totalPrice;
  @override // ignore: invalid_annotation_target
  @JsonKey(toJson: foodDtoListToJson)
  List<FoodOrder> get foods;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
