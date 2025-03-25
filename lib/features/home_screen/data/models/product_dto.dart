import 'dart:convert';

class ProductList {
  final List<ProductDto> productList;
  final List<ProductDto> productHorseList;

  ProductList({
    required this.productList,
    required this.productHorseList,
  });

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
  final String subTitle;
  final String description;
  final num price;
  final String categoryId;
  final String subCategoryId;
  final String state;
  final String region;
  final String city;
  final String authorPhoneNumber;
  final String createdDate;
  final bool canAgree;
  final bool isFavorite;
  final List<String> images;

  ProductDto({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.subCategoryId,
    required this.state,
    required this.region,
    required this.city,
    required this.authorPhoneNumber,
    required this.createdDate,
    required this.canAgree,
    required this.isFavorite,
    required this.images,
  });

  ProductDto copyWith({
    String? id,
    String? title,
    String? subTitle,
    String? description,
    double? price,
    String? categoryId,
    String? subCategoryId,
    String? state,
    String? region,
    String? city,
    String? authorPhoneNumber,
    String? createdDate,
    bool? canAgree,
    bool? isFavorite,
    List<String>? images,
  }) {
    return ProductDto(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      state: state ?? this.state,
      region: region ?? this.region,
      city: city ?? this.city,
      authorPhoneNumber: authorPhoneNumber ?? this.authorPhoneNumber,
      createdDate: createdDate ?? this.createdDate,
      canAgree: canAgree ?? this.canAgree,
      isFavorite: isFavorite ?? this.isFavorite,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'price': price,
      'category': categoryId,
      'subCategoryId': subCategoryId,
      'state': state,
      'region': region,
      'city': city,
      'authorPhoneNumber': authorPhoneNumber,
      'createdDate': createdDate,
      'canAgree': canAgree,
      'isFavorite': isFavorite,
      'images': images,
    };
  }

  factory ProductDto.fromMap(Map<String, dynamic> map) {
    return ProductDto(
      id: map['id'] as String,
      title: map['title'] as String,
      subTitle: map['subTitle'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      categoryId: map['category'] as String,
      subCategoryId: map['subCategoryId'] as String,
      state: map['state'] as String,
      region: map['region'] as String,
      city: map['city'] as String,
      authorPhoneNumber: map['authorPhoneNumber'] as String,
      createdDate: map['createdDate'] as String,
      canAgree: map['canAgree'] as bool,
      isFavorite: map['isFavorite'] as bool,
      images: List<String>.from(
        (map['images'] as List<dynamic>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDto.fromJson(String source) =>
      ProductDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductDto(id: $id, title: $title, subTitle: $subTitle, description: $description, price: $price, category: $categoryId, state: $state, region: $region, city: $city, authorPhoneNumber: $authorPhoneNumber, createdDate: $createdDate, canAgree: $canAgree, isFavorite: $isFavorite, images: $images)';
  }
}

class Category {
  final String id;
  final String name;
  final List<Category>? subCategories;

  Category({
    required this.id,
    required this.name,
    this.subCategories,
  });

  Category copyWith({
    String? id,
    String? name,
    List<Category>? subCategories,
  }) {
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
      subCategories: map['subCategories'] != null
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
