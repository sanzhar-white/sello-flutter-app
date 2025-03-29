import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product_dto.dart' as adv_product;
import '../models/product_list.dart' as adv_product_list;
import '../models/product_type.dart' as adv_type;

class AdvertisementRepo {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AdvertisementRepo({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  Future<void> addAdvert({
    required List<XFile> images,
    required adv_product.ProductDto product,
    required String userPhoneNumber,
    required adv_type.ProductType productType,
  }) async {
    try {
      // Загрузка изображений
      final List<String> imageUrls = [];
      for (var image in images) {
        final ref = _storage.ref().child(
          'products/${product.id}/${DateTime.now().millisecondsSinceEpoch}',
        );
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Обновление продукта с URL изображений
      final updatedProduct = product.copyWith(images: imageUrls);

      // Получение документа пользователя
      final userDoc =
          await _firestore.collection('users').doc(userPhoneNumber).get();

      if (userDoc.exists) {
        // Если документ существует, обновляем соответствующий список
        final data = userDoc.data() as Map<String, dynamic>;
        final productList = adv_product_list.ProductList.fromMap(
          data['products'] ?? {},
        );

        switch (productType) {
          case adv_type.ProductType.machine:
            productList.machineList.add(updatedProduct);
            break;
          case adv_type.ProductType.raw_material:
            productList.rawMaterialList.add(updatedProduct);
            break;
          case adv_type.ProductType.work:
            productList.workList.add(updatedProduct);
            break;
          case adv_type.ProductType.fertiliser:
            productList.fertiliserList.add(updatedProduct);
            break;
        }

        await _firestore.collection('users').doc(userPhoneNumber).update({
          'products': productList.toMap(),
        });
      } else {
        // Если документа нет, создаем новый с пустыми списками
        final productList = adv_product_list.ProductList(
          machineList: [],
          rawMaterialList: [],
          workList: [],
          fertiliserList: [],
        );

        switch (productType) {
          case adv_type.ProductType.machine:
            productList.machineList.add(updatedProduct);
            break;
          case adv_type.ProductType.raw_material:
            productList.rawMaterialList.add(updatedProduct);
            break;
          case adv_type.ProductType.work:
            productList.workList.add(updatedProduct);
            break;
          case adv_type.ProductType.fertiliser:
            productList.fertiliserList.add(updatedProduct);
            break;
        }

        await _firestore.collection('users').doc(userPhoneNumber).set({
          'products': productList.toMap(),
        });
      }
    } catch (e) {
      debugPrint('Error adding advert: $e');
      rethrow;
    }
  }

  Future<adv_product_list.ProductList> getProducts(
    String userPhoneNumber,
  ) async {
    try {
      final doc =
          await _firestore.collection('users').doc(userPhoneNumber).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return adv_product_list.ProductList.fromMap(data['products'] ?? {});
      }

      return adv_product_list.ProductList(
        machineList: [],
        rawMaterialList: [],
        workList: [],
        fertiliserList: [],
      );
    } catch (e) {
      debugPrint('Error getting products: $e');
      rethrow;
    }
  }
}
