part of 'favorites_screen_bloc.dart';

@immutable
sealed class FavoritesScreenEvent {}

final class GetAllFavoritesEvents extends FavoritesScreenEvent {
  final String userPhoneNumber;

  GetAllFavoritesEvents({required this.userPhoneNumber});
}
