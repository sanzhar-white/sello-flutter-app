part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenState {}

final class HomeScreenInitial extends HomeScreenState {}

final class HomeScreenLoading extends HomeScreenState {
  final bool isLoading;

  HomeScreenLoading({this.isLoading = false});
}

final class HomeScreenData extends HomeScreenState {
  final List<ProductDto> events;

  HomeScreenData({
    required this.events,
    required List<ProductDto> favoriteEvents,
  });
}

final class HomeScreenSuccess extends HomeScreenState {}

final class HomeScreenError extends HomeScreenState {}
