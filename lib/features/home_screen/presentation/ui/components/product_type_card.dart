import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/core/theme/theme_provider.dart';

class ProductTypeCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onTap;

  const ProductTypeCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colors.colorText3.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                SvgPicture.asset(imageUrl),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: theme.colors.colorText2,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
