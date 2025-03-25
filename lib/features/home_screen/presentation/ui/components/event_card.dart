import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/core/theme/theme_provider.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String labelInfo;
  final VoidCallback onTap;
  const EventCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.labelInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.colorText3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyChip(text: labelInfo),
                const SizedBox(height: 24),
                Text(
                  text,
                  style: TextStyle(
                    color: theme.colors.colorText2,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: SvgPicture.asset(imageUrl, fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  final String text;
  const MyChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: theme.colors.white),
      ),
    );
  }
}
