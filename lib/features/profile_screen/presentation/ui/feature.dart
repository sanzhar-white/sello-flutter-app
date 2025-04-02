import 'package:flutter/cupertino.dart';
import 'package:selo/features/profile_screen/presentation/ui/profile_screen.dart';

CupertinoPageRoute profileScreenRoute(RouteSettings route) {
  return CupertinoPageRoute(
    settings: route,
    builder: (context) {
      return const ProfileScreen();
    },
  );
}
