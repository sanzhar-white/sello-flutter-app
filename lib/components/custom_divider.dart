import 'package:flutter/material.dart';
import 'package:sello/core/theme/theme_provider.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Divider(
      thickness: 8,
      color: theme.colors.colorText3.withOpacity(0.2),
    );
  }
}
