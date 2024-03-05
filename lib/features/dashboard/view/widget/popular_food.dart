import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu/features/food/bloc/food_bloc.dart';
import '../../../../common/widget/grid_item_food.dart';
import '../../../food/data/model/food_model.dart';

class PopularFoods extends StatelessWidget {
  const PopularFoods({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FoodBloc()..add(PopularFoodsOnLimitFetched(limit: 10)),
      child: BlocBuilder<FoodBloc, GenericBlocState<FoodModel>>(
        builder: (context, state) => (switch (state.status) {
          Status.loading => SizedBox(),
          Status.empty => SizedBox(),
          Status.failure => SizedBox(),
          Status.success => SizedBox(child: GridItemFood(list: state.datas))
        }),
      ),
    );
  }
}
