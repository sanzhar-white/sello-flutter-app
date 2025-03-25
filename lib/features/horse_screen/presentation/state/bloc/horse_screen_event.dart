part of 'horse_screen_bloc.dart';

@immutable
sealed class HorseScreenEvent {}

final class GetAllHorseProduct extends HorseScreenEvent {
  final ProductType productType;

  GetAllHorseProduct({required this.productType});
}

final class GetHorseByCategoryProduct extends HorseScreenEvent {
  final ProductType productType;
  final String category;
  final String? subCategory;

  GetHorseByCategoryProduct({
    required this.productType,
    required this.category,
    this.subCategory,
  });
}
