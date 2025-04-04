import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/feature.dart';
import 'package:selo/generated/l10n.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  Future<void> _refreshData() async {
    // Здесь можно добавить логику обновления данных
    await Future.delayed(Duration(seconds: 1)); // Имитация загрузки
    setState(() {}); // Обновление состояния
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Text(
                'Новое Объявление',
                style: TextStyle(
                  color: theme.colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 24),
              _AdvertisementCategoryCard(
                title: 'Спецтехника',
                iconUrl: 'assets/to_add/machine_logo.svg',
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
                title: 'Сырьё',
                iconUrl: 'assets/to_add/raw_logo.svg',
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
                title: 'Работа',
                iconUrl: 'assets/to_add/job_logo.svg',
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
                title: 'Удобрение/Гирбицид',
                iconUrl: 'assets/to_add/fer_logo.svg',
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colors.backgroundWidget2,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colors.backgroundWidget2,
              ),
              child:
                  iconUrl.endsWith('.svg')
                      ? SvgPicture.asset(iconUrl, fit: BoxFit.cover)
                      : Image.asset(iconUrl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black54, size: 24),
          ],
        ),
      ),
    );
  }
}
