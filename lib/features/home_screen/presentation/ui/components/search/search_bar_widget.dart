import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/home_screen/presentation/ui/components/search/filter_screen.dart';
import 'package:selo/features/home_screen/presentation/ui/search/search_results_screen.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Map<String, dynamic> activeFilters;
  final List<ProductDto> results;

  const SearchBarWidget({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.activeFilters,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SearchResultsScreen(
                  searchQuery: searchController.text,
                  results: results,
                  activeFilters: activeFilters,
                  onApplyFilters: (filters) {
                    // Обработка фильтров
                  },
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colors.gray.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.search, color: theme.colors.gray),
              ),
              Text(
                'Поиск в Алматы',
                style: TextStyle(color: theme.colors.gray, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
