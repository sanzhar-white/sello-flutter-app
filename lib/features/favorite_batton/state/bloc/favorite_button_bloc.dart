import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:selo/features/favorite_batton/data/favorite_button_repo.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

part 'favorite_button_event.dart';
part 'favorite_button_state.dart';

class FavoriteButtonBloc
    extends Bloc<FavoriteButtonEvent, FavoriteButtonState> {
  final FavoriteButtonRepo repo;
  FavoriteButtonBloc(this.repo) : super(FavoriteButtonInitial()) {
    on<GetFavoritesEvents>((event, emit) async {
      try {
        emit(FavoriteButtonLoading());
        final events = await repo.getFavoritesEvents(event.userPhoneNumber);
        emit(FavoriteButtonData(events: events));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteButtonError());
      }
    });
    on<AddToFavoritesEvent>((event, emit) async {
      try {
        emit(FavoriteButtonLoading());
        await repo.addToFavorites(
          event: event.event,
          userPhoneNumber: event.userPhoneNumber,
        );
        final events = await repo.getFavoritesEvents(event.userPhoneNumber);
        // add(GetFavoritesEvents(userPhoneNumber: event.userPhoneNumber));
        emit(FavoriteButtonSuccess());
        emit(FavoriteButtonData(events: events));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteButtonError());
      }
    });

    on<RemoveFromFavorites>((event, emit) async {
      try {
        emit(FavoriteButtonLoading());
        await repo.removeFromFavorites(
          event: event.event,
          userPhoneNumber: event.userPhoneNumber,
        );
        final events = await repo.getFavoritesEvents(event.userPhoneNumber);

        print(event.event.id);
        emit(FavoriteButtonSuccess());
        emit(FavoriteButtonData(events: events));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteButtonError());
      }
    });
  }
}
