import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/advertisement_screen/data/models/product_list.dart'
    as adv;
import 'package:selo/features/home_screen/domain/repository/home_screen_repository.dart';

class HomeScreenRepo implements HomeScreenRepository {
  final fire = FirebaseFirestore.instance;

  @override
  Future<List<ProductDto>> getAllKokparEvents({
    required String phoneNumber,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) async {
    List<ProductDto> events = await getAllProductList();

    if (searchQuery?.isNotEmpty ?? false) {
      final query = searchQuery!.toLowerCase();
      events =
          events
              .where(
                (event) =>
                    (event.title?.toLowerCase().contains(query) ?? false) ||
                    (event.description?.toLowerCase().contains(query) ?? false),
              )
              .toList();
    }

    if (filters != null && filters.isNotEmpty) {
      if (filters['category'] != null) {
        events =
            events
                .where((event) => event.productType == filters['category'])
                .toList();
      }

      final priceFrom = filters['priceFrom'] as int?;
      final priceTo = filters['priceTo'] as int?;

      if (priceFrom != null || priceTo != null) {
        events =
            events.where((event) {
              if (priceFrom != null && event.price < priceFrom) return false;
              if (priceTo != null && event.price > priceTo) return false;
              return true;
            }).toList();
      }
    }

    return events;
  }

  @override
  Future<List<String>> getFavoritesEvents(String phoneNumber) async {
    return [];
  }

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
}
