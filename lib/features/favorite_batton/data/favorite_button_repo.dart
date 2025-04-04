import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/advertisement_screen/data/models/product_list.dart'
    as adv;
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class FavoriteButtonRepo extends ChangeNotifier {
  final fire = FirebaseFirestore.instance;

  List<ProductDto> _favorites = [];

  List<ProductDto> get favorites => _favorites;

  set favorites(List<ProductDto> value) {
    _favorites = value;
    notifyListeners();
  }

  Future<void> addToFavorites({
    required ProductDto event,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userEventFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    if (res != null) {
      adv.ProductList list = adv.ProductList.fromMap(res);
      list.machineList.add(event.copyWith(isFavorite: true));
      await ref.doc(userPhoneNumber).set(list.toMap());
      favorites = [
        ...list.machineList,
        ...list.rawMaterialList,
        ...list.workList,
        ...list.fertiliserList,
      ];
    } else {
      await ref
          .doc(userPhoneNumber)
          .set(
            adv.ProductList(
              machineList: [event.copyWith(isFavorite: true)],
              rawMaterialList: [],
              workList: [],
              fertiliserList: [],
            ).toMap(),
          );
    }
  }

  Future<void> removeFromFavorites({
    required ProductDto event,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userEventFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    if (res != null) {
      adv.ProductList list = adv.ProductList.fromMap(res);
      list.machineList.removeWhere((item) => item.id == event.id);
      list.rawMaterialList.removeWhere((item) => item.id == event.id);
      list.workList.removeWhere((item) => item.id == event.id);
      list.fertiliserList.removeWhere((item) => item.id == event.id);
      favorites = [
        ...list.machineList,
        ...list.rawMaterialList,
        ...list.workList,
        ...list.fertiliserList,
      ];
      await ref.doc(userPhoneNumber).set(list.toMap());
    }
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
    favorites = list;
    return list;
  }
}
