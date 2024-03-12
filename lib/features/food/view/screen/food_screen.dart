import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/core/config/router.dart';
import 'package:mlt_menu/features/food/bloc/food_bloc.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../../../common/bloc/bloc_helper.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../core/utils/utils.dart';
import '../../../search_food/cubit/text_search_cubit.dart';
import '../../data/model/food_model.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FoodScreen>
    with AutomaticKeepAliveClientMixin {
  final _isSearch = ValueNotifier(false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TextSearchCubit()),
          BlocProvider(create: (context) => FoodBloc())
        ],
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: BlocBuilder<TextSearchCubit, String>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return SearchFoodView(textSearch: state);
                })));
  }

  @override
  bool get wantKeepAlive => true;

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: ValueListenableBuilder(
            valueListenable: _isSearch,
            builder: (context, value, child) => value
                ? _buildSearch(context)
                    .animate()
                    .slideX(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)
                : AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: Text('Danh sách món',
                        style: context.titleStyleMedium))),
        actions: [
          IconButton(
              onPressed: () {
                _isSearch.value = !_isSearch.value;
              },
              icon: ValueListenableBuilder(
                  valueListenable: _isSearch,
                  builder: (context, value, child) => Icon(
                      !value ? Icons.search : Icons.highlight_remove_sharp)))
        ]);
  }

  Widget _buildSearch(BuildContext context) {
    return CommonTextField(
        controller: _searchController,
        onChanged: (value) =>
            context.read<TextSearchCubit>().textChanged(value),
        hintText: "Tìm kiếm",
        suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<TextSearchCubit>().clear();
              _searchController.clear();
            }),
        prefixIcon: const Icon(Icons.search));
  }
}

// _buildAppbar(BuildContext context) {
//   return EasySearchBar(
//       title: Text('Danh sách món',
//           style:
//               context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
//       onSearch: (value) => context.read<TextSearchCubit>().textChanged(value));
// }

class SearchFoodView extends StatelessWidget {
  const SearchFoodView({super.key, required this.textSearch});

  final String textSearch;
  @override
  Widget build(BuildContext context) {
    return AfterSearchUI(text: textSearch)
        .animate()
        .slideX(
            begin: -0.1, end: 0, curve: Curves.easeInOutCubic, duration: 500.ms)
        .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
  }
}

class AfterSearchUI extends StatefulWidget {
  const AfterSearchUI({super.key, this.text});
  final String? text;

  @override
  State<AfterSearchUI> createState() => _AfterSearchUIState();
}

class _AfterSearchUIState extends State<AfterSearchUI> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    if (!mounted) return;
    context.read<FoodBloc>().add(FoodsFetched());
  }

  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocBuilder<FoodBloc, GenericBlocState<FoodModel>>(
        buildWhen: (previous, current) =>
            context.read<FoodBloc>().operation == ApiOperation.select,
        builder: (context, state) {
          return (switch (state.status) {
            Status.loading => loadingOrInitState,
            Status.empty => const EmptyScreen(),
            Status.failure => ErrorScreen(errorMsg: state.error ?? ''),
            Status.success =>
              _buildBody(state.datas ?? <FoodModel>[], text ?? '')
          });
        });
  }

  _buildBody(List<FoodModel> foods, String text) => ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, i) {
        if (foods[i]
                .name
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            TiengViet.parse(foods[i].name.toString().toLowerCase())
                .contains(text.toLowerCase())) {
          return _buildItemSearch(context, foods[i]);
        }
        return const SizedBox();
      });

  Widget _buildItemSearch(BuildContext context, FoodModel food) {
    return InkWell(
        onTap: () {
          context.push(RouteName.foodDetail, extra: food);
        },
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 5),
            child: Card(
                borderOnForeground: false,
                child: SizedBox(
                    height: 80,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildImage(food),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTitle(context, food),
                                // _buildCategory(context, food),
                                _buildPrice(context, food)
                              ])
                        ]
                            .animate(interval: 50.ms)
                            .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)
                            .fadeIn(
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms))))));
  }

  Widget _buildImage(FoodModel food) {
    return Container(
        margin: EdgeInsets.all(defaultPadding / 2),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(food.image == "" ? noImage : food.image),
                fit: BoxFit.cover)));
  }

  Widget _buildCategory(BuildContext context, FoodModel food) {
    return FittedBox(child: Text('asdasd', style: context.textStyleSmall!));
  }

  Widget _buildTitle(BuildContext context, FoodModel food) {
    return FittedBox(child: Text(food.name));
  }

  Widget _buildPrice(BuildContext context, FoodModel food) {
    double discountAmount = (food.price * food.discount.toDouble()) / 100;
    double discountedPrice = food.price - discountAmount;
    return food.isDiscount == false
        ? Text(Ultils.currencyFormat(double.parse(food.price.toString())),
            style: TextStyle(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.bold))
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text(Ultils.currencyFormat(double.parse(food.price.toString())),
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 3.0,
                      decorationColor: Colors.red,
                      decorationStyle: TextDecorationStyle.solid,
                      // fontSize: defaultSizeText,
                      color: Color.fromARGB(255, 131, 128, 126),
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 10.0),
              Text(
                  Ultils.currencyFormat(
                      double.parse(discountedPrice.toString())),
                  style: TextStyle(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.bold))
            ])
          ]);
  }

  Widget _buildPercentDiscount(FoodModel food) {
    return Container(
        height: 80,
        width: 80,
        // decoration: BoxDecoration(color: redColor),
        child: Center(child: CommonLineText(value: "${food.discount}%")

            // Text("${food.discount}%",
            //     style: TextStyle(
            //         fontSize: 16,
            //         color: textColor,
            //         fontFamily: Constant.font,
            //         fontWeight: FontWeight.w600)))
            ));
  }
}
