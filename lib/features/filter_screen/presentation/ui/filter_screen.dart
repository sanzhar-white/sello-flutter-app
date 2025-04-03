import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/filter_screen/presentation/state/bloc/filter_screen_bloc.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final categories = [
    'Крупы',
    'Спецтехника',
    'Работа',
    'Сырьё',
    'Запчасти',
    'Оборудование',
  ];

  String selectedCategory = 'Спецтехника';
  String? selectedRegion;
  String? selectedCity;
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final bloc = context.read<FilterScreenBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('ФИЛЬТР'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedCategory = 'Спецтехника';
                selectedRegion = null;
                selectedCity = null;
                minPriceController.clear();
                maxPriceController.clear();
              });
              bloc.add(ResetFilters());
            },
            child: Text(
              'Сбросить',
              style: TextStyle(color: theme.colors.green),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Категории',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children:
                  categories.map((category) {
                    final isSelected = category == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category),
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        backgroundColor:
                            isSelected
                                ? theme.colors.green
                                : theme.colors.black.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : theme.colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Местоположение',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.black,
                  ),
                ),
                SizedBox(height: 8),
                _buildDropdownField(
                  'Область',
                  selectedRegion,
                  (value) => setState(() => selectedRegion = value),
                ),
                SizedBox(height: 16),
                Text(
                  'Населенный пункт',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.black,
                  ),
                ),
                SizedBox(height: 8),
                _buildDropdownField(
                  'Алматы',
                  selectedCity,
                  (value) => setState(() => selectedCity = value),
                ),
                SizedBox(height: 16),
                Text(
                  'Цены',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        decoration: InputDecoration(
                          hintText: 'От',
                          filled: true,
                          fillColor: theme.colors.black.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        decoration: InputDecoration(
                          hintText: 'До',
                          filled: true,
                          fillColor: theme.colors.black.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  bloc.add(
                    ApplyFilters(
                      category: selectedCategory,
                      minPrice: double.tryParse(minPriceController.text),
                      maxPrice: double.tryParse(maxPriceController.text),
                      region: selectedRegion,
                      city: selectedCity,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Показать больше 3 тыс. объявлений',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String hint,
    String? value,
    void Function(String?) onChanged,
  ) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        onChanged: onChanged,
        items:
            ['Алматы', 'Астана', 'Шымкент'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
