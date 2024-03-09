import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/common/widget/error_widget.dart';
import 'package:mlt_menu/common/widget/loading_screen.dart';
import 'package:mlt_menu/core/config/config.dart';
import 'package:mlt_menu/core/utils/utils.dart';
import 'package:mlt_menu/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu/features/category/data/model/category_model.dart';

import '../../../../common/bloc/generic_bloc_state.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    var categoriesState = context.watch<CategoryBloc>().state;
    return (switch (categoriesState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty =>
        Center(child: Text('Không có dữ liệu', style: context.textStyleSmall)),
      Status.failure =>
        ErrorWidgetCustom(errorMessage: categoriesState.error ?? ''),
      Status.success => GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          physics: const NeverScrollableScrollPhysics(),
          // scrollDirection: Axis.horizontal,
          itemCount: categoriesState.datas!.length,
          itemBuilder: (context, index) =>
              _buildItemCategory(context, categoriesState.datas![index]))
    });
  }

  Widget _buildItemCategory(BuildContext context, CategoryModel categoryModel) {
    return GestureDetector(
        onTap: () =>
            context.push(RouteName.foodOnCategory, extra: categoryModel),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(categoryModel.image,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? Card(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              width: context.sizeDevice.height * 0.09,
                              height: context.sizeDevice.height * 0.09,
                              child: child))
                      : const LoadingScreen()),
          Text(categoryModel.name,
              style: context.textStyleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
        ]));
  }
}
