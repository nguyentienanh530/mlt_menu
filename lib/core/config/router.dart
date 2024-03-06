import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/features/cart/view/screen/cart_screen.dart';
import 'package:mlt_menu/features/food/data/model/food_model.dart';
import 'package:mlt_menu/features/food/view/screen/food_detail_screen.dart';
import 'package:mlt_menu/features/food/view/screen/food_on_category.dart';
import 'package:mlt_menu/features/food/view/screen/food_screen.dart';
import 'package:mlt_menu/features/food/view/screen/new_food_screen.dart';
import 'package:mlt_menu/features/food/view/screen/popular_food_screen.dart';
import 'package:mlt_menu/features/user/view/screen/profile_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/category/data/model/category_model.dart';
import '../../features/home/view/screen/home_screen.dart';
import '../../features/login/view/screen/login_screen.dart';
import '../../features/register/view/screen/signup_screen.dart';
import '../../features/user/data/model/user_model.dart';
// import '../features/user/view/screen/change_password.dart';
import '../../features/user/view/screen/update_user.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String food = '/food';
  static const String foodDetail = '/foodDetail';
  static const String order = '/order';
  static const String newFood = '/newFood';
  static const String popularFood = '/popularFood';
  static const String updateUser = '/updateUser';
  static const String changePassword = '/changePassword';
  static const String printSeting = '/printSeting';
  static const String foodOnCategory = '/foodOnCategory';
  static const String cartScreen = '/cartScreen';

  static const publicRoutes = [login, register];
}

final router = GoRouter(
    redirect: (context, state) {
      if (RouteName.publicRoutes.contains(state.fullPath)) {
        return null;
      }
      if (context.read<AuthBloc>().state.status == AuthStatus.authenticated) {
        return null;
      }
      return RouteName.login;
    },
    routes: [
      GoRoute(
          path: RouteName.home,
          builder: (context, state) => const HomeScreen()),

      GoRoute(
          path: RouteName.login,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: RouteName.register,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(
          path: RouteName.food,
          builder: (context, state) => const FoodScreen()),
      GoRoute(
          path: RouteName.newFood,
          builder: (context, state) => const NewFoodsScreen()),
      GoRoute(
          path: RouteName.popularFood,
          builder: (context, state) => const PopularFoodsScreen()),
      GoRoute(
          path: RouteName.foodDetail,
          builder: (context, state) {
            final foodModel = GoRouterState.of(context).extra as FoodModel;
            return FoodDetailScreen(food: foodModel);
          }),
      // GoRoute(
      //     path: RouteName.changePassword,
      //     builder: (context, state) => ChangePassword()),
      GoRoute(
          path: RouteName.updateUser,
          builder: (context, state) {
            final UserModel user = GoRouterState.of(context).extra as UserModel;
            return UpdateUser(user: user);
          }),
      GoRoute(
          path: RouteName.foodOnCategory,
          builder: (context, state) {
            final CategoryModel category =
                GoRouterState.of(context).extra as CategoryModel;
            return FoodOnCategory(category: category);
          }),
      GoRoute(
          path: RouteName.cartScreen,
          builder: (context, state) => const CartScreen()),

      GoRoute(
          path: RouteName.profile,
          builder: (context, state) => const ProfileScreen()),
    ]);
