part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {
  final bool isLoading;
  HomeScreenLoading({required this.isLoading});
}

class HomeScreenData extends HomeScreenState {
  final List<dynamic> events;
  HomeScreenData({required this.events});
}

class HomeScreenError extends HomeScreenState {
  final String message;
  HomeScreenError({required this.message});
}
