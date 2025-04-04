import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:selo/core/enums.dart';

@immutable
class ProductDto {
  final String id;
  final String title;
  final double price;
  final double? maxPrice;
  final List<String> images;
  final String authorPhoneNumber;
  final String city;
  final String createdDate;
  final String region;
  final bool isFavorite;
  final bool canAgree;
  final ProductType productType;

  final String? description;
  final String? contact;

  // Поля для спецтехники и запчастей
  final int? year;
  final bool? isNewState;
  final bool? isMachine;
  final String? state;
  final bool? type_price;
  final bool? type_amount;
  final int? amount;

  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.maxPrice,
    required this.images,
    required this.authorPhoneNumber,
    this.contact,
    required this.city,
    required this.createdDate,
    required this.region,
    required this.isFavorite,
    required this.canAgree,
    this.state,
    this.year,
    this.isNewState,
    this.isMachine,
    this.type_price,
    this.type_amount,
    this.amount,
    required this.productType,
  });

  ProductDto copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? maxPrice,
    List<String>? images,
    String? authorPhoneNumber,
    String? contact,
    String? subTitle,
    String? city,
    String? createdDate,
    String? region,
    bool? isFavorite,
    String? categoryId,
    String? subCategoryId,
    bool? canAgree,
    String? state,
    int? year,
    bool? isNewState,
    bool? isMachine,
    bool? type_price,
    bool? type_amount,
    int? amount,
    ProductType? productType,
  }) {
    return ProductDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      maxPrice: maxPrice ?? this.maxPrice,
      images: images ?? this.images,
      authorPhoneNumber: authorPhoneNumber ?? this.authorPhoneNumber,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      createdDate: createdDate ?? this.createdDate,
      region: region ?? this.region,
      isFavorite: isFavorite ?? this.isFavorite,
      canAgree: canAgree ?? this.canAgree,
      state: state ?? this.state,
      year: year ?? this.year,
      isNewState: isNewState ?? this.isNewState,
      isMachine: isMachine ?? this.isMachine,
      type_price: type_price ?? this.type_price,
      type_amount: type_amount ?? this.type_amount,
      amount: amount ?? this.amount,
      productType: productType ?? this.productType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'maxPrice': maxPrice,
      'images': images,
      'authorPhoneNumber': authorPhoneNumber,
      'contact': contact,
      'city': city,
      'createdDate': createdDate,
      'region': region,
      'isFavorite': isFavorite,
      'canAgree': canAgree,
      'state': state,
      'year': year,
      'isNewState': isNewState,
      'isMachine': isMachine,
      'type_price': type_price,
      'type_amount': type_amount,
      'amount': amount,
      'productType': productType.index,
    };
  }

  factory ProductDto.fromMap(Map<String, dynamic> map) {
    return ProductDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: map['price'] as double,
      maxPrice: map['maxPrice'] as double?,
      images: List<String>.from(map['images'] as List<dynamic>),
      authorPhoneNumber: map['authorPhoneNumber'] as String,
      contact: map['contact'] as String?,
      city: map['city'] as String,
      createdDate: map['createdDate'] as String,
      region: map['region'] as String,
      isFavorite: map['isFavorite'] as bool,
      canAgree: map['canAgree'] as bool,
      state: map['state'] as String?,
      year: map['year'] as int?,
      isNewState: map['isNewState'] as bool?,
      isMachine: map['isMachine'] as bool?,
      type_price: map['type_price'] as bool?,
      type_amount: map['type_amount'] as bool?,
      amount: map['amount'] as int?,
      productType: ProductType.values[map['productType'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDto.fromJson(String source) =>
      ProductDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductDto(id: $id, title: $title, description: $description, price: $price, images: $images, authorPhoneNumber: $authorPhoneNumber, city: $city, createdDate: $createdDate, region: $region, isFavorite: $isFavorite, canAgree: $canAgree, state: $state, year: $year, isNewState: $isNewState, isMachine: $isMachine, type_price: $type_price, type_amount: $type_amount, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDto &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        listEquals(other.images, images) &&
        other.authorPhoneNumber == authorPhoneNumber &&
        other.city == city &&
        other.createdDate == createdDate &&
        other.region == region &&
        other.isFavorite == isFavorite &&
        other.canAgree == canAgree &&
        other.state == state &&
        other.year == year &&
        other.isNewState == isNewState &&
        other.isMachine == isMachine &&
        other.type_price == type_price &&
        other.type_amount == type_amount &&
        other.amount == amount &&
        other.productType == productType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        images.hashCode ^
        authorPhoneNumber.hashCode ^
        city.hashCode ^
        createdDate.hashCode ^
        region.hashCode ^
        isFavorite.hashCode ^
        canAgree.hashCode ^
        state.hashCode ^
        year.hashCode ^
        isNewState.hashCode ^
        isMachine.hashCode ^
        type_price.hashCode ^
        type_amount.hashCode ^
        amount.hashCode ^
        productType.hashCode;
  }
}

class ProductList {
  final List<ProductDto> machineList;
  final List<ProductDto> rawMaterialList;
  final List<ProductDto> workList;
  final List<ProductDto> fertiliserList;

  ProductList({
    required this.machineList,
    required this.rawMaterialList,
    required this.workList,
    required this.fertiliserList,
  });

  ProductList copyWith({
    List<ProductDto>? machineList,
    List<ProductDto>? rawMaterialList,
    List<ProductDto>? workList,
    List<ProductDto>? fertiliserList,
  }) {
    return ProductList(
      machineList: machineList ?? this.machineList,
      rawMaterialList: rawMaterialList ?? this.rawMaterialList,
      workList: workList ?? this.workList,
      fertiliserList: fertiliserList ?? this.fertiliserList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'machineList': machineList.map((x) => x.toMap()).toList(),
      'rawMaterialList': rawMaterialList.map((x) => x.toMap()).toList(),
      'workList': workList.map((x) => x.toMap()).toList(),
      'fertiliserList': fertiliserList.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      machineList: List<ProductDto>.from(
        (map['machineList'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      rawMaterialList: List<ProductDto>.from(
        (map['rawMaterialList'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      workList: List<ProductDto>.from(
        (map['workList'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      fertiliserList: List<ProductDto>.from(
        (map['fertiliserList'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductList(machineList: $machineList, rawMaterialList: $rawMaterialList, workList: $workList, fertiliserList: $fertiliserList)';

  @override
  bool operator ==(covariant ProductList other) {
    if (identical(this, other)) return true;

    return listEquals(other.machineList, machineList) &&
        listEquals(other.rawMaterialList, rawMaterialList) &&
        listEquals(other.workList, workList) &&
        listEquals(other.fertiliserList, fertiliserList);
  }

  @override
  int get hashCode =>
      machineList.hashCode ^
      rawMaterialList.hashCode ^
      workList.hashCode ^
      fertiliserList.hashCode;
}

class Category {
  final String id;
  final String name;
  final List<Category>? subCategories;

  Category({required this.id, required this.name, this.subCategories});

  Category copyWith({String? id, String? name, List<Category>? subCategories}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'subCategories': subCategories?.map((x) => x.toMap()).toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      subCategories:
          map['subCategories'] != null
              ? List<Category>.from(
                (map['subCategories'] as List<int>).map<Category?>(
                  (x) => Category.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Category(id: $id, name: $name, subCategories: $subCategories)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ subCategories.hashCode;
}
