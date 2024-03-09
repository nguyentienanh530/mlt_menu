import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu/common/bloc/bloc_helper.dart';
import 'package:mlt_menu/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu/features/user/data/model/user_model.dart';
import 'package:mlt_menu/features/user/data/provider/remote/user_repo.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';

typedef Emit = Emitter<GenericBlocState<UserModel>>;

class UserBloc extends Bloc<UserEvent, GenericBlocState<UserModel>>
    with BlocHelper<UserModel> {
  UserBloc() : super(GenericBlocState.loading()) {
    on<UserFecthed>(_getUser);
    on<UserCreated>(_createUser);
    on<UserUpdated>(_updateUser);
    on<PasswordChanged>(_passwordChanged);
  }

  final _userRepository = UserRepo(
      userRepository:
          UserRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getUser(UserFecthed event, Emit emit) async {
    await getItem(_userRepository.getUser(userID: event.userID), emit);
  }

  FutureOr<void> _createUser(UserCreated event, Emit emit) async {
    await createItem(_userRepository.createUser(userModel: event.user), emit);
  }

  FutureOr<void> _updateUser(UserUpdated event, Emit emit) async {
    await updateItem(_userRepository.updateUser(user: event.user), emit);
  }

  FutureOr<void> _passwordChanged(PasswordChanged event, Emit emit) async {
    await updateItem(
        _userRepository.updatePassword(
            currentPass: event.currentPassword, newPass: event.newPassword),
        emit);
  }
}
