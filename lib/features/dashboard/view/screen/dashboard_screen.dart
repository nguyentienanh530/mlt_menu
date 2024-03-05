import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/config/router.dart';
import 'package:mlt_menu/core/utils/utils.dart';
import 'package:mlt_menu/features/banner/bloc/banner_bloc.dart';
import 'package:mlt_menu/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu/features/dashboard/view/widget/categories.dart';
import '../widget/new_food.dart';
import '../widget/popular_food.dart';
import '../widget/slider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => BannerBloc()),
      BlocProvider(create: (context) => CategoryBloc())
    ], child: const DashboardView());
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  var isShowSearch = ValueNotifier(false);
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (!mounted) return;
    context.read<BannerBloc>().add(BannerFecthed());
    context.read<CategoryBloc>().add(CategoryFetched());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: _buildAppbar(), body: SafeArea(child: _buildBody()));
  }

  _buildAppbar() => AppBar(
          title: Text('Minh Long Menu Food', style: context.textStyleLarge),
          actions: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 30,
                // width: 30,
                decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16)),
                child: Text('table',
                    style: context.textStyleSmall!
                        .copyWith(fontWeight: FontWeight.bold))),
            const SizedBox(width: 8),
            Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/mltmenu.appspot.com/o/food%2F2024-03-02%2015%3A35%3A46.683212%2B%223%22.png?alt=media&token=76008777-8c02-4e4c-844d-f4fdc25f144b')))),
            const SizedBox(width: 16)
          ]);

  Widget _buildBody() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
            children: [
          _buildHeader(),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearch(),
                const SliderImage(),
                const SizedBox(height: 16),
                const Categories(),
                _buildTitle(
                    'Món ăn mới', () => context.push(RouteName.newFood)),
                const NewFoods(),
                _buildTitle('Được chọn nhiều',
                    () => context.push(RouteName.popularFood)),
                const PopularFoods(),
                const SizedBox(height: 16)
              ])
        ]
                .animate(interval: 50.ms)
                .slideX(
                    begin: -0.1,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)));
  }

  Widget _buildSearch() {
    return SizedBox(
        height: context.sizeDevice.height * 0.15,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                  onTap: () => context.push(RouteName.food),
                  child: Card(
                      child: SizedBox(
                          height: context.sizeDevice.height * 0.06,
                          child: Row(children: [
                            const SizedBox(width: 8),
                            Row(children: [
                              const Icon(Icons.search, size: 20),
                              const SizedBox(width: 8),
                              Text('Tìm kiếm món ăn...',
                                  style: context.textStyleSmall)
                            ])
                          ])))))
        ]));
  }

  Widget _buildTitle(String title, Function()? onTap) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: context.textStyleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          GestureDetector(
              onTap: onTap,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Xem tất cả',
                    style: context.textStyleSmall!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: context.colorScheme.error)),
                Icon(Icons.navigate_next_rounded,
                    size: 15, color: context.colorScheme.error)
              ]))
        ]));
  }

  Widget _buildHeader() {
    return Container(
        height: context.sizeDevice.height * 0.25,
        // margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(defaultBorderRadius),
                bottomRight: Radius.circular(defaultBorderRadius)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 9.0,
                  spreadRadius: 8.0,
                  color: Colors.black12.withOpacity(0.05))
            ],
            image: const DecorationImage(
                image: AssetImage('assets/image/loginBackground.jpeg'),
                fit: BoxFit.cover),
            color: kPrimaryColor));
  }

  @override
  bool get wantKeepAlive => true;
}
