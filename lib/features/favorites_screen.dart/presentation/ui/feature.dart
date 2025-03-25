import 'package:flutter/cupertino.dart';
import 'package:sello/features/favorites_screen.dart/presentation/ui/favorites_screen.dart';

CupertinoPageRoute favoritesScreenRoute(RouteSettings route) {
  return CupertinoPageRoute(
    settings: route,
    builder: (context) {
      return const FavoritesScreen();
    },
  );
}
