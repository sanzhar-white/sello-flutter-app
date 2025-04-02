import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class AdvertisementRepo {
  final fire = FirebaseFirestore.instance;

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
      switch (productType) {
        case ProductType.machine:
          list.machineList.add(event);
          break;
        case ProductType.raw_material:
          list.rawMaterialList.add(event);
          break;
        case ProductType.work:
          list.workList.add(event);
          break;
        case ProductType.fertiliser:
          list.fertiliserList.add(event);
          break;
      }
      await ref.doc(userPhoneNumber).set(list.toMap());
    } else {
      final list = ProductList(
        machineList: [],
        rawMaterialList: [],
        workList: [],
        fertiliserList: [],
      );

      switch (productType) {
        case ProductType.machine:
          list.machineList.add(event);
          break;
        case ProductType.raw_material:
          list.rawMaterialList.add(event);
          break;
        case ProductType.work:
          list.workList.add(event);
          break;
        case ProductType.fertiliser:
          list.fertiliserList.add(event);
          break;
      }

      await ref.doc(userPhoneNumber).set(list.toMap());
    }
  }
}
