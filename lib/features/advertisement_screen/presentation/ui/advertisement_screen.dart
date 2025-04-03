import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/feature.dart';
import 'package:selo/generated/l10n.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              S.of(context).submitAd,
              style: TextStyle(
                color: theme.colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            _AdvertisementCategoryCard(
              title: S.of(context).event,
              iconUrl: 'assets/categories/special_tech.png',
              onTap:
                  () => navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: const AddEventScreenFeature(
                      productType: ProductType.machine,
                    ),
                  ),
            ),
            _AdvertisementCategoryCard(
              title: S.of(context).equipment,
              iconUrl: 'assets/categories/raw.png',
              onTap:
                  () => navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: AddEventScreenFeature(
                      productType: ProductType.raw_material,
                    ),
                  ),
            ),
            _AdvertisementCategoryCard(
              title: S.of(context).horse,
              iconUrl: 'assets/categories/work.png',
              onTap:
                  () => navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: AddEventScreenFeature(
                      productType: ProductType.work,
                    ),
                  ),
            ),
            _AdvertisementCategoryCard(
              title: S.of(context).event,
              iconUrl: 'assets/categories/fertiliser.png',
              onTap:
                  () => navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: const AddEventScreenFeature(
                      productType: ProductType.fertiliser,
                    ),
                  ),
            ),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: theme.colors.backgroundWidget2,
        ),
        child: Row(
          children: [
            CircleAvatar(
              child: Image.asset(iconUrl),
              radius: 30,
              backgroundColor: theme.colors.backgroundWidget2,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
