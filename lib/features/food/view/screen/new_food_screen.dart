import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/common/widget/empty_screen.dart';
import 'package:mlt_menu_food/common/widget/error_screen.dart';
import 'package:mlt_menu_food/common/widget/grid_item_food.dart';
import 'package:mlt_menu_food/common/widget/loading_screen.dart';
import 'package:mlt_menu_food/core/utils/utils.dart';
import 'package:mlt_menu_food/features/food/bloc/food_bloc.dart';

import '../../../../common/widget/cart_button.dart';
import '../../../../core/config/config.dart';

class NewFoodsScreen extends StatelessWidget {
  const NewFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FoodBloc()..add(NewFoodsFetched()),
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: const SafeArea(child: NewFoodsView())));
  }

  _buildAppbar(BuildContext context) => AppBar(
          centerTitle: true,
          title: Text('Món ăn mới',
              style: context.textStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            CartButton(onPressed: () => context.push(RouteName.cartScreen))
          ]);
}

class NewFoodsView extends StatelessWidget {
  const NewFoodsView({super.key});

  @override
  Widget build(BuildContext context) {
    var newFoodsState = context.watch<FoodBloc>().state;
    return (switch (newFoodsState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: newFoodsState.error),
      Status.success => GridItemFood(list: newFoodsState.datas, isScroll: true),
    });
  }
}
