import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/advertisement_screen/data/models/product_list.dart'
    as adv;

class HomeScreenRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<ProductDto>> getAllProductList() async {
    List<ProductDto> events = [];
    List<adv.ProductList> eventsList = [];

    final ref = await fire.collection(FireCollections.products).get();
    final data = ref.docs.map((e) => e.data()).toList();

    for (var element in data) {
      eventsList.add(adv.ProductList.fromMap(element));
    }

    for (var element in eventsList) {
      events.addAll([
        ...element.machineList,
        ...element.rawMaterialList,
        ...element.workList,
        ...element.fertiliserList,
      ]);
    }

    return events;
  }

  Future<List<String>> getOnlyDocsKokparEvents() async {
    final querySnapshot = await fire.collection(FireCollections.products).get();

    final list = querySnapshot.docs.map((e) => e.id).toList();

    return list;
  }

  Future<List<ProductDto>> getFavoritesEvents(String userPhoneNumber) async {
    List<ProductDto> list = [];
    final querySnapshot =
        await fire
            .collection(FireCollections.userEventFavorites)
            .doc(userPhoneNumber)
            .get();

    final data = querySnapshot.data();

    if (data != null) {
      final res = adv.ProductList.fromMap(data);
      list = [
        ...res.machineList,
        ...res.rawMaterialList,
        ...res.workList,
        ...res.fertiliserList,
      ];
    }

    return list;
  }
}
