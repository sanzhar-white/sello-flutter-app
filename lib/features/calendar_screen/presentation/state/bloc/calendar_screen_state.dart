part of 'calendar_screen_bloc.dart';

@immutable
sealed class CalendarScreenState {}

final class CalendarScreenInitial extends CalendarScreenState {}

final class CalendarScreenData extends CalendarScreenState {
  final List<CalendarScreenResponse> data;

  CalendarScreenData({
    required this.data,
    required List<KokparEventDto> favoriteEvents,
  });
}

final class CalendarScreenLoading extends CalendarScreenState {
  final bool isLoading;

  CalendarScreenLoading({required this.isLoading});
}

final class CalendarScreenSuccess extends CalendarScreenState {}

final class CalendarScreenError extends CalendarScreenState {}
