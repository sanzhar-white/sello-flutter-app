import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/favorite_adverts_button/ui/feature.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/components/product_detail_screen.dart';

class MiniCard extends StatelessWidget {
  final ProductDto product;
  final double? width;
  final bool isPlaceholder;

  const MiniCard({
    super.key,
    this.width,
    required this.product,
    this.isPlaceholder = false,
  });

  factory MiniCard.placeholder() {
    return MiniCard(
      isPlaceholder: true,
      product: ProductDto(
        id: '',
        title: 'Длинное название объявления для проверки',
        authorPhoneNumber: '+77757777779',
        city: '2024-07-20 19:34:00.000',
        createdDate: DateTime.now().toString(),
        region: 'Зертас ауылы',
        price: 1500000,
        description: 'Lorem ipsum dolor sit amet...',
        isFavorite: false,
        images: [],
        productType: ProductType.machine,
        canAgree: false,
      ),
    );
  }

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

    return Stack(
      children: [
        GestureDetector(
          onTap:
              () => navigateTo(
                context: context,
                rootNavigator: true,
                screen: ProductDetailScreen(product: product),
              ),
          child: Container(
            width: width ?? 170,
            height: 250,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child:
                        product.images.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: product.images.last,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.asset(
                                    'assets/png_images/recomd_image.png',
                                    fit: BoxFit.cover,
                                  ),
                            )
                            : Image.asset(
                              'assets/png_images/recomd_image.png',
                              fit: BoxFit.cover,
                            ),
                  ),
                ),

                // Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${city}\n${region?.name ?? ''}",
                          style: TextStyle(
                            color: theme.colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                () => _launchPhoneDialer(
                                  product.authorPhoneNumber,
                                ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Позвонить"),
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
        if (!isPlaceholder)
          Positioned(
            right: 0,
            top: 0,
            child: FavoriteAdvertsButtonFeature(product: product),
          ),
      ],
    );
  }
}

void _launchPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    print('Не удалось запустить приложение для звонка');
  }
}
