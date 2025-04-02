import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:selo/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

part 'favorite_adverts_button_event.dart';
part 'favorite_adverts_button_state.dart';

class FavoriteAdvertsButtonBloc
    extends Bloc<FavoriteAdvertsButtonEvent, FavoriteAdvertsButtonState> {
  final FavoriteAdvertsButtonRepo repo;
  FavoriteAdvertsButtonBloc(this.repo) : super(FavoriteAdvertsButtonInitial()) {
    on<GetFavoritesAdvertsEvents>((event, emit) async {
      try {
        // emit(FavoriteAdvertsButtonLoading());
        await repo.getFavoritesEvents(event.userPhoneNumber);
        // emit(FavoriteAdvertsButtonData());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteAdvertsButtonError());
      }
    });
    on<AddToFavoritesAdvertsEvent>((event, emit) async {
      try {
        emit(FavoriteAdvertsButtonLoading());
        await repo.addToFavorites(
          product: event.product,
          userPhoneNumber: event.userPhoneNumber,
        );
        await repo.getFavoritesEvents(event.userPhoneNumber);
        // add(GetFavoritesEvents(userPhoneNumber: event.userPhoneNumber));
        emit(FavoriteAdvertsButtonSuccess());
        emit(FavoriteAdvertsButtonData());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteAdvertsButtonError());
      }
    });

    on<RemoveFromFavoritesAdverts>((event, emit) async {
      try {
        emit(FavoriteAdvertsButtonLoading());
        await repo.removeFromFavorites(
          product: event.product,
          userPhoneNumber: event.userPhoneNumber,
        );
        await repo.getFavoritesEvents(event.userPhoneNumber);

        emit(FavoriteAdvertsButtonSuccess());
        emit(FavoriteAdvertsButtonData());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(FavoriteAdvertsButtonError());
      }
    });
  }
}
