import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/custom_divider.dart';
import 'package:sello/components/is_loading.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/presentation/state/bloc/my_adverts_screen_bloc.dart';
import 'package:sello/generated/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDto product;
  final bool isProfileScreen;
  final List<XFile>? images;
  final VoidCallback? deleteAdvert;
  const ProductDetailScreen({
    super.key,
    required this.product,
    this.images,
    this.isProfileScreen = false,
    this.deleteAdvert,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == widget.product.region,
    );

    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == widget.product.city)
            ?.name ??
        '';
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: BlocListener<MyAdvertsScreenBloc, MyAdvertsScreenState>(
            listener: (context, state) {
              if (state is MyAdvertsScreenLoading) {
                isLoading = state.isLoading;
                setState(() {});
              }
              if (state is MyAdvertsScreenSuccess) {
                Navigator.of(context).pop();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSliderDemo(
                    images: widget.images,
                    imgList: widget.product.images,
                  ),
                  const CustomDivider(),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(right: 24),
                  //     child: FavoriteButton(event: kokparEventDto),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: TextStyle(
                            color: theme.colors.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.subTitle,
                          style: TextStyle(
                            color: theme.colors.colorText1,
                            fontSize: 16,
                          ),
                        ),
                        Divider(height: 20, color: theme.colors.colorText1),
                        Text(
                          currencyFormat(context, widget.product.price),
                          style: TextStyle(
                            color: theme.colors.colorText1,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (widget.product.canAgree)
                          Text(
                            S.of(context).negotiable,
                            style: TextStyle(color: theme.colors.colorText3),
                          ),
                        const SizedBox(height: 24),
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
                          widget.product.description,
                          style: TextStyle(color: theme.colors.colorText2),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'тел: ${widget.product.authorPhoneNumber}',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colors.colorText3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${region?.name} ${city}",
                          style: TextStyle(
                            color: theme.colors.colorText3,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet:
              widget.images == null
                  ? widget.isProfileScreen
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 12),
                          //   child: BigButton(
                          //     onPressed: () {},
                          //     label: 'Редактировать',
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: BigButton(
                              onPressed: widget.deleteAdvert!,
                              label: 'Удалить',
                              isActive: false,
                            ),
                          ),
                        ],
                      )
                      : Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: BigButton(
                          onPressed:
                              () => launchUrlString(
                                "tel://${widget.product.authorPhoneNumber}",
                              ),
                          label: 'Хабарласу',
                        ),
                      )
                  : SizedBox.shrink(),
        ),
        if (isLoading) IsLoadingWidget(),
      ],
    );
  }
}

class ImageSliderDemo extends StatefulWidget {
  final List<String> imgList;
  final List<XFile>? images;
  const ImageSliderDemo({super.key, required this.imgList, this.images});

  @override
  State<ImageSliderDemo> createState() => _ImageSliderDemoState();
}

class _ImageSliderDemoState extends State<ImageSliderDemo> {
  int _current = 0;
  final _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    final list = widget.images != null ? widget.images : widget.imgList;
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                pauseAutoPlayInFiniteScroll: false,
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
                  widget.images != null
                      ? widget.images!
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
                          .toList()
                      : widget.imgList
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
                    list!.asMap().entries.map((entry) {
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
                  '/${list.length}',
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
