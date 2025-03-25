part of 'advertisement_screen_bloc.dart';

@immutable
sealed class AdvertisementScreenState {}

final class AdvertisementScreenInitial extends AdvertisementScreenState {}

final class AdvertisementScreenSuccess extends AdvertisementScreenState {}

final class AdvertisementScreenError extends AdvertisementScreenState {
  final String errorMassage;

  AdvertisementScreenError({required this.errorMassage});
}

final class AdvertisementScreenLoading extends AdvertisementScreenState {}
