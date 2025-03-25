import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:collection/collection.dart';

class MyAdvertsRepo {
  final fire = FirebaseFirestore.instance;

  //Получаем все объявления пользователя

  Future<List<ProductDto>> getAllProduct(String phoneNumber) async {
    List<ProductDto> events = [];

    final ref =
        await fire.collection(FireCollections.products).doc(phoneNumber).get();

    final data = ProductList.fromMap(ref.data() ?? {});

    events = [...data.productHorseList, ...data.productList];

    return events;
  }

  // Удаление объявления

  Future<void> deleteAdvert(String phoneNumber, String id) async {
    final ref = await fire
        .collection(FireCollections.products)
        .doc(phoneNumber);

    final getData = await ref.get();

    final data = ProductList.fromMap(getData.data() ?? {});

    final productList = data.productList;
    final productHorseList = data.productHorseList;

    final ProductDto? element = productList.firstWhereOrNull(
      (element) => element.id == id,
    );

    productList.remove(element);

    final ProductDto? element2 = productHorseList.firstWhereOrNull(
      (element) => element.id == id,
    );

    productHorseList.remove(element2);

    ref.set(data.toMap());
  }
}
