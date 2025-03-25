import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:sello/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:collection/collection.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

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
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.colorText3),
          color: theme.colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Icon(
          like != null ? Icons.favorite : Icons.favorite_outline,
          size: 20,
          color: like != null ? theme.colors.red : theme.colors.colorText1,
        ),
      ),
    );
  }
}
