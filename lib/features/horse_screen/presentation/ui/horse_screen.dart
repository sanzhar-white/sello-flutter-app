import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/horse_screen/presentation/state/bloc/horse_screen_bloc.dart';
import 'package:sello/features/horse_screen/presentation/ui/components/product_card.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/kokpar_screen.dart/presentation/ui/kokpar_screen.dart';

class HorseScreen extends StatefulWidget {
  final ProductType productType;
  const HorseScreen({super.key, required this.productType});

  @override
  State<HorseScreen> createState() => _HorseScreenState();
}

class _HorseScreenState extends State<HorseScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final bloc = context.read<HorseScreenBloc>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              bloc.add(GetAllHorseProduct(productType: widget.productType));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Все',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<HorseScreenBloc, HorseScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HorseScreenData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Категория',
                    style: TextStyle(
                      color: theme.colors.colorText1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                widget.productType == ProductType.horse
                    ? SizedBox(
                      height: 80,
                      child: ListView(
                        padding: const EdgeInsets.only(left: 16),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...List.generate(
                            horseCategories.length,
                            (index) => CategoryCard(
                              text: horseCategories[index].name,
                              imageUrl: 'assets/svg_images/jylky.svg',
                              onTap: () {
                                bloc.add(
                                  GetHorseByCategoryProduct(
                                    productType: widget.productType,
                                    category: horseCategories[index].id,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    : _ProductsCategories(
                      bloc: bloc,
                      productType: widget.productType,
                    ),
                const SizedBox(height: 24),
                Divider(
                  thickness: 8,
                  color: theme.colors.colorText3.withOpacity(0.2),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 260,
                    ),
                    padding: EdgeInsets.all(16),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      return ProductCard(product: product);
                    },
                  ),
                ),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductsCategories extends StatefulWidget {
  final HorseScreenBloc bloc;
  final ProductType productType;
  const _ProductsCategories({required this.bloc, required this.productType});

  @override
  State<_ProductsCategories> createState() => _ProductsCategoriesState();
}

class _ProductsCategoriesState extends State<_ProductsCategories> {
  late final GroupButtonController controller;
  late final GroupButtonController categoryController;

  @override
  void initState() {
    controller = GroupButtonController();
    categoryController = GroupButtonController();

    super.initState();
  }

  Category? category;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final productCategoryList = productCategories(context);
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GroupButton(
              controller: controller,
              buttons: productCategoryList.map((e) => e.name).toList(),
              onSelected: (i, selected, _) {
                category = productCategoryList[selected];
                widget.bloc.add(
                  GetHorseByCategoryProduct(
                    productType: widget.productType,
                    category: category!.id,
                  ),
                );
                categoryController.unselectAll();
                setState(() {});
              },
              options: GroupButtonOptions(
                selectedTextStyle: const TextStyle(color: Colors.white),
                selectedColor: theme.colors.primary,
                unselectedColor: theme.colors.colorText3.withOpacity(0.2),
                unselectedTextStyle: TextStyle(color: theme.colors.colorText2),
                unselectedShadow: [],
                selectedShadow: [],
                borderRadius: BorderRadius.circular(8),
                groupingType: GroupingType.wrap,
                buttonHeight: 36,
                textPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (category != null)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GroupButton(
              controller: categoryController,
              buttons: category!.subCategories!.map((e) => e.name).toList(),
              onSelected: (i, selected, _) {
                widget.bloc.add(
                  GetHorseByCategoryProduct(
                    productType: widget.productType,
                    category: category!.id,
                    subCategory: category!.subCategories![selected].id,
                  ),
                );
              },
              options: GroupButtonOptions(
                selectedTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                selectedColor: theme.colors.primary,
                unselectedColor: theme.colors.colorText3.withOpacity(0.2),
                unselectedTextStyle: TextStyle(
                  fontSize: 12,
                  color: theme.colors.colorText2.withOpacity(0.7),
                ),
                unselectedShadow: [],
                selectedShadow: [],
                borderRadius: BorderRadius.circular(8),
                groupingType: GroupingType.row,
                buttonHeight: 28,
                textPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
      ],
    );
  }
}
