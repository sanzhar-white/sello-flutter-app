part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenEvent {}

final class LoginEvent extends LoginScreenEvent {
  final String phoneNumber;

  LoginEvent({required this.phoneNumber});
}
