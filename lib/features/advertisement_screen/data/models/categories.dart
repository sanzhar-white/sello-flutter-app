import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final List<Category> subCategories;

  Category({
    required this.id,
    required this.name,
    this.subCategories = const [],
  });
}

// Категории для спецтехники
final List<Category> machineCategories = [
  Category(
    id: 'tractor',
    name: 'Трактор',
    subCategories: [
      Category(id: 'new_tractor', name: 'Новый'),
      Category(id: 'used_tractor', name: 'Б/У'),
    ],
  ),
  Category(
    id: 'harvester',
    name: 'Комбайн',
    subCategories: [
      Category(id: 'new_harvester', name: 'Новый'),
      Category(id: 'used_harvester', name: 'Б/У'),
    ],
  ),
  Category(
    id: 'other_machine',
    name: 'Другая техника',
    subCategories: [
      Category(id: 'new_other', name: 'Новая'),
      Category(id: 'used_other', name: 'Б/У'),
    ],
  ),
];

// Категории для сырья
final List<Category> rawMaterialCategories = [
  Category(
    id: 'grain',
    name: 'Зерно',
    subCategories: [
      Category(id: 'wheat', name: 'Пшеница'),
      Category(id: 'barley', name: 'Ячмень'),
      Category(id: 'corn', name: 'Кукуруза'),
    ],
  ),
  Category(
    id: 'oilseeds',
    name: 'Масличные культуры',
    subCategories: [
      Category(id: 'sunflower', name: 'Подсолнечник'),
      Category(id: 'rapeseed', name: 'Рапс'),
      Category(id: 'soybean', name: 'Соя'),
    ],
  ),
  Category(
    id: 'other_raw',
    name: 'Другое сырье',
    subCategories: [
      Category(id: 'cotton', name: 'Хлопок'),
      Category(id: 'sugar_beet', name: 'Сахарная свекла'),
      Category(id: 'other', name: 'Другое'),
    ],
  ),
];

// Категории для работы
final List<Category> workCategories = [
  Category(
    id: 'field_work',
    name: 'Полевые работы',
    subCategories: [
      Category(id: 'plowing', name: 'Вспашка'),
      Category(id: 'sowing', name: 'Посев'),
      Category(id: 'harvesting', name: 'Уборка'),
    ],
  ),
  Category(
    id: 'transport',
    name: 'Транспортные услуги',
    subCategories: [
      Category(id: 'grain_transport', name: 'Перевозка зерна'),
      Category(id: 'equipment_transport', name: 'Перевозка техники'),
      Category(id: 'other_transport', name: 'Другие перевозки'),
    ],
  ),
  Category(
    id: 'other_work',
    name: 'Другие работы',
    subCategories: [
      Category(id: 'repair', name: 'Ремонт техники'),
      Category(id: 'consulting', name: 'Консультации'),
      Category(id: 'other_services', name: 'Другие услуги'),
    ],
  ),
];

// Категории для удобрений
final List<Category> fertiliserCategories = [
  Category(
    id: 'mineral',
    name: 'Минеральные удобрения',
    subCategories: [
      Category(id: 'nitrogen', name: 'Азотные'),
      Category(id: 'phosphorus', name: 'Фосфорные'),
      Category(id: 'potassium', name: 'Калийные'),
    ],
  ),
  Category(
    id: 'organic',
    name: 'Органические удобрения',
    subCategories: [
      Category(id: 'manure', name: 'Навоз'),
      Category(id: 'compost', name: 'Компост'),
      Category(id: 'humus', name: 'Перегной'),
    ],
  ),
  Category(
    id: 'other_fertiliser',
    name: 'Другие удобрения',
    subCategories: [
      Category(id: 'bio', name: 'Биоудобрения'),
      Category(id: 'micro', name: 'Микроудобрения'),
      Category(id: 'other', name: 'Другие'),
    ],
  ),
];

// Состояния товара
final List<Category> productState = [
  Category(id: 'new', name: 'Новый'),
  Category(id: 'used', name: 'Б/У'),
  Category(id: 'refurbished', name: 'Восстановленный'),
];
