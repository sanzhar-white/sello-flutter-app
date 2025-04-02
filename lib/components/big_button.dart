import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

class BigButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isActive;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const BigButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isActive = true,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? theme.colors.primary),
            color: isActive ? theme.colors.primary : theme.colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isActive ? theme.colors.white : theme.colors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
