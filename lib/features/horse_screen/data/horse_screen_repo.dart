import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

class HorseScreenRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<ProductDto>> getAllHorseProduct(ProductType productType) async {
    List<ProductDto> events = [];
    List<ProductList> eventsList = [];

    final ref = await fire.collection(FireCollections.products).get();
    final data = ref.docs.map((e) => e.data()).toList();

    for (var element in data) {
      eventsList.add(ProductList.fromMap(element));
    }

    for (var element in eventsList) {
      if (productType == ProductType.machine) {
        events.addAll(element.productHorseList);
      } else {
        events.addAll(element.productList);
      }
    }

    return events;
  }
}
