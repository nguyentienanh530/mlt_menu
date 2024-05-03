import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_client_mobile/common/bloc/generic_bloc_state.dart';
import 'package:mlt_client_mobile/common/widget/error_widget.dart';
import 'package:mlt_client_mobile/common/widget/loading_screen.dart';
import 'package:mlt_client_mobile/core/utils/utils.dart';
import 'package:mlt_client_mobile/features/food/bloc/food_bloc.dart';
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
                  Status.loading => const LoadingScreen(),
                  Status.empty => Center(
                      child: Text('Không có dữ liệu',
                          style: context.textStyleSmall)),
                  Status.failure =>
                    ErrorWidgetCustom(errorMessage: state.error ?? ''),
                  Status.success =>
                    SizedBox(child: GridItemFood(list: state.datas))
                })));
  }
}
