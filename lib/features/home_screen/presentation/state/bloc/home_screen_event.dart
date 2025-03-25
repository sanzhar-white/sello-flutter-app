part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenEvent {}

final class GetAllKokparEvents extends HomeScreenEvent {
  final String phoneNumber;

  GetAllKokparEvents({required this.phoneNumber});
}
