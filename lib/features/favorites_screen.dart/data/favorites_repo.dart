import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:selo/features/home_screen/data/models/kokpar_event_dto.dart';

class FavoritesRepo {
  final fire = FirebaseFirestore.instance;

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

    return list;
  }
}
