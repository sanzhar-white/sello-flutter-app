import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';

class KokparScreenRepo {
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
}
