import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/advertisement_screen/data/models/kokpar_events.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

class AdvertisementRepo {
  final fire = FirebaseFirestore.instance;

  Future<void> addKokparEvent({
    required KokparEventDto event,
    required String userPhoneNumber,
  }) async {
    final String date =
        DateTime(
          DateTime.parse(event.date).year,
          DateTime.parse(event.date).month,
          DateTime.parse(event.date).day,
        ).toString();

    final ref = fire.collection(FireCollections.kokparEvents);
    final data = await ref.doc(date).get();
    final res = data.data();
    if (res != null) {
      KokparEventsList list = KokparEventsList.fromMap(res);
      list.kokparEventsList.add(event);
      await ref.doc(date).set(list.toMap());
    } else {
      await ref
          .doc(date)
          .set(KokparEventsList(kokparEventsList: [event]).toMap());
    }
  }

  Future<void> addAdvert({
    required ProductDto event,
    required String userPhoneNumber,
    required ProductType productType,
  }) async {
    final ref = fire.collection(FireCollections.products);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    if (res != null) {
      ProductList list = ProductList.fromMap(res);
      if (productType == ProductType.product) {
        list.productList.add(event);
        await ref.doc(userPhoneNumber).set(list.toMap());
      } else {
        list.productHorseList.add(event);
        await ref.doc(userPhoneNumber).set(list.toMap());
      }
    } else {
      if (productType == ProductType.product) {
        await ref
            .doc(userPhoneNumber)
            .set(
              ProductList(productList: [event], productHorseList: []).toMap(),
            );
      } else {
        await ref
            .doc(userPhoneNumber)
            .set(
              ProductList(productList: [], productHorseList: [event]).toMap(),
            );
      }
    }
  }
}
