import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:selo/components/calendar.dart';
import 'package:selo/components/is_loading.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/calendar_screen/data/calendar_screen_repo.dart';
import 'package:selo/features/calendar_screen/presentation/state/bloc/calendar_screen_bloc.dart';
import 'package:selo/features/calendar_screen/presentation/ui/calendar_screen_vm.dart';
import 'package:selo/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:selo/features/home_screen/presentation/ui/components/kokpar_event_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool isLoading = false;

  eventLoader(DateTime date, List<CalendarScreenResponse> data) {
    List<KokparEventDto> events = [];
    for (var item in data) {
      if (item.date == date.toString().split('Z')[0]) {
        events.addAll(item.events.kokparEventsList);
      }
    }

    return events;
  }

  int ind = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: BlocConsumer<CalendarScreenBloc, CalendarScreenState>(
            listener: (context, state) {
              if (state is CalendarScreenLoading) {
                setState(() {
                  isLoading = state.isLoading;
                });
              }
              if (state is CalendarScreenSuccess) {
                showTopSnackBar(
                  context: context,
                  title: "Мероприятие добавлено в избранное",
                  titleColor: theme.colors.green,
                );
              }
            },
            buildWhen: (previous, current) => current is CalendarScreenData,
            builder: (context, state) {
              if (state is CalendarScreenData) {
                return Consumer<CalendarScreenViewModel>(
                  builder: (context, vm, _) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          CalendarWidget(
                            headerVisible: true,
                            calendarFormat: CalendarFormat.month,
                            chosenDayCallBack: (date) {
                              vm.selectedDate = date;
                            },
                            eventLoader:
                                (date) => eventLoader(date, state.data),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, day, events) {
                                if (events.isNotEmpty) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg_icons/hors_icon.svg',
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${events.length}',
                                        style: TextStyle(
                                          color: theme.colors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          Column(
                            children: [
                              ...List.generate(state.data.length, (index) {
                                ind = index;
                                if (vm.selectedDate.toString().split('Z')[0] ==
                                    state.data[index].date) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        ...state
                                            .data[index]
                                            .events
                                            .kokparEventsList
                                            .map(
                                              (e) => KokparEventCard(
                                                kokparEventDto: e,
                                              ),
                                            ),
                                      ],
                                    ),
                                  );
                                }

                                return SizedBox.shrink();
                              }),
                              if (vm.selectedDate.toString().split('Z')[0] !=
                                  state.data[ind].date)
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 48),
                                      SvgPicture.asset(
                                        'assets/svg_images/no_data_cuate.svg',
                                        width: 250,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'На ${dateYMdFromString(context, vm.selectedDate.toString())} объявлений нет',
                                        style: TextStyle(
                                          color: theme.colors.colorText3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        if (isLoading) const IsLoadingWidget(),
      ],
    );
  }
}
