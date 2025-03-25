import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';

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
