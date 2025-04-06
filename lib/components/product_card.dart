import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/favorite_adverts_button/ui/feature.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';

class ProductCard extends StatefulWidget {
  final ProductDto product;
  final VoidCallback? onTap;
  final bool isProfileScreen;
  final VoidCallback? deleteAdvert;
  FavoriteAdvertsButtonFeature? unfavoriteAdvert;

  bool isFavoriteScreen;

  ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isProfileScreen = false,
    this.isFavoriteScreen = false,
    this.deleteAdvert,
    this.unfavoriteAdvert,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhere(
      (element) => element.id == widget.product.region,
    );

    final city =
        region?.subCategories!
            .firstWhere((element) => element.id == widget.product.city)
            ?.name ??
        '';
    String _categoryByType(ProductType productType) {
      switch (productType) {
        case ProductType.machine:
          return "Спецтехника";
        case ProductType.raw_material:
          return "Сырьё";
        case ProductType.job:
          return "Работа";
        case ProductType.fertiliser:
          return "Удобрение";
        default:
          return "Неизвестная категория";
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.product.images.isNotEmpty
                          ? widget.product.images.first
                          : '',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: theme.colors.gray,
                          child: Icon(
                            Icons.image_not_supported,
                            color: theme.colors.gray,
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.isProfileScreen)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: widget.deleteAdvert,
                          iconSize: 20,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  if (widget.isFavoriteScreen)
                    Positioned(
                      top: 8,
                      right: 8,
                      child:
                          widget.unfavoriteAdvert ??
                          FavoriteAdvertsButtonFeature(product: widget.product),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Название:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colors.gray,
                      ),
                    ),
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Стоимость:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colors.gray,
                      ),
                    ),
                    Text(
                      '${widget.product.price} ₸',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colors.gray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_categoryByType(widget.product.productType)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Место:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colors.gray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${city}, ${region?.name ?? ''}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colors.gray,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
