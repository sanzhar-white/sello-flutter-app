import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannersCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final Duration autoPlayInterval;

  const BannersCarousel({
    Key? key,
    required this.banners,
    this.autoPlayInterval = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  _BannersCarouselState createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<BannersCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items:
              widget.banners.map((banner) => _buildBannerItem(banner)).toList(),
          options: CarouselOptions(
            aspectRatio: 10 / 6, // Force 4:3 aspect ratio
            viewportFraction: 0.9,
            autoPlay: true,
            autoPlayInterval: widget.autoPlayInterval,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        // Indicator dots
        _buildIndicatorDots(),
      ],
    );
  }

  Widget _buildBannerItem(BannerModel banner) {
    return GestureDetector(
      onTap: () => banner.onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: _getImageProvider(banner.imageUrl),
            fit: BoxFit.cover, // Ensures image covers the entire 4:3 area
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          widget.banners.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _current = entry.key;
                });
              },
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Color(0xffF2F2F7)
                          : Color(0xff2B654D))
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
    );
  }

  // Function to determine image provider (network or asset)
  ImageProvider _getImageProvider(String url) {
    try {
      if (url.endsWith('.svg')) {
        // Special handling for SVG images
        if (url.startsWith('http') || url.startsWith('https')) {
          return NetworkImage(url); // Network SVG
        } else if (url.startsWith('file:')) {
          return FileImage(File(url.substring(5))); // Local file SVG
        } else {
          // Asset SVG
          return AssetImage(url);
        }
      }

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

// Model to represent a banner with more flexibility
class BannerModel {
  final String imageUrl;
  final VoidCallback? onTap;
  final String? title;
  final String? description;

  const BannerModel({
    required this.imageUrl,
    this.onTap,
    this.title,
    this.description,
  });
}
