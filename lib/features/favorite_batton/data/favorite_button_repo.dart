import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';

class FavoriteButtonRepo extends ChangeNotifier {
  final fire = FirebaseFirestore.instance;

  List<KokparEventDto> _favorites = [];

  List<KokparEventDto> get favorites => _favorites;

  set favorites(List<KokparEventDto> value) {
    _favorites = value;
    notifyListeners();
  }

  Future<void> addToFavorites({
    required KokparEventDto event,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userEventFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    if (res != null) {
      KokparEventsList list = KokparEventsList.fromMap(res);
      list.kokparEventsList.add(event.copyWith(isFavorite: true));
      await ref.doc(userPhoneNumber).set(list.toMap());
      favorites = list.kokparEventsList;
    } else {
      await ref
          .doc(userPhoneNumber)
          .set(
            KokparEventsList(
              kokparEventsList: [event.copyWith(isFavorite: true)],
            ).toMap(),
          );
    }
  }

  Future<void> removeFromFavorites({
    required KokparEventDto event,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userEventFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    KokparEventsList list = KokparEventsList.fromMap(res!);
    list.kokparEventsList.removeWhere((item) => item.id == event.id);
    favorites = list.kokparEventsList;
    await ref.doc(userPhoneNumber).set(list.toMap());
  }

  Future<List<KokparEventDto>> getFavoritesEvents(
    String userPhoneNumber,
  ) async {
    List<KokparEventDto> list = [];
    final querySnapshot =
        await fire
            .collection(FireCollections.userEventFavorites)
            .doc(userPhoneNumber)
            .get();

    final data = querySnapshot.data();

    if (data != null) {
      final res = KokparEventsList.fromMap(data);
      list = res.kokparEventsList;
    }
    favorites = list;
    return list;
  }
}
