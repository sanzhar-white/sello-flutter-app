import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/core/enums.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final List<ProductDto> results;
  final Function(Map<String, dynamic>) onApplyFilters;

  const SearchResultsScreen({
    Key? key,
    required this.searchQuery,
    required this.results,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Scaffold(
      backgroundColor: theme.colors.backgroundWidget,
      appBar: AppBar(
        backgroundColor: theme.colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colors.backgroundWidget,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: TextEditingController(text: widget.searchQuery),
            decoration: InputDecoration(
              hintText: 'Поиск в Алматы',
              prefixIcon: Icon(Icons.search, color: theme.colors.gray),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: theme.colors.black),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Спецтехника',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: theme.colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                final product = widget.results[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.images.isNotEmpty
                                  ? product.images.first
                                  : 'assets/png_images/recomd_image.png',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'НОВОЕ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colors.black,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.favorite_border,
                              color: theme.colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product.city}, Казахстан',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colors.gray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${product.price} ₸',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Позвонить',
                                      style: TextStyle(
                                        color: theme.colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colors.gray.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.share_outlined),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: theme.colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'ФИЛЬТР',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Сброс фильтров
                          widget.onApplyFilters({});
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Сбросить',
                          style: TextStyle(color: theme.colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Категории',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCategoryChip('Спецтехника', true),
                          _buildCategoryChip('Работа', false),
                          _buildCategoryChip('Сырьё', false),
                          _buildCategoryChip('Запчасти', false),
                          _buildCategoryChip('Оборудование', false),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Местоположение',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField('Область'),
                      const SizedBox(height: 16),
                      Text(
                        'Населенный пункт',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField('Алматы'),
                      const SizedBox(height: 24),
                      Text(
                        'Цены',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildPriceField('От')),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPriceField('До')),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Применение фильтров
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Показать больше 3 тыс. объявлений'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    final theme = AppThemeProvider.of(context).themeMode;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {},
      backgroundColor: theme.colors.backgroundWidget,
      selectedColor: theme.colors.backgroundWidget,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? theme.colors.green : Colors.transparent,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? theme.colors.green : theme.colors.black,
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colors.backgroundWidget,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(hint), Icon(Icons.keyboard_arrow_down)],
      ),
    );
  }

  Widget _buildPriceField(String hint) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colors.backgroundWidget,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(hint),
    );
  }
}
