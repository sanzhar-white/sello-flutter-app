part of 'home_screen_bloc.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object?> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {
  final bool isLoading;

  const HomeScreenLoading({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class HomeScreenData extends HomeScreenState {
  final List<ProductDto> events;
  final List<String> favoriteEvents;

  const HomeScreenData({required this.events, this.favoriteEvents = const []});

  @override
  List<Object?> get props => [events, favoriteEvents];
}

class HomeScreenError extends HomeScreenState {
  final String message;

  const HomeScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}
