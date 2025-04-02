import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/core/theme/theme_provider.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onTap;
  const EventCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 8),
        decoration: BoxDecoration(
          color: theme.colors.colorText3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              top: 10,
              right: 0,
              child: _buildImageWidget(imageUrl, width: 90, height: 60),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String url, {double? width, double? height}) {
    try {
      // Consistent border radius
      final borderRadius = BorderRadius.circular(8);

      if (url.endsWith('.svg')) {
        // SVG handling with rounded corners
        Widget svgWidget;
        if (url.startsWith('http') || url.startsWith('https')) {
          svgWidget = SvgPicture.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.fill,
            placeholderBuilder: (context) => _fallbackImage(width, height),
          );
        } else if (url.startsWith('file:')) {
          svgWidget = SvgPicture.file(
            File(url.substring(5)),
            width: width,
            height: height,
            fit: BoxFit.fill,
          );
        } else {
          svgWidget = SvgPicture.asset(
            url,
            width: width,
            height: height,
            fit: BoxFit.fill,
          );
        }

        return ClipRRect(borderRadius: borderRadius, child: svgWidget);
      }

      // Non-SVG image handling with rounded corners
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image(
          image: _getImageProvider(url),
          width: width,
          height: height,
          fit: BoxFit.fill,
          errorBuilder:
              (context, error, stackTrace) => _fallbackImage(width, height),
        ),
      );
    } catch (e) {
      print('Error building image: $e');
      return _fallbackImage(width, height);
    }
  }

  Widget _fallbackImage(double? width, double? height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/placeholder.png',
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    try {
      if (url.startsWith('http') || url.startsWith('https')) {
        return NetworkImage(url);
      } else if (url.startsWith('asset:')) {
        // Support for explicit asset notation
        return AssetImage(url.substring(6));
      } else if (url.startsWith('file:')) {
        // Support for local file images
        return FileImage(File(url.substring(5)));
      } else if (url.contains('/')) {
        // Assume it's an asset path if it contains a path separator
        return AssetImage(url);
      } else {
        // Fallback to a default or error image
        return const AssetImage('assets/placeholder.png');
      }
    } catch (e) {
      // Fallback in case of any unexpected errors
      print('Error loading image: $e');
      return const AssetImage('assets/placeholder.png');
    }
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
