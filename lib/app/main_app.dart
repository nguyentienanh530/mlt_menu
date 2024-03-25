import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_food/features/cart/cubit/cart_cubit.dart';
import 'package:mlt_menu_food/features/print/cubit/is_use_print_cubit.dart';
import 'package:mlt_menu_food/features/print/cubit/print_cubit.dart';
import 'package:mlt_menu_food/features/table/cubit/table_cubit.dart';
import 'package:mlt_menu_food/features/user/cubit/user_cubit.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../features/order/bloc/order_bloc.dart';
import '../features/user/bloc/user_bloc.dart';
import 'app_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authenticationRepository,
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: (_) => AuthBloc(
                  authenticationRepository: _authenticationRepository)),
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => CartCubit()),
          BlocProvider(create: (_) => OrderBloc()),
          BlocProvider(create: (_) => TableCubit()),
          BlocProvider(create: (_) => UserCubit()),
          BlocProvider(create: (_) => PrintCubit()),
          BlocProvider(create: (_) => IsUsePrintCubit())
        ], child: const AppView()));
  }
}
