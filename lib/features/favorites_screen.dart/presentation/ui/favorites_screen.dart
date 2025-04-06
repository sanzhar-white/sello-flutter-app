import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:selo/components/custom_tab_bar.dart';
import 'package:selo/features/favorite_adverts_button/ui/feature.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:selo/features/home_screen/presentation/ui/components/mini_card.dart';
import 'package:selo/components/product_card.dart';
import 'package:selo/generated/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 100),
            Text(
              "Ваше Избранное",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(child: FavoritesAdvertsEvents()),
          ],
        ),
      ),
    );
  }
}

class FavoritesAdvertsEvents extends StatelessWidget {
  const FavoritesAdvertsEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final repo = context.watch<FavoriteAdvertsButtonRepo>();
    final allFavorites = repo.favorites;

    return allFavorites.isEmpty
        ? Column(
          children: [
            SvgPicture.asset('assets/svg_images/favorites_screen.svg'),
            Expanded(
              child: Text(
                S.of(context).featuredAdsWillBeDisplayedHere,
                style: TextStyle(color: theme.colors.black, fontSize: 16),
              ),
            ),
          ],
        )
        : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 0,
            childAspectRatio: 0.9,
          ),
          padding: EdgeInsets.all(16),
          itemCount: allFavorites.length,
          itemBuilder: (context, index) {
            final product = allFavorites[index];
            return ProductCard(
              product: product,
              isFavoriteScreen: true,
              unfavoriteAdvert: FavoriteAdvertsButtonFeature(product: product),
            );
          },
        );
  }
}
