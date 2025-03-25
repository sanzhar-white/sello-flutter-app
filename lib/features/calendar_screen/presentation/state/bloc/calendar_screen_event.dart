part of 'calendar_screen_bloc.dart';

@immutable
sealed class CalendarScreenEvent {}

final class GetDataCalendarScreen extends CalendarScreenEvent {
  final String phoneNumber;

  GetDataCalendarScreen({required this.phoneNumber});
}
