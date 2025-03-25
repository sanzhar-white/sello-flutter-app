import 'package:flutter/material.dart';
import 'package:sello/features/favorite_adverts_button/ui/favorite_adverts_button.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

class FavoriteAdvertsButtonFeature extends StatelessWidget {
  final ProductDto product;

  const FavoriteAdvertsButtonFeature({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FavoriteAdvertsButton(product: product);
  }
}
