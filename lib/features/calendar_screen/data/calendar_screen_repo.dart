import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class CalendarScreenRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<CalendarScreenResponse>> getKokparEventsByDate() async {
    List<CalendarScreenResponse> list = [];
    final querySnapshot = await fire.collection(FireCollections.products).get();

    for (var element in querySnapshot.docs) {
      list.add(
        CalendarScreenResponse(
          date: element.id,
          events: ProductList(products: [ProductDto.fromMap(element.data())]),
        ),
      );
    }

    return list;
  }

  Future<List<ProductDto>> getFavoritesEvents(String userPhoneNumber) async {
    List<ProductDto> list = [];
    final querySnapshot =
        await fire
            .collection(FireCollections.userAdvertFavorites)
            .doc(userPhoneNumber)
            .get();

    final data = querySnapshot.data();

    if (data != null) {
      final products = data['list'] as List<dynamic>;
      list = products.map((e) => ProductDto.fromMap(e)).toList();
    }

    return list;
  }
}

class CalendarScreenResponse {
  final String date;
  final ProductList events;

  CalendarScreenResponse({required this.date, required this.events});
}

class ProductList {
  final List<ProductDto> products;

  ProductList({required this.products});
}
