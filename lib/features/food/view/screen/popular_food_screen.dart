import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mlt_menu/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu/common/widget/empty_screen.dart';
import 'package:mlt_menu/common/widget/error_screen.dart';
import 'package:mlt_menu/common/widget/grid_item_food.dart';
import 'package:mlt_menu/common/widget/loading_screen.dart';
import 'package:mlt_menu/core/utils/utils.dart';
import 'package:mlt_menu/features/food/bloc/food_bloc.dart';

class PopularFoodsScreen extends StatelessWidget {
  const PopularFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodBloc()..add(PopularFoodsFetched()),
      child: Scaffold(
          appBar: _buildAppbar(context),
          body: const SafeArea(child: PopularFoodsView())),
    );
  }

  _buildAppbar(BuildContext context) => AppBar(
          centerTitle: true,
          title: Text('Món ăn mới',
              style: context.textStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icon/cart.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn)))
          ]);
}

class PopularFoodsView extends StatelessWidget {
  const PopularFoodsView({super.key});

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
