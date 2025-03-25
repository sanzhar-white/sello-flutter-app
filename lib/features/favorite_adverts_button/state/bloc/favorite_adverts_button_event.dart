part of 'favorite_adverts_button_bloc.dart';

@immutable
sealed class FavoriteAdvertsButtonEvent {}

final class GetFavoritesAdvertsEvents extends FavoriteAdvertsButtonEvent {
  final String userPhoneNumber;

  GetFavoritesAdvertsEvents({required this.userPhoneNumber});
}

final class RemoveFromFavoritesAdverts extends FavoriteAdvertsButtonEvent {
  final ProductDto product;
  final String userPhoneNumber;

  RemoveFromFavoritesAdverts({
    required this.userPhoneNumber,
    required this.product,
  });
}

final class AddToFavoritesAdvertsEvent extends FavoriteAdvertsButtonEvent {
  final String userPhoneNumber;
  final ProductDto product;

  AddToFavoritesAdvertsEvent({
    required this.userPhoneNumber,
    required this.product,
  });
}
