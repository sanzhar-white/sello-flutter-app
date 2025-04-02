import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

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
    return {
      'machineList': machineList.map((x) => x.toMap()).toList(),
      'rawMaterialList': rawMaterialList.map((x) => x.toMap()).toList(),
      'workList': workList.map((x) => x.toMap()).toList(),
      'fertiliserList': fertiliserList.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      machineList: List<ProductDto>.from(
        map['machineList']?.map((x) => ProductDto.fromMap(x)) ?? [],
      ),
      rawMaterialList: List<ProductDto>.from(
        map['rawMaterialList']?.map((x) => ProductDto.fromMap(x)) ?? [],
      ),
      workList: List<ProductDto>.from(
        map['workList']?.map((x) => ProductDto.fromMap(x)) ?? [],
      ),
      fertiliserList: List<ProductDto>.from(
        map['fertiliserList']?.map((x) => ProductDto.fromMap(x)) ?? [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductList(machineList: $machineList, rawMaterialList: $rawMaterialList, workList: $workList, fertiliserList: $fertiliserList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductList &&
        listEquals(other.machineList, machineList) &&
        listEquals(other.rawMaterialList, rawMaterialList) &&
        listEquals(other.workList, workList) &&
        listEquals(other.fertiliserList, fertiliserList);
  }

  @override
  int get hashCode {
    return machineList.hashCode ^
        rawMaterialList.hashCode ^
        workList.hashCode ^
        fertiliserList.hashCode;
  }
}
