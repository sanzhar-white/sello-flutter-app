import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/feature.dart';

import 'package:sello/features/home_screen/presentation/ui/feature.dart';
import 'package:sello/features/favorites_screen.dart/presentation/ui/feature.dart';
import 'package:sello/features/main_screen/presentation/ui/components/bottom_bar.dart';
import 'package:sello/features/main_screen/presentation/view_model/main_screen_vm.dart';
import 'package:sello/features/profile_screen/presentation/ui/feature.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _Body(),
      bottomNavigationBar: const MainAppBottomBar(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenViewModel>(
      builder:
          (context, value, child) => Stack(
            children: [
              FadeIndexedStack(
                index: value.activeIndex,
                children: <Widget>[
                  Navigator(
                    key: value.navigatorKeys[0],
                    onGenerateRoute: (route) => homeScreenRoute(route),
                  ),
                  Navigator(
                    key: value.navigatorKeys[1],
                    onGenerateRoute: (route) => favoritesScreenRoute(route),
                  ),
                  Navigator(
                    key: value.navigatorKeys[2],
                    onGenerateRoute: (route) => advertisementScreenRoute(route),
                  ),
                  Navigator(
                    key: value.navigatorKeys[3],
                    onGenerateRoute: (route) => profileScreenRoute(route),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
