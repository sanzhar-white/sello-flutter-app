import 'package:flutter/cupertino.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/advertisement_screen.dart';

CupertinoPageRoute advertisementScreenRoute(RouteSettings route) {
  return CupertinoPageRoute(
    settings: route,
    builder: (context) {
      return const AdvertisementScreen();
    },
  );
}
