part of 'filter_screen_bloc.dart';

@immutable
sealed class FilterScreenState {}

class FilterScreenInitial extends FilterScreenState {}

class FilterScreenLoading extends FilterScreenState {}

class FilterScreenSuccess extends FilterScreenState {
  final List<ProductDto> products;

  FilterScreenSuccess({required this.products});
}

class FilterScreenError extends FilterScreenState {
  final String message;

  FilterScreenError({required this.message});
}
