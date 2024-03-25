import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/common/widget/error_widget.dart';
import 'package:mlt_menu_food/common/widget/loading_screen.dart';
import 'package:mlt_menu_food/core/utils/utils.dart';
import 'package:mlt_menu_food/features/food/bloc/food_bloc.dart';
import 'package:mlt_menu_food/features/food/data/model/food_model.dart';

import '../../../../common/widget/list_item_food.dart';

class NewFoods extends StatelessWidget {
  const NewFoods({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FoodBloc()..add(NewFoodsOnLimitFetched(limit: 10)),
        child: BlocBuilder<FoodBloc, GenericBlocState<FoodModel>>(
            builder: (context, state) => (switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.empty => Center(
                      child: Text('Không có dữ liệu',
                          style: context.textStyleSmall)),
                  Status.failure =>
                    ErrorWidgetCustom(errorMessage: state.error ?? ''),
                  Status.success => SizedBox(
                      height: context.sizeDevice.width * 0.45,
                      child: ListItemFood(list: state.datas))
                })));
  }
}
