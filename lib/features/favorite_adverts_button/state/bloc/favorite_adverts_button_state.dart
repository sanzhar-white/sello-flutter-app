part of 'favorite_adverts_button_bloc.dart';

@immutable
sealed class FavoriteAdvertsButtonState {}

final class FavoriteAdvertsButtonInitial extends FavoriteAdvertsButtonState {}

final class FavoriteAdvertsButtonData extends FavoriteAdvertsButtonState {}

final class FavoriteAdvertsButtonSuccess extends FavoriteAdvertsButtonState {}

final class FavoriteAdvertsButtonLoading extends FavoriteAdvertsButtonState {}

final class FavoriteAdvertsButtonError extends FavoriteAdvertsButtonState {}
