part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class GetAllKokparEvents extends HomeScreenEvent {
  final String phoneNumber;
  GetAllKokparEvents({required this.phoneNumber});
}
