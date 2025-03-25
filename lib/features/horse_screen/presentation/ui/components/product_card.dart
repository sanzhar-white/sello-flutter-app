import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sello/components/utils.dart';
import 'package:collection/collection.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/favorite_adverts_button/ui/feature.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/horse_screen/presentation/ui/components/product_detail_screen/presentation/ui/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductDto product;
  final bool isProfileScreen;
  final VoidCallback? deleteAdvert;

  const ProductCard({
    super.key,
    required this.product,
    this.isProfileScreen = false,
    this.deleteAdvert,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == product.region,
    );

    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == product.city)
            ?.name ??
        '';
    return GestureDetector(
      onTap:
          () => navigateTo(
            context: context,
            screen: ProductDetailScreen(
              isProfileScreen: isProfileScreen,
              product: product,
              deleteAdvert: deleteAdvert,
            ),
          ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.colorText3.withOpacity(0.07),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.images.first,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                          errorWidget:
                              (context, url, error) => Center(
                                child: Container(
                                  color: theme.colors.colorText3.withOpacity(
                                    0.2,
                                  ),
                                ),
                              ),
                        ),
                        Positioned(
                          top: 0,
                          right: -20,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: FavoriteAdvertsButtonFeature(
                              product: product,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: theme.colors.colorText1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        currencyFormat(context, product.price),
                        style: TextStyle(color: theme.colors.colorText1),
                      ),
                      SizedBox(height: 12),
                      Text(
                        region?.name ?? '' + ' ' + city,
                        maxLines: 1,
                        style: TextStyle(
                          color: theme.colors.colorText3,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        dateYMdFromString(context, product.createdDate) +
                            " " +
                            dateHMFromString(context, product.createdDate),
                        style: TextStyle(
                          color: theme.colors.colorText3,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
