import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:selo/components/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BannersCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final Duration autoPlayInterval;
  final bool isPlaceholder;

  const BannersCarousel({
    Key? key,
    required this.banners,
    this.autoPlayInterval = const Duration(seconds: 10),
    this.isPlaceholder = false,
  }) : super(key: key);

  @override
  _BannersCarouselState createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<BannersCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      isEnabled: widget.isPlaceholder,
      child: Column(
        children: [
          CarouselSlider(
            items:
                widget.banners
                    .map((banner) => _buildBannerItem(banner))
                    .toList(),
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
      ),
    );
  }

  Widget _buildBannerItem(BannerModel banner) {
    return GestureDetector(
      onTap: () => banner.onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: buildImageWidget(banner.imageUrl),
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
