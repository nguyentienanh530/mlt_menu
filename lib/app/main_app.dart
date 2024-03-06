import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu/features/cart/cubit/cart_cubit.dart';

import '../features/auth/bloc/auth_bloc.dart';
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
          BlocProvider(create: (_) => CartCubit()),
          // BlocProvider(create: (_) => OrderBloc()),
          // BlocProvider(create: (_) => FoodBloc()),
          // BlocProvider(create: (_) => TableBloc()),
          BlocProvider(create: (_) => UserBloc()),
          // BlocProvider(create: (_) => TextSearchCubit())
        ], child: const AppView()));
  }
}
