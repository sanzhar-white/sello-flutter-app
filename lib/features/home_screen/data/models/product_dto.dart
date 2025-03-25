import 'dart:convert';

class ProductList {
  final List<ProductDto> productList;
  final List<ProductDto> productHorseList;

  ProductList({required this.productList, required this.productHorseList});

  ProductList copyWith({
    List<ProductDto>? productList,
    List<ProductDto>? productHorseList,
  }) {
    return ProductList(
      productList: productList ?? this.productList,
      productHorseList: productHorseList ?? this.productHorseList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productList': productList.map((x) => x.toMap()).toList(),
      'productHorseList': productHorseList.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      productList: List<ProductDto>.from(
        (map['productList'] as List<dynamic>).map<ProductDto>(
          (x) => ProductDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
      productHorseList: List<ProductDto>.from(
        (map['productHorseList'] as List<dynamic>).map<ProductDto>(
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
      'ProductList(productList: $productList, productHorseList: productHorseList)';
}

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

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      title: json['title'] as String,
      authorPhoneNumber: json['authorPhoneNumber'] as String,
      subTitle: json['subTitle'] as String,
      city: json['city'] as String,
      createdDate: json['createdDate'] as String,
      region: json['region'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      categoryId: json['categoryId'] as String,
      subCategoryId: json['subCategoryId'] as String,
      images: List<String>.from(json['images'] as List),
      canAgree: json['canAgree'] as bool? ?? false,
      state: json['state'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      images: List<String>.from((map['images'] as List<dynamic>)),
      canAgree: map['canAgree'] as bool,
      state: map['state'] as String,
    );
  }

  @override
  String toString() {
    return 'ProductDto(id: $id, title: $title, subTitle: $subTitle, description: $description, price: $price, category: $categoryId, state: $state, region: $region, city: $city, authorPhoneNumber: $authorPhoneNumber, createdDate: $createdDate, canAgree: $canAgree, isFavorite: $isFavorite, images: $images)';
  }
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
