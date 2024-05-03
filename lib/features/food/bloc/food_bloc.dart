import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mlt_client_mobile/common/bloc/bloc_helper.dart';
import 'package:mlt_client_mobile/common/bloc/generic_bloc_state.dart';
import 'package:mlt_client_mobile/features/food/data/model/food_model.dart';
import 'package:mlt_client_mobile/features/food/data/provider/remote/food_repo.dart';
part 'food_event.dart';

typedef Emit = Emitter<GenericBlocState<FoodModel>>;

class FoodBloc extends Bloc<FoodEvent, GenericBlocState<FoodModel>>
    with BlocHelper<FoodModel> {
  FoodBloc() : super(GenericBlocState.loading()) {
    on<NewFoodsOnLimitFetched>(_newFoodOnLimitFetch);
    on<PopularFoodsOnLimitFetched>(_popularFoodOnLimitFetch);
    on<FoodsFetched>(_foodsFetched);
    on<NewFoodsFetched>(_newFoodsFetched);
    on<PopularFoodsFetched>(_popularFoodsFetched);
    on<FoodsOnCaregoryFetched>(_getFoodsOncategory);
  }
  final _foodRepository = FoodRepo(
      foodRepository:
          FoodRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _newFoodOnLimitFetch(
      NewFoodsOnLimitFetched event, Emit emit) async {
    await getItems(
        _foodRepository.getNewFoodsOnLimit(limit: event.limit), emit);
  }

  FutureOr<void> _popularFoodOnLimitFetch(
      PopularFoodsOnLimitFetched event, Emit emit) async {
    await getItems(
        _foodRepository.getPopularFoodsOnLimit(limit: event.limit), emit);
  }

  FutureOr<void> _foodsFetched(FoodsFetched event, Emit emit) async {
    await getItems(_foodRepository.getFoods(), emit);
  }

  FutureOr<void> _newFoodsFetched(NewFoodsFetched event, Emit emit) async {
    await getItems(_foodRepository.getNewFoods(), emit);
  }

  FutureOr<void> _popularFoodsFetched(
      PopularFoodsFetched event, Emit emit) async {
    await getItems(_foodRepository.getPopularFoods(), emit);
  }

  FutureOr<void> _getFoodsOncategory(
      FoodsOnCaregoryFetched event, Emit emit) async {
    await getItems(
        _foodRepository.getFoodsOnCategory(categoryID: event.categoryID), emit);
  }
}
