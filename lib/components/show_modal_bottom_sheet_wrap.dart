import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

showModalBottomSheetWrap({
  required BuildContext context,
  required Widget child,
}) async {
  final theme = AppThemeProvider.of(context);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    backgroundColor: theme.themeMode.colors.white,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 48,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                ),
              ),
            ),
            child,
          ],
        ),
      );
    },
  );
}
