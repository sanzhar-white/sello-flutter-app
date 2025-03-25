part of 'kokpar_screen_bloc.dart';

@immutable
sealed class KokparScreenState {}

final class KokparScreenInitial extends KokparScreenState {}

final class KokparScreenData extends KokparScreenState {
  final List<KokparEventDto> events;

  KokparScreenData({required this.events});
}

final class KokparScreenLoading extends KokparScreenState {
  final bool isLoading;

  KokparScreenLoading({required this.isLoading});
}

final class KokparScreenSuccess extends KokparScreenState {}

final class KokparScreenError extends KokparScreenState {}
