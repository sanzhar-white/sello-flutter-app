import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class FavoritesRepo {
  final fire = FirebaseFirestore.instance;

  Future<List<ProductDto>> getFavoritesEvents(String userPhoneNumber) async {
    List<ProductDto> list = [];
    final querySnapshot =
        await fire
            .collection(FireCollections.userAdvertFavorites)
            .doc(userPhoneNumber)
            .get();

    final data = querySnapshot.data();

    if (data != null) {
      final res = ProductList.fromMap(data);
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
