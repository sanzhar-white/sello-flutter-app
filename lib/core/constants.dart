import 'package:flutter/material.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/generated/l10n.dart';

class KokparEventCategoryConst {
  static const String international = "International";
  static const String state = "State";
  static const String regional = "Regional";
  static const String district = "District";
}

class FireCollections {
  static const String users = 'users';
  static const String kokparEvents = 'kokparEvents';
  static const String userEventFavorites = 'userEventFavorites';
  static const String userAdvertFavorites = 'userAdvertFavorites';
  static const String products = 'products';
}

List<Category> horseCategories = [
  Category(id: '0', name: 'Құлын'),
  Category(id: '1', name: 'Жабағы'),
  Category(id: '2', name: 'Тай'),
  Category(id: '3', name: 'Құнан'),
  Category(id: '4', name: 'Дөнен'),
  Category(id: '5', name: 'Сәурік'),
  Category(id: '6', name: 'Бесті'),
];

List<Category> productState = [
  Category(id: '0', name: 'Жаңа'),
  Category(id: '1', name: 'Бұрын қолданылған'),
];

List<Category> kokparEventCategories(BuildContext context) {
  final list = [
    Category(id: '0', name: S.of(context).international),
    Category(id: '1', name: S.of(context).state),
    Category(id: '2', name: S.of(context).regional),
    Category(id: '3', name: S.of(context).rural),
  ];
  return list;
}

List<Category> productCategories(BuildContext context) {
  List<Category> list = [
    Category(
      id: '0',
      name: S.of(context).horseHarness,
      subCategories: [
        Category(id: '0', name: S.of(context).saddle, subCategories: []),
        Category(id: '1', name: S.of(context).halter, subCategories: []),
        Category(id: '2', name: S.of(context).bridle, subCategories: []),
        Category(id: '3', name: S.of(context).stirrup, subCategories: []),
        Category(id: '4', name: S.of(context).horseshoe, subCategories: []),
        Category(id: '5', name: S.of(context).other, subCategories: []),
      ],
    ),
    Category(
      id: '1',
      name: S.of(context).horseCare,
      subCategories: [
        Category(
          id: '0',
          name: S.of(context).horseshoeStand,
          subCategories: [],
        ),
        Category(id: '1', name: S.of(context).brushes, subCategories: []),
        Category(id: '2', name: S.of(context).feedGrass, subCategories: []),
        Category(id: '3', name: S.of(context).careTools, subCategories: []),
        Category(id: '4', name: S.of(context).other, subCategories: []),
      ],
    ),
    Category(
      id: '2',
      name: S.of(context).forRider,
      subCategories: [
        Category(id: '0', name: S.of(context).shoes, subCategories: []),
        Category(id: '1', name: S.of(context).whip, subCategories: []),
        Category(id: '2', name: S.of(context).headgear, subCategories: []),
        Category(id: '3', name: S.of(context).clothing, subCategories: []),
        Category(id: '4', name: S.of(context).other, subCategories: []),
      ],
    ),
  ];
  return list;
}
