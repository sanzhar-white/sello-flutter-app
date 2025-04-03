import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

class IsLoadingWidget extends StatelessWidget {
  const IsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return ColoredBox(
      color: theme.colors.backgroundWidget.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
