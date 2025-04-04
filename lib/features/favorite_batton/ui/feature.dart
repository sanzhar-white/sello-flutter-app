import 'package:flutter/material.dart';
import 'package:selo/features/favorite_batton/ui/favorite_button.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class FavoriteButtonFeature extends StatelessWidget {
  final ProductDto event;

  const FavoriteButtonFeature({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return FavoriteButton(event: event);
  }
}
