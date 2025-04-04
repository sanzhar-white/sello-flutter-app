part of 'home_screen_bloc.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object?> get props => [];
}

class GetAllKokparEvents extends HomeScreenEvent {
  final String phoneNumber;
  final String? searchQuery;
  final Map<String, dynamic>? filters;

  const GetAllKokparEvents({
    required this.phoneNumber,
    this.searchQuery,
    this.filters,
  });

  @override
  List<Object?> get props => [phoneNumber, searchQuery, filters];
}

class ApplyFilters extends HomeScreenEvent {
  final Map<String, dynamic> filters;

  const ApplyFilters({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class SearchProducts extends HomeScreenEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}
