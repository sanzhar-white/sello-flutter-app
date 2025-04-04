part of 'favorite_button_bloc.dart';

@immutable
sealed class FavoriteButtonEvent {}

final class GetFavoritesEvents extends FavoriteButtonEvent {
  final String userPhoneNumber;

  GetFavoritesEvents({required this.userPhoneNumber});
}

final class RemoveFromFavorites extends FavoriteButtonEvent {
  final ProductDto event;
  final String userPhoneNumber;

  RemoveFromFavorites({required this.userPhoneNumber, required this.event});
}

final class AddToFavoritesEvent extends FavoriteButtonEvent {
  final String userPhoneNumber;
  final ProductDto event;

  AddToFavoritesEvent({required this.userPhoneNumber, required this.event});
}
