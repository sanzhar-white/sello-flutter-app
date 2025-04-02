import 'package:flutter/material.dart';
import 'package:selo/core/theme/app_theme_data.dart';

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    super.key,
    required this.themeMode,
    required super.child,
  });

  final AppThemeMode themeMode;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static AppThemeProvider of(BuildContext context) {
    final themeProvider =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    if (themeProvider == null) {
      throw StateError('AppThemeProvider is not provided');
    }

    return themeProvider;
  }
}
