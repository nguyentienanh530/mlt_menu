part of 'user_bloc.dart';

class UserEvent {}

class UserFecthed extends UserEvent {
  final String userID;

  UserFecthed({required this.userID});
}

class UserCreated extends UserEvent {
  final UserModel user;

  UserCreated({required this.user});
}

class UserUpdated extends UserEvent {
  final UserModel user;

  UserUpdated({required this.user});
}

class PasswordChanged extends UserEvent {
  final String currentPassword;
  final String newPassword;

  PasswordChanged({required this.currentPassword, required this.newPassword});
}
