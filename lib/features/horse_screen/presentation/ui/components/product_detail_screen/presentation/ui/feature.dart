import 'package:flutter/material.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/horse_screen/presentation/ui/components/product_detail_screen/presentation/ui/product_detail_screen.dart';

class ProductDetailScreenFeature extends StatelessWidget {
  const ProductDetailScreenFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductDetailScreen(
      product: ProductDto(
        id: '',
        title: 'Етыктер',
        subTitle: 'Етыктер оптом и в розницу кокпар етыктер',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.',
        price: 12122,
        categoryId: 'category',
        subCategoryId: 'category',
        state: 'state',
        region: 'region',
        city: 'city',
        authorPhoneNumber: 'authorPhoneNumber',
        createdDate: '',
        canAgree: true,
        isFavorite: true,
        images: [],
      ),
    );
  }
}
