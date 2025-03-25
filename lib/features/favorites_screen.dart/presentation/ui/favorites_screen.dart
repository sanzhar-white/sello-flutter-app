import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sello/components/custom_tab_bar.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:sello/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/generated/l10n.dart';
import 'package:sello/components/is_loading.dart';

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

class FavoritesEvents extends StatefulWidget {
  const FavoritesEvents({super.key});

  @override
  State<FavoritesEvents> createState() => _FavoritesEventsState();
}

class _FavoritesEventsState extends State<FavoritesEvents> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final repo = context.watch<FavoriteAdvertsButtonRepo>();
    final allFavorites = repo.favorites;

    if (allFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg_images/favorites_screen.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет избранных объявлений',
              style: TextStyle(color: theme.colors.colorText2, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: allFavorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteCard(allFavorites[index]);
      },
    );
  }

  Widget _buildFavoriteCard(ProductDto product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.images.isNotEmpty ? product.images.first : '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(product.title),
        subtitle: Text(product.price.toString() + ' ₸'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // TODO: Implement remove from favorites
          },
        ),
      ),
    );
  }
}

class FavoritesAdvertsEvents extends StatefulWidget {
  const FavoritesAdvertsEvents({super.key});

  @override
  State<FavoritesAdvertsEvents> createState() => _FavoritesAdvertsEventsState();
}

class _FavoritesAdvertsEventsState extends State<FavoritesAdvertsEvents> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final repo = context.watch<FavoriteAdvertsButtonRepo>();
    final allFavorites = repo.favorites;

    if (allFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg_images/favorites_screen.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет избранных объявлений',
              style: TextStyle(color: theme.colors.colorText2, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: allFavorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteCard(allFavorites[index]);
      },
    );
  }

  Widget _buildFavoriteCard(ProductDto product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.images.isNotEmpty ? product.images.first : '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(product.title),
        subtitle: Text(product.price.toString() + ' ₸'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // TODO: Implement remove from favorites
          },
        ),
      ),
    );
  }
}
