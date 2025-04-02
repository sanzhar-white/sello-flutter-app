part of 'filter_screen_bloc.dart';

@immutable
sealed class FilterScreenEvent {}

class ApplyFilters extends FilterScreenEvent {
  final String category;
  final double? minPrice;
  final double? maxPrice;
  final String? region;
  final String? city;

  ApplyFilters({
    required this.category,
    this.minPrice,
    this.maxPrice,
    this.region,
    this.city,
  });
}

class ResetFilters extends FilterScreenEvent {}
