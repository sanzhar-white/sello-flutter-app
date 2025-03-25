import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/components/custom_divider.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/favorite_batton/ui/feature.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/generated/l10n.dart';
import 'package:collection/collection.dart';

class EventDetailScreen extends StatelessWidget {
  final KokparEventDto kokparEventDto;
  const EventDetailScreen({super.key, required this.kokparEventDto});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == kokparEventDto.region,
    );

    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == kokparEventDto.city)
            ?.name ??
        '';
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSliderDemo(imgList: kokparEventDto.images),
            const CustomDivider(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: FavoriteButtonFeature(event: kokparEventDto),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kokparEventDto.title,
                    style: TextStyle(
                      color: theme.colors.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kokparEventDto.subTitle,
                    style: TextStyle(
                      color: theme.colors.colorText1,
                      fontSize: 16,
                    ),
                  ),
                  Divider(height: 20, color: theme.colors.colorText1),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/tenge_icon.svg',
                    text: currencyFormat(context, kokparEventDto.prizeFund),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/alarm.svg',
                    text: dateHMFromString(context, kokparEventDto.date),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/calendar_icon.svg',
                    text: dateYMMMdFromString(context, kokparEventDto.date),
                  ),
                  _MetaData(
                    iconUrl: 'assets/svg_icons/geo.svg',
                    text: '${region?.name ?? ''}, ${city}',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).description.toUpperCase(),
                    style: TextStyle(
                      color: theme.colors.colorText1,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    kokparEventDto.description,
                    style: TextStyle(color: theme.colors.colorText2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Организатор:',
                    style: TextStyle(
                      color: theme.colors.colorText2,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kokparEventDto.authorPhoneNumber,
                    style: TextStyle(
                      color: theme.colors.colorText2,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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
            colorFilter: ColorFilter.mode(
              theme.colors.colorText2,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.colors.colorText2,
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
  final List<String> imgList;
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
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                // pageSnapping: false,
                // padEnds: true,
                pauseAutoPlayInFiniteScroll: false,
                // pauseAutoPlayOnManualNavigate: false,
                // pauseAutoPlayOnTouch: false,
                enableInfiniteScroll: false,
                aspectRatio: 2.0,
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
                            child: Image.network(
                              item,
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
                            color: theme.colors.primary.withOpacity(
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
                    color: theme.colors.colorText2,
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
