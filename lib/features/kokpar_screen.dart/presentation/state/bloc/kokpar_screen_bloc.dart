import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/kokpar_screen.dart/data/kokpar_screen_repo.dart';

part 'kokpar_screen_event.dart';
part 'kokpar_screen_state.dart';

class KokparScreenBloc extends Bloc<KokparScreenEvent, KokparScreenState> {
  final KokparScreenRepo repo;
  KokparScreenBloc(this.repo) : super(KokparScreenInitial()) {
    on<GetAllEvents>((event, emit) async {
      try {
        emit(KokparScreenLoading(isLoading: true));
        final events = await repo.getAllKokparEvents();
        emit(KokparScreenLoading(isLoading: false));
        emit(KokparScreenData(events: events));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(KokparScreenError());
      }
    });
  }
}
