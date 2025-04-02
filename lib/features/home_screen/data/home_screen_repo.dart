import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:selo/features/home_screen/data/models/kokpar_event_dto.dart';

class HomeScreenRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<KokparEventDto>> getAllKokparEvents() async {
    List<KokparEventDto> events = [];
    List<KokparEventsList> eventsList = [];

    final ref = await fire.collection(FireCollections.kokparEvents).get();
    final data = ref.docs.map((e) => e.data()).toList();

    for (var element in data) {
      eventsList.add(KokparEventsList.fromMap(element));
    }

    for (var element in eventsList) {
      events.addAll(element.kokparEventsList);
    }

    return events;
  }

  Future<List<String>> getOnlyDocsKokparEvents() async {
    final querySnapshot =
        await fire.collection(FireCollections.kokparEvents).get();

    final list = querySnapshot.docs.map((e) => e.id).toList();

    return list;
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

    return list;
  }
}
