part of 'food_bloc.dart';

class FoodEvent {}

final class NewFoodsOnLimitFetched extends FoodEvent {
  final int limit;
  NewFoodsOnLimitFetched({required this.limit});
}

final class PopularFoodsOnLimitFetched extends FoodEvent {
  final int limit;
  PopularFoodsOnLimitFetched({required this.limit});
}

final class FoodsFetched extends FoodEvent {}

final class NewFoodsFetched extends FoodEvent {}

final class PopularFoodsFetched extends FoodEvent {}

final class FoodsOnCaregoryFetched extends FoodEvent {
  final String categoryID;
  FoodsOnCaregoryFetched({required this.categoryID});
}
