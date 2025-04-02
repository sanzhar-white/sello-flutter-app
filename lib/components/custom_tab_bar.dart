import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

class CustomTabBar extends StatelessWidget {
  final TabController? controller;
  final bool isScrollable;
  final List<Widget>? tabs;
  final List<String>? tabsString;
  const CustomTabBar({
    super.key,
    this.controller,
    this.tabs,
    this.isScrollable = false,
    this.tabsString,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TabBar(
        isScrollable: isScrollable,
        controller: controller,
        indicatorWeight: 0,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.themeMode.colors.primary.withOpacity(0.2),
          ),
          color: theme.themeMode.colors.primary,
        ),
        indicatorColor: theme.themeMode.colors.colorText1,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.themeMode.colors.white,
        unselectedLabelColor: theme.themeMode.colors.colorText3,
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        splashBorderRadius: const BorderRadius.all(Radius.circular(6)),
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        // onTap: (value) {
        //   context.read<MainViewModel>().playButtonClick();
        // },
        tabs:
            tabsString != null
                ? [
                  ...List.generate(
                    tabsString!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: Text(tabsString![index]),
                    ),
                  ),
                ]
                : [
                  ...List.generate(
                    tabs!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: tabs![index],
                    ),
                  ),
                ],
      ),
    );
  }
}
