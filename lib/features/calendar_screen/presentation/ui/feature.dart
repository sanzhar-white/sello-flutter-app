import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/calendar_screen/data/calendar_screen_repo.dart';
import 'package:selo/features/calendar_screen/presentation/state/bloc/calendar_screen_bloc.dart';
import 'package:selo/features/calendar_screen/presentation/ui/calendar_screen.dart';
import 'package:selo/features/calendar_screen/presentation/ui/calendar_screen_vm.dart';

class CalendarScreenFeature extends StatelessWidget {
  const CalendarScreenFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CalendarScreenRepo(),
      child: BlocProvider(
        create:
            (context) =>
                CalendarScreenBloc(context.read<CalendarScreenRepo>())..add(
                  GetDataCalendarScreen(
                    phoneNumber:
                        context.read<MyAuthProvider>().userData!.phoneNumber,
                  ),
                ),
        child: ChangeNotifierProvider(
          create: (context) => CalendarScreenViewModel(),
          child: const CalendarScreen(),
        ),
      ),
    );
  }
}
