import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/components/shimmer.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/favorite_adverts_button/ui/feature.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:selo/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

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

  String _formatPrice(num price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} ₸';
  }

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
            decoration: BoxDecoration(
              color: theme.colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ShimmerPlaceholder(
                  isEnabled: isPlaceholder,
                  child: ClipRRect(
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
                                    (context, url) =>
                                        Container(color: Colors.grey[200]),
                                errorWidget:
                                    (context, url, error) => Image.asset(
                                      'assets/png_images/recomd_image.png',
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(
                        isEnabled: isPlaceholder,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShimmerPlaceholder(
                        isEnabled: isPlaceholder,
                        child: Text(
                          _categoryByType(product.productType),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: theme.colors.gray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShimmerPlaceholder(
                        isEnabled: isPlaceholder,
                        child: Text(
                          _formatPrice(product.price),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShimmerPlaceholder(
                        isEnabled: isPlaceholder,
                        child: Text(
                          "${city},\n${trimText(region?.name ?? '')}",
                          style: TextStyle(
                            color: theme.colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isPlaceholder)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween, // Чтобы кнопки не слипались
                      children: [
                        ElevatedButton(
                          onPressed:
                              () =>
                                  _launchPhoneDialer(product.authorPhoneNumber),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colors.green,
                            foregroundColor: theme.colors.white,
                            minimumSize: const Size(
                              90,
                              40,
                            ), // Можно задать фиксированный размер
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Позвонить"),
                        ),
                        const SizedBox(width: 8), // Отступ между кнопками
                        FavoriteAdvertsButton(product: product),
                      ],
                    ),
                  ),
              ],
            ),
          ),
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

String trimText(String text, [int maxLength = 20]) {
  return text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
}

class FavoriteAdvertsButton extends StatefulWidget {
  final ProductDto product;
  const FavoriteAdvertsButton({super.key, required this.product});

  @override
  State<FavoriteAdvertsButton> createState() => _FavoriteAdvertsButtonState();
}

class _FavoriteAdvertsButtonState extends State<FavoriteAdvertsButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>();
    final repo = context.watch<FavoriteAdvertsButtonRepo>();
    final allFavorites = repo.favorites;
    final like = allFavorites.firstWhereOrNull(
      (element) => element.id == widget.product.id,
    );

    return GestureDetector(
      onTap: () {
        like == null
            ? context.read<FavoriteAdvertsButtonBloc>().add(
              AddToFavoritesAdvertsEvent(
                userPhoneNumber: authProvider.userData!.phoneNumber,
                product: widget.product,
              ),
            )
            : context.read<FavoriteAdvertsButtonBloc>().add(
              RemoveFromFavoritesAdverts(
                userPhoneNumber: authProvider.userData!.phoneNumber,
                product: widget.product,
              ),
            );
      },
      child: Container(
        margin: const EdgeInsets.all(0),
        width: 50,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Цвет тени
              offset: Offset(0, 1), // Смещение тени (по оси X и Y)
              blurRadius: 6, // Размытие тени
              spreadRadius: 0, // Распространение тени
            ),
          ],
        ),
        child: Icon(
          like != null ? Icons.favorite : Icons.favorite_outline,
          size: 30,
          color: like != null ? theme.colors.green : theme.colors.black,
        ),
      ),
    );
  }
}
