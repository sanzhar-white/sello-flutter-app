import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';

class CalendarScreenRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<CalendarScreenResponse>> getKokparEventsByDate() async {
    List<CalendarScreenResponse> list = [];
    final querySnapshot =
        await fire.collection(FireCollections.kokparEvents).get();

    for (var element in querySnapshot.docs) {
      list.add(
        CalendarScreenResponse(
          date: element.id,
          events: KokparEventsList.fromMap(element.data()),
        ),
      );
    }

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

class CalendarScreenResponse {
  final String date;
  final KokparEventsList events;

  CalendarScreenResponse({required this.date, required this.events});
}
