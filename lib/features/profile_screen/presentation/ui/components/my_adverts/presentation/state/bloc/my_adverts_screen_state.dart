part of 'my_adverts_screen_bloc.dart';

@immutable
sealed class MyAdvertsScreenState {}

final class MyAdvertsScreenInitial extends MyAdvertsScreenState {}

final class MyAdvertsScreenSuccess extends MyAdvertsScreenState {}

final class MyAdvertsScreenData extends MyAdvertsScreenState {
  final List<ProductDto> products;

  MyAdvertsScreenData({required this.products});
}

final class MyAdvertsScreenLoading extends MyAdvertsScreenState {
  final bool isLoading;

  MyAdvertsScreenLoading({required this.isLoading});
}

final class MyAdvertsScreenError extends MyAdvertsScreenState {
  final String errorMassage;

  MyAdvertsScreenError({required this.errorMassage});
}
