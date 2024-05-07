import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mlt_client_mobile/common/bloc/bloc_helper.dart';
import 'package:mlt_client_mobile/common/bloc/generic_bloc_state.dart';
import 'package:mlt_client_mobile/core/utils/utils.dart';
import 'package:mlt_client_mobile/features/print/cubit/is_use_print_cubit.dart';
import 'package:mlt_client_mobile/features/print/cubit/print_cubit.dart';
import 'package:mlt_client_mobile/features/print/data/model/print_model.dart';
// import 'package:mlt_client_mobile/features/cart/view/screen/cart_screen.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../dashboard/view/screen/dashboard_screen.dart';
import '../../../print/data/print_data_source/print_data_source.dart';
import '../../../user/bloc/user_bloc.dart';
import '../../../user/cubit/user_cubit.dart';
import '../../../user/data/model/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(), child: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController controller = PageController();

  @override
  void initState() {
    // _updateToken();
    _handleGetPrint();
    getIsUsePrint();
    test();
    super.initState();
  }

  void test() {
    var a = {'name': "Nguyen tien anh", 'age': '28'};
    print(jsonEncode(a));
  }

  void _handleGetPrint() async {
    var print = await PrintDataSource.getPrint();
    if (!mounted) return;
    context.read<PrintCubit>().onPrintChanged(print ?? PrintModel());
  }

  void getIsUsePrint() async {
    var isUsePrint = await PrintDataSource.getIsUsePrint() ?? false;
    if (!mounted) return;
    context.read<IsUsePrintCubit>().onUsePrintChanged(isUsePrint);
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void _updateToken() async {
    var token = await getToken();
    var userID = _getUserID();
    logger.d(userID);
    _handelUpdate(userID, token!);
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  void _handelUpdate(String userID, String token) async {
    FirebaseFirestore.instance
        .collection('user_tokens')
        .doc(userID)
        .update({'token': token});
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserBloc>().state;
    if (user.status == Status.success &&
        context.read<UserBloc>().operation == ApiOperation.select) {
      context.read<UserCubit>().onUserChanged(user.data ?? UserModel());
    }
    return const Scaffold(
        // bottomNavigationBar: _buildBottomBar(context),
        body: DashboardScreen());
  }

  // Widget _buildBottomBar(BuildContext context) {
  //   return ConvexAppBar(
  //       items: [
  //         TabItem(
  //             fontFamily: GoogleFonts.nunito().fontFamily,
  //             icon: SvgPicture.asset('assets/icon/home.svg',
  //                 colorFilter:
  //                     const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
  //             activeIcon: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: SvgPicture.asset('assets/icon/home.svg',
  //                     colorFilter: const ColorFilter.mode(
  //                         Colors.white, BlendMode.srcIn))),
  //             title: "Trang chủ"),
  //         TabItem(
  //             fontFamily: GoogleFonts.nunito().fontFamily,
  //             icon: SvgPicture.asset('assets/icon/cart.svg',
  //                 colorFilter:
  //                     const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
  //             activeIcon: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: SvgPicture.asset('assets/icon/cart.svg',
  //                     colorFilter: const ColorFilter.mode(
  //                         Colors.white, BlendMode.srcIn))),
  //             title: "Giỏ hàng"),
  //         // TabItem(
  //         //     fontFamily: GoogleFonts.nunito().fontFamily,
  //         //     icon: SvgPicture.asset('assets/icon/food.svg',
  //         //         colorFilter:
  //         //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
  //         //     activeIcon: Padding(
  //         //         padding: const EdgeInsets.all(8.0),
  //         //         child: SvgPicture.asset('assets/icon/food.svg',
  //         //             colorFilter: const ColorFilter.mode(
  //         //                 Colors.white, BlendMode.srcIn))),
  //         //     title: "Món ăn"),
  //         // TabItem(
  //         //     fontFamily: GoogleFonts.nunito().fontFamily,
  //         //     icon: SvgPicture.asset('assets/icon/chair.svg',
  //         //         colorFilter:
  //         //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
  //         //     activeIcon: Padding(
  //         //         padding: const EdgeInsets.all(8.0),
  //         //         child: SvgPicture.asset('assets/icon/chair.svg',
  //         //             colorFilter: const ColorFilter.mode(
  //         //                 Colors.white, BlendMode.srcIn))),
  //         //     title: "Bàn ăn"),
  //         // TabItem(
  //         //     fontFamily: GoogleFonts.nunito().fontFamily,
  //         //     icon: SvgPicture.asset('assets/icon/user.svg',
  //         //         colorFilter:
  //         //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
  //         //     activeIcon: Padding(
  //         //         padding: const EdgeInsets.all(8.0),
  //         //         child: SvgPicture.asset('assets/icon/user.svg',
  //         //             colorFilter: const ColorFilter.mode(
  //         //                 Colors.white, BlendMode.srcIn))),
  //         //     title: "Hồ sơ")
  //       ],
  //       style: TabStyle.reactCircle,
  //       activeColor: context.colorScheme.primary,
  //       shadowColor: context.colorScheme.inversePrimary,
  //       backgroundColor: context.colorScheme.background,

  //       // color: context.colorScheme.secondary,
  //       top: -15,
  //       curveSize: 60,
  //       onTap: (index) {
  //         controller.jumpToPage(index);
  //       });
  // }
}

// class HomeView extends StatelessWidget {
//   HomeView({super.key, required this.controller});

//   final PageController controller;
//   @override
//   Widget build(BuildContext context) {
//     return const DashboardScreen();
//     // return PageView(
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     controller: controller,
//     //     children: _widgetOptions);
//   }

//   // final List<Widget> _widgetOptions = [
//   //   const DashboardScreen(),
//   //   // const OrderScreen(),
//   //   // const FoodScreen(),
//   //   // const TableScreen(),
//   //   const CartScreen()
//   // ];
// }
