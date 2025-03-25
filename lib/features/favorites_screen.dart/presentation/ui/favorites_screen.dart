import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sello/components/custom_tab_bar.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:sello/features/favorite_batton/data/favorite_button_repo.dart';
import 'package:sello/features/home_screen/presentation/ui/components/kokpar_event_card.dart';
import 'package:sello/features/horse_screen/presentation/ui/components/product_card.dart';
import 'package:sello/generated/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).favorites)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTabBar(
                tabsString: [S.of(context).events, S.of(context).ads],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [FavoritesEvents(), FavoritesAdvertsEvents()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesEvents extends StatelessWidget {
  const FavoritesEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    final repo = context.watch<FavoriteButtonRepo>();
    final allFavorites = repo.favorites;

    return allFavorites.isEmpty
        ? Column(
          children: [
            SvgPicture.asset('assets/svg_images/favorites_screen.svg'),
            Expanded(
              child: Text(
                S.of(context).featuredEventsWillBeDisplayedHere,
                style: TextStyle(color: theme.colors.colorText2, fontSize: 16),
              ),
            ),
          ],
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: allFavorites.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: KokparEventCard(kokparEventDto: allFavorites[index]),
            );
          },
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
                style: TextStyle(color: theme.colors.colorText2, fontSize: 16),
              ),
            ),
          ],
        )
        : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          padding: EdgeInsets.all(16),
          itemCount: allFavorites.length,
          itemBuilder: (context, index) {
            final product = allFavorites[index];

            return ProductCard(product: product);
          },
        );
  }
}
