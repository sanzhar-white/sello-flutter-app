import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class FavoriteAdvertsButtonRepo extends ChangeNotifier {
  final fire = FirebaseFirestore.instance;

  List<ProductDto> _favorites = [];

  List<ProductDto> get favorites => _favorites;

  set favorites(List<ProductDto> value) {
    _favorites = value;
    notifyListeners();
  }

  Future<void> addToFavorites({
    required ProductDto product,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userAdvertFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();
    if (res != null) {
      ListProductDto list = ListProductDto.fromMap(res);

      list.list.add(product.copyWith(isFavorite: true));

      await ref.doc(userPhoneNumber).set(list.toMap());
      favorites = list.list;
    } else {
      await ref
          .doc(userPhoneNumber)
          .set(ListProductDto(list: [product]).toMap());
    }
  }

  Future<void> removeFromFavorites({
    required ProductDto product,
    required String userPhoneNumber,
  }) async {
    final ref = fire.collection(FireCollections.userAdvertFavorites);
    final data = await ref.doc(userPhoneNumber).get();
    final res = data.data();

    ListProductDto list = ListProductDto.fromMap(res!);

    list.list.removeWhere((item) => item.id == product.id);

    favorites = list.list;
    await ref.doc(userPhoneNumber).set(list.toMap());
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
      final res = ListProductDto.fromMap(data);
      list = res.list;
    }
    favorites = list;
    return list;
  }
}

class ListProductDto {
  List<ProductDto> list;
  ListProductDto({required this.list});

  ListProductDto copyWith({List<ProductDto>? list}) {
    return ListProductDto(list: list ?? this.list);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'list': list.map((x) => x.toMap()).toList()};
  }

  factory ListProductDto.fromMap(Map<String, dynamic> map) {
    return ListProductDto(
      list: List<ProductDto>.from(
        (map['list'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListProductDto.fromJson(String source) =>
      ListProductDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ListProductDto(list: $list)';

  @override
  bool operator ==(covariant ListProductDto other) {
    if (identical(this, other)) return true;

    return listEquals(other.list, list);
  }

  @override
  int get hashCode => list.hashCode;
}
