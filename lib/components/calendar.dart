import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/main_screen/presentation/view_model/main_screen_vm.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime)? chosenDayCallBack;
  final CalendarFormat? calendarFormat;
  final bool headerVisible;
  final DateTime? currentDay;
  final List<dynamic> Function(DateTime)? eventLoader;
  final CalendarBuilders<dynamic>? calendarBuilders;

  const CalendarWidget({
    super.key,
    this.calendarFormat,
    this.headerVisible = false,
    this.chosenDayCallBack,
    this.currentDay,
    this.eventLoader,
    this.calendarBuilders,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Consumer<MainScreenViewModel>(
      builder: (context, vm, _) {
        return TableCalendar(
          locale: vm.locale.languageCode,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          currentDay: widget.currentDay,
          focusedDay: focusedDay,
          headerVisible: widget.headerVisible,
          calendarFormat: widget.calendarFormat ?? CalendarFormat.week,
          daysOfWeekHeight: 24,
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.colors.black,
              fontSize: 12,
            ),
            weekendStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.colors.green,
              fontSize: 12,
            ),
          ),
          onDaySelected: (selectedDay, focusDay) {
            selectedDate = selectedDay;
            focusedDay = focusDay;

            if (widget.chosenDayCallBack != null) {
              widget.chosenDayCallBack!(selectedDay);
            }
            setState(() {});
          },
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          eventLoader: widget.eventLoader,
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: theme.colors.black),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colors.black,
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colors.green.withOpacity(0.4),
            ),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              fontSize: 18,
              color: theme.colors.black,
              fontWeight: FontWeight.w700,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: theme.colors.black,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: theme.colors.black,
            ),
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarBuilders: widget.calendarBuilders ?? const CalendarBuilders(),
        );
      },
    );
  }
}
