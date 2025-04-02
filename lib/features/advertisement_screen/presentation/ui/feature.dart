import 'package:flutter/cupertino.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/advertisement_screen.dart';

CupertinoPageRoute advertisementScreenRoute(RouteSettings route) {
  return CupertinoPageRoute(
    settings: route,
    builder: (context) {
      return const AdvertisementScreen();
    },
  );
}
