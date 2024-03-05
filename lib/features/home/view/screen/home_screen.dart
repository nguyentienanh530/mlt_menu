import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mlt_menu/core/utils/utils.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../dashboard/view/screen/dashboard_screen.dart';
import '../../../user/bloc/user_bloc.dart';
import '../../../user/view/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();

  @override
  void initState() {
    _updateToken();
    super.initState();
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  _updateToken() async {
    var token = await getToken();
    var userID = _getUserID();
    logger.d(userID);
    _handelUpdate(userID, token!);
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  _handelUpdate(String userID, String token) {
    context.read<UserBloc>().add(UpdateToken(userID: userID, token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _buildBottomBar(context),
        body: HomeView(controller: controller));
  }

  Widget _buildBottomBar(BuildContext context) {
    return ConvexAppBar(
        items: [
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/home.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/home.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Trang chủ"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/cart.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/cart.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Giỏ hàng"),
          // TabItem(
          //     fontFamily: GoogleFonts.nunito().fontFamily,
          //     icon: SvgPicture.asset('assets/icon/food.svg',
          //         colorFilter:
          //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          //     activeIcon: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: SvgPicture.asset('assets/icon/food.svg',
          //             colorFilter: const ColorFilter.mode(
          //                 Colors.white, BlendMode.srcIn))),
          //     title: "Món ăn"),
          // TabItem(
          //     fontFamily: GoogleFonts.nunito().fontFamily,
          //     icon: SvgPicture.asset('assets/icon/chair.svg',
          //         colorFilter:
          //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          //     activeIcon: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: SvgPicture.asset('assets/icon/chair.svg',
          //             colorFilter: const ColorFilter.mode(
          //                 Colors.white, BlendMode.srcIn))),
          //     title: "Bàn ăn"),
          // TabItem(
          //     fontFamily: GoogleFonts.nunito().fontFamily,
          //     icon: SvgPicture.asset('assets/icon/user.svg',
          //         colorFilter:
          //             const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          //     activeIcon: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: SvgPicture.asset('assets/icon/user.svg',
          //             colorFilter: const ColorFilter.mode(
          //                 Colors.white, BlendMode.srcIn))),
          //     title: "Hồ sơ")
        ],
        style: TabStyle.reactCircle,
        activeColor: context.colorScheme.primary,
        shadowColor: context.colorScheme.inversePrimary,
        backgroundColor: context.colorScheme.background,

        // color: context.colorScheme.secondary,
        top: -15,
        curveSize: 60,
        onTap: (index) {
          controller.jumpToPage(index);
        });
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key, required this.controller});

  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: _widgetOptions);
  }

  final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    // const OrderScreen(),
    // const FoodScreen(),
    // const TableScreen(),
    const ProfileScreen()
  ];
}
