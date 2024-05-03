import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_client_mobile/features/user/data/model/user_model.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel());
  onUserChanged(UserModel userModel) => emit(userModel);
}
