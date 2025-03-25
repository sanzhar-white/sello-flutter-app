part of 'favorite_button_bloc.dart';

@immutable
sealed class FavoriteButtonState {}

final class FavoriteButtonInitial extends FavoriteButtonState {}

final class FavoriteButtonData extends FavoriteButtonState {}

final class FavoriteButtonSuccess extends FavoriteButtonState {}

final class FavoriteButtonLoading extends FavoriteButtonState {}

final class FavoriteButtonError extends FavoriteButtonState {}
