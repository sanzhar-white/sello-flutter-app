import 'package:flutter/material.dart';
import 'package:sello/core/theme/models/color_scheme.dart';
import 'package:sello/core/theme/models/typography_sheme.dart';
import 'package:sello/core/theme/theme_provider.dart';

enum AppThemeMode {
  light(
    colors: LightScheme(),
    typography: AppTypographyScheme(),
    themeMode: ThemeMode.light,
  ),
  dark(
    typography: AppTypographyScheme(),
    colors: DarkScheme(),
    themeMode: ThemeMode.dark,
  );

  const AppThemeMode({
    required this.colors,
    required this.typography,
    required this.themeMode,
  });

  final AppColorScheme colors;
  final AppTypographyScheme typography;
  final ThemeMode themeMode;

  static AppThemeMode of(BuildContext context) =>
      AppThemeProvider.of(context).themeMode;
}
