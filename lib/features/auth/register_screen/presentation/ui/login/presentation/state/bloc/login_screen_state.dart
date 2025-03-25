part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenState {}

final class LoginScreenInitial extends LoginScreenState {}

final class LoginScreenLoading extends LoginScreenState {}

final class LoginScreenError extends LoginScreenState {
  final String error;

  LoginScreenError({required this.error});
}

final class NoAccountEvent extends LoginScreenState {
  NoAccountEvent();
}

final class LoginScreenSuccess extends LoginScreenState {
  final String value;

  LoginScreenSuccess({required this.value});
}
