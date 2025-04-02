import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class MyAdvertsRepo {
  final fire = FirebaseFirestore.instance;

  //Получаем все объявления пользователя

  Future<List<ProductDto>> getAllProduct(String phoneNumber) async {
    List<ProductDto> events = [];

    final ref =
        await fire.collection(FireCollections.products).doc(phoneNumber).get();

    final data = ProductList.fromMap(ref.data() ?? {});

    events = [
      ...data.machineList,
      ...data.rawMaterialList,
      ...data.workList,
      ...data.fertiliserList,
    ];

    return events;
  }

  // Удаление объявления

  Future<void> deleteAdvert(String phoneNumber, String id) async {
    final ref = await fire
        .collection(FireCollections.products)
        .doc(phoneNumber);

    final getData = await ref.get();

    final data = ProductList.fromMap(getData.data() ?? {});

    final machineList = data.machineList;
    final rawMaterialList = data.rawMaterialList;
    final workList = data.workList;
    final fertiliserList = data.fertiliserList;

    final ProductDto? machineElement = machineList.firstWhereOrNull(
      (element) => element.id == id,
    );

    machineList.remove(machineElement);

    final ProductDto? rawElement = rawMaterialList.firstWhereOrNull(
      (element) => element.id == id,
    );

    rawMaterialList.remove(rawElement);

    final ProductDto? workElement = workList.firstWhereOrNull(
      (element) => element.id == id,
    );

    workList.remove(workElement);

    final ProductDto? fertiliserElement = fertiliserList.firstWhereOrNull(
      (element) => element.id == id,
    );

    fertiliserList.remove(fertiliserElement);

    ref.set(data.toMap());
  }
}
