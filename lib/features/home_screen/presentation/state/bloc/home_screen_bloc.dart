import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/home_screen/data/home_screen_repo.dart';
import 'package:selo/features/home_screen/domain/repository/home_screen_repository.dart';
import 'package:selo/features/home_screen/presentation/ui/components/mini_card.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final HomeScreenRepo repository;

  HomeScreenBloc({required this.repository}) : super(HomeScreenInitial()) {
    on<GetAllKokparEvents>(_onGetAllKokparEvents);
    on<ApplyFilters>(_onApplyFilters);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onGetAllKokparEvents(
    GetAllKokparEvents event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      emit(HomeScreenLoading(isLoading: true));
      final events = await repository.getAllKokparEvents(
        phoneNumber: event.phoneNumber,
        searchQuery: event.searchQuery,
        filters: event.filters,
      );
      emit(HomeScreenData(events: events));
    } catch (e) {
      emit(HomeScreenError(message: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is HomeScreenData) {
      final currentState = state as HomeScreenData;
      final filteredEvents = _applyFiltersToEvents(
        currentState.events,
        event.filters,
      );
      emit(HomeScreenData(events: filteredEvents));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is HomeScreenData) {
      final currentState = state as HomeScreenData;
      final searchResults = _searchInEvents(currentState.events, event.query);
      emit(HomeScreenData(events: searchResults));
    }
  }

  List<ProductDto> _applyFiltersToEvents(
    List<ProductDto> events,
    Map<String, dynamic> filters,
  ) {
    return events.where((event) {
      bool matchesCategory = true;
      bool matchesPriceRange = true;

      if (filters['category'] != null) {
        matchesCategory = event.productType == filters['category'];
      }

      if (filters['priceFrom'] != null || filters['priceTo'] != null) {
        final priceFrom = filters['priceFrom'] as int?;
        final priceTo = filters['priceTo'] as int?;

        if (priceFrom != null && event.price < priceFrom) {
          matchesPriceRange = false;
        }
        if (priceTo != null && event.price > priceTo) {
          matchesPriceRange = false;
        }
      }

      return matchesCategory && matchesPriceRange;
    }).toList();
  }

  List<ProductDto> _searchInEvents(List<ProductDto> events, String query) {
    if (query.isEmpty) return events;

    final lowercaseQuery = query.toLowerCase();
    return events.where((event) {
      return (event.title?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (event.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
}
