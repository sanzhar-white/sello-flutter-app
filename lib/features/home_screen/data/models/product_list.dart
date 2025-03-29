import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

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
