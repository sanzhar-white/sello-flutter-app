import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:selo/features/home_screen/data/home_screen_repo.dart';
import 'package:selo/features/home_screen/data/models/kokpar_event_dto.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final HomeScreenRepo repo;
  HomeScreenBloc(this.repo) : super(HomeScreenInitial()) {
    on<GetAllKokparEvents>((event, emit) async {
      try {
        emit(HomeScreenLoading(isLoading: true));

        final events = await repo.getAllKokparEvents();
        final favoriteEvents = await repo.getFavoritesEvents(event.phoneNumber);
        emit(HomeScreenLoading(isLoading: false));
        emit(HomeScreenData(events: events, favoriteEvents: favoriteEvents));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(HomeScreenLoading(isLoading: false));
        emit(HomeScreenError());
      }
    });
  }
}
