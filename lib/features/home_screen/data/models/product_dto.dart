import 'dart:convert';
import 'package:flutter/foundation.dart';

class ProductDto {
  final String id;
  final String title;
  final String authorPhoneNumber;
  final String subTitle;
  final String city;
  final String createdDate;
  final String region;
  final double price;
  final String description;
  final bool isFavorite;
  final String categoryId;
  final String subCategoryId;
  final List<String> images;
  final bool canAgree;
  final String state;

  ProductDto({
    required this.id,
    required this.title,
    required this.authorPhoneNumber,
    required this.subTitle,
    required this.city,
    required this.createdDate,
    required this.region,
    required this.price,
    required this.description,
    required this.isFavorite,
    required this.categoryId,
    required this.subCategoryId,
    required this.images,
    required this.canAgree,
    required this.state,
  });

  ProductDto copyWith({
    String? id,
    String? title,
    String? authorPhoneNumber,
    String? subTitle,
    String? city,
    String? createdDate,
    String? region,
    double? price,
    String? description,
    bool? isFavorite,
    String? categoryId,
    String? subCategoryId,
    List<String>? images,
    bool? canAgree,
    String? state,
  }) {
    return ProductDto(
      id: id ?? this.id,
      title: title ?? this.title,
      authorPhoneNumber: authorPhoneNumber ?? this.authorPhoneNumber,
      subTitle: subTitle ?? this.subTitle,
      city: city ?? this.city,
      createdDate: createdDate ?? this.createdDate,
      region: region ?? this.region,
      price: price ?? this.price,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      images: images ?? this.images,
      canAgree: canAgree ?? this.canAgree,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'authorPhoneNumber': authorPhoneNumber,
      'subTitle': subTitle,
      'city': city,
      'createdDate': createdDate,
      'region': region,
      'price': price,
      'description': description,
      'isFavorite': isFavorite,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'images': images,
      'canAgree': canAgree,
      'state': state,
    };
  }

  factory ProductDto.fromMap(Map<String, dynamic> map) {
    return ProductDto(
      id: map['id'] as String,
      title: map['title'] as String,
      authorPhoneNumber: map['authorPhoneNumber'] as String,
      subTitle: map['subTitle'] as String,
      city: map['city'] as String,
      createdDate: map['createdDate'] as String,
      region: map['region'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      isFavorite: map['isFavorite'] as bool,
      categoryId: map['categoryId'] as String,
      subCategoryId: map['subCategoryId'] as String,
      images: List<String>.from(map['images'] as List<dynamic>),
      canAgree: map['canAgree'] as bool,
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDto.fromJson(String source) =>
      ProductDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductDto(id: $id, title: $title, authorPhoneNumber: $authorPhoneNumber, subTitle: $subTitle, city: $city, createdDate: $createdDate, region: $region, price: $price, description: $description, isFavorite: $isFavorite, categoryId: $categoryId, subCategoryId: $subCategoryId, images: $images, canAgree: $canAgree, state: $state)';

  @override
  bool operator ==(covariant ProductDto other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.authorPhoneNumber == authorPhoneNumber &&
        other.subTitle == subTitle &&
        other.city == city &&
        other.createdDate == createdDate &&
        other.region == region &&
        other.price == price &&
        other.description == description &&
        other.isFavorite == isFavorite &&
        other.categoryId == categoryId &&
        other.subCategoryId == subCategoryId &&
        listEquals(other.images, images) &&
        other.canAgree == canAgree &&
        other.state == state;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      authorPhoneNumber.hashCode ^
      subTitle.hashCode ^
      city.hashCode ^
      createdDate.hashCode ^
      region.hashCode ^
      price.hashCode ^
      description.hashCode ^
      isFavorite.hashCode ^
      categoryId.hashCode ^
      subCategoryId.hashCode ^
      images.hashCode ^
      canAgree.hashCode ^
      state.hashCode;
}
