import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/components/shimmer.dart';
import 'package:sello/components/utils.dart';
import 'package:collection/collection.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/favorite_batton/ui/feature.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/kokpar_screen.dart/presentation/ui/components/event_detail_screen.dart/presentation/ui/feature.dart';

class KokparEventCard extends StatelessWidget {
  final KokparEventDto kokparEventDto;
  final double? width;

  final bool isPlaceholder;

  const KokparEventCard({
    super.key,
    this.width,
    required this.kokparEventDto,
    this.isPlaceholder = false,
  });

  factory KokparEventCard.placeholder() {
    return KokparEventCard(
      isPlaceholder: true,
      kokparEventDto: KokparEventDto(
        id: '',
        title: 'Боз бала 12',
        authorPhoneNumber: '+77757777779',
        subTitle: 'Атақты батыр, Наурызбай жарысы',
        city: '2024-07-20 19:34:00.000',
        date: '2024-07-20 19:34:00.000',
        region: 'Зертас ауылы',
        prizeFund: 1500000,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.',
        isFavorite: false,
        category: '',
        images: [],
      ),
    );
  }

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

    return Stack(
      children: [
        GestureDetector(
          onTap:
              () => navigateTo(
                context: context,
                rootNavigator: true,
                screen: EventDetailScreenFeature(
                  kokparEventDto: kokparEventDto,
                ),
              ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: width ?? double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color:
                  isPlaceholder
                      ? theme.colors.backgroundColorContainer
                      : theme.colors.primary,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12).copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerPlaceholder(
                          isEnabled: isPlaceholder,
                          child: Text(
                            kokparEventDto.title,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              color: theme.colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ShimmerPlaceholder(
                          isEnabled: isPlaceholder,
                          child: Text(
                            kokparEventDto.subTitle,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        ShimmerPlaceholder(
                          isEnabled: isPlaceholder,
                          child: _MetaData(
                            iconUrl: 'assets/svg_icons/alarm.svg',
                            text: dateHMFromString(
                              context,
                              kokparEventDto.date,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        ShimmerPlaceholder(
                          isEnabled: isPlaceholder,
                          child: _MetaData(
                            iconUrl: 'assets/svg_icons/geo.svg',
                            text: "${region?.name ?? ''}, ${city}",
                          ),
                        ),
                        const SizedBox(height: 2),
                        ShimmerPlaceholder(
                          isEnabled: isPlaceholder,
                          child: _MetaData(
                            iconUrl: 'assets/svg_icons/calendar_icon.svg',
                            text: dateYMMMdFromString(
                              context,
                              kokparEventDto.date,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kokparEventDto.images.isNotEmpty
                    ? Flexible(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(12),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: kokparEventDto.images.last,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/png_images/recomd_image.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    )
                    : Flexible(
                      child: ShimmerPlaceholder(
                        isEnabled: isPlaceholder,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/png_images/recomd_image.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
        if (!isPlaceholder)
          Positioned(
            right: 0,
            top: 2,
            child: FavoriteButtonFeature(event: kokparEventDto),
          ),
      ],
    );
  }
}

class _MetaData extends StatelessWidget {
  final String iconUrl;
  final String text;
  const _MetaData({required this.iconUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconUrl),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
