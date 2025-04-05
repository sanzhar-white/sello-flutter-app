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
      case ProductType.job:
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
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 10 / 6, // Force 4:3 aspect ratio
                viewportFraction: 1,
                autoPlay: false,
                enlargeCenterPage: true,
                pauseAutoPlayInFiniteScroll: false,
                enableInfiniteScroll: false,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          Text(
            product.title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: theme.colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // General Info Section
          _SectionHeader(title: 'Общая информация'),
          _InfoRow(
            title: 'Год Выпуска:',
            value: product.year?.toString() ?? '',
          ),
          _InfoRow(
            title: 'Состояние Спецтехники:',
            value: product.isNewState == true ? 'Новый' : 'Б/У',
          ),

          const SizedBox(height: 20),

          // Seller Section
          _SectionHeader(title: 'О Продавце'),
          _InfoRow(title: 'ФИО:', value: product.contact ?? ''),
          _InfoRow(title: 'Область:', value: region?.name ?? ''),
          _InfoRow(title: 'Населенный Пункт:', value: city),
          _InfoRow(
            title: 'Контактное Лицо/Компания:',
            value: product.contact ?? '',
          ),

          const SizedBox(height: 20),

          // Price Section
          _SectionHeader(title: 'Стоимость'),
          _InfoRow(
            title: 'Общая Стоимость:',
            value: '${_formatPrice(product.price)} ₸',
          ),
          const SizedBox(height: 20),

          // Additional Info
          _SectionHeader(title: 'Доп. Информация'),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text(
              'fdsifjdsfjdshfjsdhjkhdjhfdjsfhjkhfsjkhsdjfhjdkshdfsjkhjkfshfjkdshjfhsdjfdhsjfhsdjfdhsjhfdsjkfhsdjkfhdjskhfjsdhfj\nfhbdsfjnhdshfbdsjkfdshfjkdshfjsdhfjdsh\nfgdf\n\nfn\n',
              style: TextStyle(fontSize: 16, color: theme.colors.black),
            ),
          ),
          SizedBox(height: 80),
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
                '${_formatPrice(product.price)} ₸/${product.type_price == true ? 'кг' : 'шт'}',
          ),
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
          _InfoRow(title: 'Компания:', value: product.contact ?? ''),
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
            value: '${_formatPrice(product.price)} ₸',
          ),
          _InfoRow(
            title: 'Максимальная цена:',
            value:
                '${(_formatPrice(product.maxPrice) ?? "Уточните у компаний")} ₸',
          ),
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: theme.colors.black,
        ),
      ),
    );
  }
}

// Information row with styled container
class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: theme.colors.gray,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: theme.colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPrice(num? price) {
  if (price == null) return "Уточните у компаний";
  return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')}';
}
