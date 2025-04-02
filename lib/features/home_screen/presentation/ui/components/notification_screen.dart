import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:selo/features/home_screen/presentation/ui/components/kokpar_event_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {},
        buildWhen:
            (previous, current) =>
                current is HomeScreenData || current is HomeScreenLoading,
        builder: (context, state) {
          if (state is HomeScreenLoading && state.isLoading) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (_, index) => KokparEventCard.placeholder(),
            );
          }
          if (state is HomeScreenData) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.events.length,
              itemBuilder: (_, index) {
                DateTime date = DateTime.parse(state.events[index].date);

                if (date.difference(DateTime.now()).inDays >= 1) {
                  return KokparEventCard(kokparEventDto: state.events[index]);
                }
                return SizedBox();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
