import 'package:flutter/cupertino.dart';
import 'package:selo/features/home_screen/presentation/ui/home_screen.dart';

CupertinoPageRoute homeScreenRoute(RouteSettings route) {
  return CupertinoPageRoute(
    settings: route,
    builder: (context) {
      return const HomeScreen();
    },
  );
}
