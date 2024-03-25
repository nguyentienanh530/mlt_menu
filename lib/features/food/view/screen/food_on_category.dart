import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/common/widget/empty_screen.dart';
import 'package:mlt_menu_food/common/widget/error_screen.dart';
import 'package:mlt_menu_food/common/widget/grid_item_food.dart';
import 'package:mlt_menu_food/common/widget/loading_screen.dart';
import 'package:mlt_menu_food/core/config/config.dart';
import 'package:mlt_menu_food/core/utils/utils.dart';
import 'package:mlt_menu_food/features/food/bloc/food_bloc.dart';
import '../../../../common/widget/cart_button.dart';
import '../../../category/data/model/category_model.dart';

class FoodOnCategory extends StatelessWidget {
  const FoodOnCategory({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(FoodsOnCaregoryFetched(categoryID: category.id)),
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: const SafeArea(child: FoodOnCategoryView())));
  }

  _buildAppbar(BuildContext context) => AppBar(
          centerTitle: true,
          title: Text(category.name, style: context.textStyleLarge),
          actions: [
            CartButton(onPressed: () => context.push(RouteName.cartScreen))
          ]);
}

class FoodOnCategoryView extends StatelessWidget {
  const FoodOnCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    var foodsOnCategoryState = context.watch<FoodBloc>().state;
    return (switch (foodsOnCategoryState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: foodsOnCategoryState.error),
      Status.success =>
        GridItemFood(list: foodsOnCategoryState.datas, isScroll: true)
    });
  }
}
