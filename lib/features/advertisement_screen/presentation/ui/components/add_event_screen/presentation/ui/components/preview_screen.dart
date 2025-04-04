import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/components/custom_divider.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

class PreviewScreen extends StatelessWidget {
  final ProductDto product;
  final List<XFile> images;
  const PreviewScreen({super.key, required this.product, required this.images});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSliderDemo(imgList: images),
            const CustomDivider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: theme.colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 20, color: theme.colors.black),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/tenge_icon.svg',
                    text: currencyFormat(context, product.price),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/alarm.svg',
                    text: dateHMFromString(
                      context,
                      DateTime.now().toIso8601String(),
                    ),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/calendar_icon.svg',
                    text: dateYMMMdFromString(
                      context,
                      DateTime.now().toIso8601String(),
                    ),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/geo.svg',
                    text: "${product.region}, ${product.city}",
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Сипаттама',
                    style: TextStyle(
                      color: theme.colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description ?? '',
                    style: TextStyle(color: theme.colors.black),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaData extends StatelessWidget {
  final String iconUrl;
  final String text;
  const _MetaData({required this.iconUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            width: 20,
            height: 20,
            iconUrl,
            colorFilter: ColorFilter.mode(theme.colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSliderDemo extends StatefulWidget {
  final List<XFile> imgList;
  const ImageSliderDemo({super.key, required this.imgList});

  @override
  State<ImageSliderDemo> createState() => _ImageSliderDemoState();
}

class _ImageSliderDemoState extends State<ImageSliderDemo> {
  int _current = 0;
  final _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    ;
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              carouselController: _controller,
              items:
                  widget.imgList
                      .map(
                        (item) => Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: Image.file(
                              File(item.path),
                              fit: BoxFit.cover,
                              width: 1000,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    widget.imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colors.green.withOpacity(
                              _current == entry.key ? 0.9 : 0.4,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              Positioned(
                top: 4,
                right: 20,
                child: Text(
                  '${_current + 1}'
                  '/${widget.imgList.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
