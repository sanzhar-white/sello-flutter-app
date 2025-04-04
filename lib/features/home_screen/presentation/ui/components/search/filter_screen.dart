import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterScreen({
    Key? key,
    required this.activeFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Map<String, dynamic> filters;
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filters = Map.from(widget.activeFilters);
    priceFromController.text = filters['priceFrom']?.toString() ?? '';
    priceToController.text = filters['priceTo']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Scaffold(
      backgroundColor: theme.colors.white,
      appBar: AppBar(
        title: Text(
          'Фильтры',
          style: TextStyle(
            color: theme.colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Категория',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  ProductType.values.map((type) {
                    final isSelected = filters['category'] == type;
                    return FilterChip(
                      label: Text(_getCategoryName(type)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            filters['category'] = type;
                          } else {
                            filters.remove('category');
                          }
                        });
                      },
                      backgroundColor: theme.colors.white,
                      selectedColor: theme.colors.green.withOpacity(0.2),
                      checkmarkColor: theme.colors.green,
                      side: BorderSide(
                        color:
                            isSelected
                                ? theme.colors.green
                                : theme.colors.gray.withOpacity(0.3),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Цена',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceFromController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'От',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: theme.colors.gray.withOpacity(0.3),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      filters['priceFrom'] = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: priceToController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'До',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: theme.colors.gray.withOpacity(0.3),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      filters['priceTo'] = int.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colors.white,
          border: Border(
            top: BorderSide(color: theme.colors.gray.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    filters.clear();
                    priceFromController.clear();
                    priceToController.clear();
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: theme.colors.gray.withOpacity(0.3)),
                ),
                child: Text(
                  'Сбросить',
                  style: TextStyle(color: theme.colors.black),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(filters);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Применить',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(ProductType type) {
    switch (type) {
      case ProductType.machine:
        return 'Спецтехника';
      case ProductType.raw_material:
        return 'Сырьё';
      case ProductType.job:
        return 'Работа';
      case ProductType.fertiliser:
        return 'Удобрение';
      default:
        return 'Неизвестно';
    }
  }

  @override
  void dispose() {
    priceFromController.dispose();
    priceToController.dispose();
    super.dispose();
  }
}
