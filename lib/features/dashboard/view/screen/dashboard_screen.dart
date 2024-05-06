import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_client_mobile/common/widget/loading_screen.dart';
import 'package:mlt_client_mobile/core/config/router.dart';
import 'package:mlt_client_mobile/core/utils/utils.dart';
import 'package:mlt_client_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:mlt_client_mobile/features/banner/bloc/banner_bloc.dart';
import 'package:mlt_client_mobile/features/cart/cubit/cart_cubit.dart';
import 'package:mlt_client_mobile/features/category/bloc/category_bloc.dart';
import 'package:mlt_client_mobile/features/dashboard/view/widget/categories.dart';
import 'package:mlt_client_mobile/features/table/cubit/table_cubit.dart';
import 'package:mlt_client_mobile/features/user/bloc/user_bloc.dart';
import 'package:mlt_client_mobile/features/user/cubit/user_cubit.dart';
import '../widget/new_food.dart';
import '../widget/popular_food.dart';
import '../widget/slider.dart';
import 'package:badges/badges.dart' as badges;

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
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (!mounted) return;
    context.read<BannerBloc>().add(BannerFecthed());
    context.read<CategoryBloc>().add(CategoryFetched());
    context
        .read<UserBloc>()
        .add(UserFecthed(userID: context.read<AuthBloc>().state.user.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: _buildFloatingButton(),
        appBar: _buildAppbar(),
        body: SafeArea(child: _buildBody()));
  }

  Widget _buildFloatingButton() {
    var cart = context.watch<CartCubit>().state;
    return FloatingActionButton(
        backgroundColor: context.colorScheme.secondary,
        onPressed: () => context.push(RouteName.cartScreen),
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: badges.Badge(
                badgeStyle: badges.BadgeStyle(
                    badgeColor: context.colorScheme.errorContainer),
                position: badges.BadgePosition.topEnd(top: -14),
                badgeContent: Text(cart.foods.length.toString(),
                    style: context.textStyleSmall!
                        .copyWith(fontWeight: FontWeight.bold)),
                child: SvgPicture.asset('assets/icon/shopping_cart.svg',
                    colorFilter: const ColorFilter.mode(
                        Colors.white, BlendMode.srcIn)))));
  }

  _buildAppbar() {
    var user = context.watch<UserCubit>().state;
    return AppBar(
        title: Text(user.name, style: context.titleStyleMedium),
        actions: [
          _buildTableButton(),
          const SizedBox(width: 8),
          _buildProfile(),
          const SizedBox(width: 16)
        ]);
  }

  Widget _buildProfile() {
    var user = context.watch<UserCubit>().state;

    return GestureDetector(
        onTap: () {
          context.push(RouteName.profile, extra: user);
        },
        child: Container(
            height: 30,
            width: 30,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                border: Border.all(color: context.colorScheme.primary),
                shape: BoxShape.circle),
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: user.image,
                placeholder: (context, url) => const LoadingScreen(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.photo_library_outlined))

            // Image.network(user.image.isEmpty ? noImage : user.image,
            //     fit: BoxFit.cover,
            //     loadingBuilder: (context, child, loadingProgress) =>
            //         loadingProgress == null ? child : const LoadingScreen())
            ));
  }

  Widget _buildErrorImage() => GestureDetector(
      onTap: () => context.push(RouteName.profile),
      child: Container(
          height: 30,
          width: 30,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset('assets/icon/user.svg')));

  Widget _buildTableButton() {
    final table = context.watch<TableCubit>().state;
    return SizedBox(
        height: 30,
        // width: 60,
        child: FilledButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(context.colorScheme.secondary)),
            onPressed: () {
              context.push(RouteName.tableScreen);
            },
            label: Text(table.name.isEmpty ? 'Chọn bàn ăn' : table.name,
                style: context.textStyleSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
            icon: SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset('assets/icon/dinner_table.svg',
                    colorFilter: const ColorFilter.mode(
                        Colors.white, BlendMode.srcIn)))));
  }

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
                SliderImage(),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Categories(),
                ),
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
              style: context.titleStyleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          GestureDetector(
              onTap: onTap,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Xem tất cả',
                    style: context.textStyleLarge!.copyWith(
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
