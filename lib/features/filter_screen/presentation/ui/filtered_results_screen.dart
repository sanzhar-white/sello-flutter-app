import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/filter_screen/presentation/state/bloc/filter_screen_bloc.dart';
import 'package:selo/features/filter_screen/presentation/ui/filter_screen.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/components/product_card.dart';

class FilteredResultsScreen extends StatelessWidget {
  const FilteredResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return BlocProvider(
      create: (context) => FilterScreenBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Спецтехника'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск в Алматы',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.tune),
                  filled: true,
                  fillColor: theme.colors.black.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FilterScreenBloc, FilterScreenState>(
                builder: (context, state) {
                  if (state is FilterScreenLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is FilterScreenError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is FilterScreenSuccess) {
                    return GridView.builder(
                      padding: EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: state.products[index]);
                      },
                    );
                  }

                  // Initial state - show sample data
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: ProductDto(
                          id: '1',
                          title: 'Трактор Mini Lux',
                          subTitle: 'Трактор Mini Lux в отличном состоянии',
                          description: 'Описание трактора',
                          price: 3000000,
                          categoryId: '1',
                          subCategoryId: '1',
                          state: 'new',
                          region: 'Алматы',
                          city: 'Алматы',
                          authorPhoneNumber: '+77777777777',
                          createdDate: DateTime.now().toString(),
                          images: ['https://example.com/tractor1.jpg'],
                          canAgree: true,
                          isFavorite: false,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
