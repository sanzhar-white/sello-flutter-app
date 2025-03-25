import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/feature.dart';
import 'package:sello/generated/l10n.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).submitAd,
          style: TextStyle(color: theme.colors.colorText1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(S.of(context).typesAdvertisements),
          ),
          const SizedBox(height: 16),
          _AdvertisementCategoryCard(
            title: S.of(context).event,
            iconUrl: 'assets/svg_images/kokpar.svg',
            onTap:
                () => navigateTo(
                  context: context,
                  rootNavigator: true,
                  screen: const AddEventScreenFeature(),
                ),
          ),
          _AdvertisementCategoryCard(
            title: S.of(context).equipment,
            iconUrl: 'assets/svg_images/ekipirovka.svg',
            onTap:
                () => navigateTo(
                  context: context,
                  rootNavigator: true,
                  screen: AddEventScreenFeature(
                    product: true,
                    productType: ProductType.product,
                  ),
                ),
          ),
          _AdvertisementCategoryCard(
            title: S.of(context).horse,
            iconUrl: 'assets/svg_images/jylky.svg',
            onTap:
                () => navigateTo(
                  context: context,
                  rootNavigator: true,
                  screen: AddEventScreenFeature(
                    horse: true,
                    product: true,
                    productType: ProductType.horse,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _AdvertisementCategoryCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback onTap;
  const _AdvertisementCategoryCard({
    required this.title,
    required this.iconUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: theme.colors.colorText3.withOpacity(0.13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: theme.colors.colorText1)),
            SvgPicture.asset(iconUrl),
          ],
        ),
      ),
    );
  }
}
