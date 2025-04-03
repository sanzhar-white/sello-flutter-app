import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

class ShowBottomSheetTimePicker extends StatelessWidget {
  final Function(DateTime date) onDateTimeChanged;

  const ShowBottomSheetTimePicker({super.key, required this.onDateTimeChanged});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'готово',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        SizedBox(
          height: 280,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              onDateTimeChanged: (date) {
                onDateTimeChanged(date);
              },
            ),
          ),
        ),
      ],
    );
  }
}
