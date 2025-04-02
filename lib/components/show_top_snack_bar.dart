import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:selo/core/theme/app_colors.dart';

showTopSnackBar({
  required BuildContext context,
  String? title,
  String? message,
  int? duration = 2,
  Color? messageColor = AppColors.redColor,
  Color? titleColor = AppColors.redColor,
}) {
  // final theme = AppThemeProvider.of(context).themeMode;
  Flushbar(
    titleText:
        title != null
            ? Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            )
            : null,
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Text(
      message ?? '',
      style: TextStyle(
        color: messageColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    duration: Duration(seconds: duration ?? 2),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    backgroundColor: Colors.grey.shade200,
    margin: const EdgeInsets.symmetric(horizontal: 12),
  ).show(context);
}
