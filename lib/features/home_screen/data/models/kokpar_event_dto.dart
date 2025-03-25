import 'dart:convert';

class KokparEventDto {
  final String id;
  final String title;
  final String authorPhoneNumber;
  final String subTitle;
  final String city;
  final String date;
  final String region;
  final double prizeFund;
  final String description;
  final bool isFavorite;
  final String category;
  final List<String> images;

  KokparEventDto({
    required this.id,
    required this.title,
    required this.authorPhoneNumber,
    required this.subTitle,
    required this.city,
    required this.date,
    required this.region,
    required this.prizeFund,
    required this.description,
    required this.isFavorite,
    required this.category,
    required this.images,
  });

  KokparEventDto copyWith({
    String? id,
    String? title,
    String? authorPhoneNumber,
    String? subTitle,
    String? city,
    String? time,
    String? date,
    String? region,
    String? location,
    double? prizeFund,
    String? description,
    bool? isFavorite,
    String? category,
    List<String>? images,
  }) {
    return KokparEventDto(
      id: id ?? this.id,
      title: title ?? this.title,
      authorPhoneNumber: authorPhoneNumber ?? this.authorPhoneNumber,
      subTitle: subTitle ?? this.subTitle,
      city: time ?? this.city,
      date: date ?? this.date,
      region: location ?? this.region,
      prizeFund: prizeFund ?? this.prizeFund,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'authorPhoneNumber': authorPhoneNumber,
      'subTitle': subTitle,
      'city': city,
      'date': date,
      'region': region,
      'prizeFund': prizeFund,
      'description': description,
      'isFavorite': isFavorite,
      'category': category,
      'images': images,
    };
  }

  factory KokparEventDto.fromMap(Map<String, dynamic> map) {
    return KokparEventDto(
      id: map['id'] as String,
      title: map['title'] as String,
      authorPhoneNumber: map['authorPhoneNumber'] as String,
      subTitle: map['subTitle'] as String,
      city: map['city'] as String,
      date: map['date'] as String,
      region: map['region'] as String,
      prizeFund: map['prizeFund'] as double,
      description: map['description'] as String,
      isFavorite: map['isFavorite'] as bool,
      category: map['category'] as String,
      images: List<String>.from((map['images'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory KokparEventDto.fromJson(String source) =>
      KokparEventDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'KokparEventDto(title: $title, subTitle: $subTitle, city: $city, date: $date, region: $region, prizeFund: $prizeFund, description: $description, isFavorite: $isFavorite, category: $category, images: $images id:$id)';
  }

  @override
  bool operator ==(covariant KokparEventDto other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.authorPhoneNumber == authorPhoneNumber &&
        other.subTitle == subTitle &&
        other.city == city &&
        other.date == date &&
        other.region == region &&
        other.prizeFund == prizeFund &&
        other.description == description &&
        other.category == category;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subTitle.hashCode ^
        city.hashCode ^
        date.hashCode ^
        region.hashCode ^
        prizeFund.hashCode ^
        description.hashCode ^
        isFavorite.hashCode ^
        category.hashCode ^
        images.hashCode;
  }
}
