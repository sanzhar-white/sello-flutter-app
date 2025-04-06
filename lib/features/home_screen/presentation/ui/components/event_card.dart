import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/components/shimmer.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onTap;
  final bool isPlaceholder;
  const EventCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return ShimmerPlaceholder(
      isEnabled: isPlaceholder,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 10, top: 8),
          decoration: BoxDecoration(
            color: theme.colors.backgroundWidget,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: theme.colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 0,
                child: buildImageWidget(imageUrl, width: 90, height: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget(
    String imageUrl, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
  }) {
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(imageUrl, height: height, width: width, fit: fit);
    } else {
      return Image.asset(imageUrl, height: height, width: width, fit: fit);
    }
  }
}
