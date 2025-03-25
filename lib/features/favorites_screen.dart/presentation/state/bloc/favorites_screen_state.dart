part of 'favorites_screen_bloc.dart';

@immutable
sealed class FavoritesScreenState {}

final class FavoritesScreenInitial extends FavoritesScreenState {}

final class FavoritesScreenData extends FavoritesScreenState {
  final List<KokparEventDto> events;

  FavoritesScreenData({required this.events});
}

final class FavoritesScreenLoading extends FavoritesScreenState {
  final bool isLoading;

  FavoritesScreenLoading({this.isLoading = false});
}

final class FavoritesScreenSuccess extends FavoritesScreenState {}

final class FavoritesScreenError extends FavoritesScreenState {}
