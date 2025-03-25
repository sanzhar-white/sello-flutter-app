import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/favorites_screen.dart/data/favorites_repo.dart';

part 'favorites_screen_event.dart';
part 'favorites_screen_state.dart';

class FavoritesScreenBloc
    extends Bloc<FavoritesScreenEvent, FavoritesScreenState> {
  final FavoritesRepo repo;
  FavoritesScreenBloc(this.repo) : super(FavoritesScreenInitial()) {
    on<GetAllFavoritesEvents>((event, emit) async {
      try {
        emit(FavoritesScreenLoading());
        final events = await repo.getFavoritesEvents(event.userPhoneNumber);
        emit(FavoritesScreenData(events: events));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoritesScreenError());
      }
    });
  }
}
