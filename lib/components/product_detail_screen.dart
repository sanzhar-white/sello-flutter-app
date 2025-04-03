import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/components/big_button.dart';
import 'package:selo/components/custom_divider.dart';
import 'package:selo/components/is_loading.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/my_adverts/presentation/state/bloc/my_adverts_screen_bloc.dart';
import 'package:selo/generated/l10n.dart';
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

  Widget _buildContent() {
    switch (widget.product.productType) {
      case ProductType.machine:
        return _MachineDetailContent(product: widget.product);
      case ProductType.fertiliser:
      case ProductType.raw_material:
        return _MaterialDetailContent(product: widget.product);
      case ProductType.work:
        return _JobDetailContent(product: widget.product);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
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
                  _buildContent(),
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
                          label: 'Позвонить в WhatsApp',
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
                  '/${list.length}',
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

class _MachineDetailContent extends StatelessWidget {
  final ProductDto product;

  const _MachineDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == product.region,
    );
    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == product.city)
            ?.name ??
        '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(
            title: 'Год Выпуска:',
            value: product.year?.toString() ?? '',
          ),
          _InfoRow(
            title: 'Состояние Спецтехники:',
            value: product.isNewState == true ? 'Новый' : 'Б/У',
          ),
          const SizedBox(height: 24),
          Text(
            'О Продавце',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(title: 'ФИО:', value: product.contact ?? ''),
          _InfoRow(title: 'Область:', value: region?.name ?? ''),
          _InfoRow(title: 'Населенный Пункт:', value: city),
          _InfoRow(
            title: 'Контактное Лицо/Компания:',
            value: product.contact ?? '',
          ),
          const SizedBox(height: 24),
          Text(
            'Стоимость:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            title: 'Общая Стоимость:',
            value: '${product.price.toStringAsFixed(0)} ₸',
          ),
          _InfoRow(title: 'Торг:', value: product.canAgree ? 'Да' : 'Нет'),
          const SizedBox(height: 24),
          Text(
            'Доп.Информация',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description ?? '',
            style: TextStyle(fontSize: 16, color: theme.colors.black),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: theme.colors.black),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: theme.colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialDetailContent extends StatelessWidget {
  final ProductDto product;

  const _MaterialDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == product.region,
    );
    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == product.city)
            ?.name ??
        '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(
            title: 'Количество:',
            value:
                '${product.amount} ${product.type_amount == true ? 'кг' : 'шт'}',
          ),
          const SizedBox(height: 24),
          Text(
            'О Продавце',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(title: 'ФИО:', value: product.contact ?? ''),
          _InfoRow(title: 'Область:', value: region?.name ?? ''),
          _InfoRow(title: 'Населенный Пункт:', value: city),
          _InfoRow(
            title: 'Контактное Лицо/Компания:',
            value: product.contact ?? '',
          ),
          const SizedBox(height: 24),
          Text(
            'Стоимость:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            title: 'Цена за единицу:',
            value:
                '${product.price.toStringAsFixed(0)} ₸/${product.type_price == true ? 'кг' : 'шт'}',
          ),
          _InfoRow(title: 'Торг:', value: product.canAgree ? 'Да' : 'Нет'),
          const SizedBox(height: 24),
          Text(
            'Доп.Информация',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description ?? '',
            style: TextStyle(fontSize: 16, color: theme.colors.black),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _JobDetailContent extends StatelessWidget {
  final ProductDto product;

  const _JobDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final region = kzRegions.firstWhereOrNull(
      (element) => element.id == product.region,
    );
    final city =
        region?.subCategories!
            .firstWhereOrNull((element) => element.id == product.city)
            ?.name ??
        '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(title: 'Компания:', value: product.subTitle ?? ''),
          const SizedBox(height: 24),
          Text(
            'О Продавце',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(title: 'ФИО:', value: product.contact ?? ''),
          _InfoRow(title: 'Область:', value: region?.name ?? ''),
          _InfoRow(title: 'Населенный Пункт:', value: city),
          _InfoRow(
            title: 'Контактное Лицо/Компания:',
            value: product.contact ?? '',
          ),
          const SizedBox(height: 24),
          Text(
            'Стоимость:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            title: 'Минимальная цена:',
            value: '${product.price.toStringAsFixed(0)} ₸',
          ),
          _InfoRow(
            title: 'Максимальная цена:',
            value: '${(product.maxPrice ?? 0).toStringAsFixed(0)} ₸',
          ),
          _InfoRow(title: 'Торг:', value: product.canAgree ? 'Да' : 'Нет'),
          const SizedBox(height: 24),
          Text(
            'Доп.Информация',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description ?? '',
            style: TextStyle(fontSize: 16, color: theme.colors.black),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
