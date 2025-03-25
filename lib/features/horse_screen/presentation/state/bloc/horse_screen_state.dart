part of 'horse_screen_bloc.dart';

@immutable
sealed class HorseScreenState {}

final class HorseScreenInitial extends HorseScreenState {}

final class HorseScreenData extends HorseScreenState {
  final List<ProductDto> products;

  HorseScreenData({required this.products});
}

final class HorseScreenLoading extends HorseScreenState {}

final class HorseScreenError extends HorseScreenState {
  final String errorMassage;

  HorseScreenError({required this.errorMassage});
}
