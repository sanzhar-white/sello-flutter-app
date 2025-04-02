import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/components/big_button.dart';
import 'package:selo/components/show_modal_bottom_sheet_wrap.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/text_field_fidget.dart';
import 'package:selo/core/extensions.dart';
import 'package:selo/features/advertisement_screen/data/models/categories.dart';
import 'package:selo/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/image_placeholder.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/register_screen.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/generated/l10n.dart';

class JobForm extends StatefulWidget {
  final ThemeData theme;
  final dynamic authProvider;
  final double width;
  final TextStyle style;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController maxPriceController;
  final TextEditingController nameCompany;
  final TextEditingController contactFace;
  final TextEditingController phoneNumber;
  final List<XFile> images;
  final Category? region;
  final Category? city;
  final Function(Category) onRegionChanged;
  final Function(Category) onCityChanged;
  final Function(XFile) onImageAdded;
  final VoidCallback onPreviewPressed;
  final VoidCallback onPublishPressed;

  const JobForm({
    super.key,
    required this.theme,
    required this.authProvider,
    required this.width,
    required this.style,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.maxPriceController,
    required this.nameCompany,
    required this.contactFace,
    required this.phoneNumber,
    required this.images,
    required this.region,
    required this.city,
    required this.onRegionChanged,
    required this.onCityChanged,
    required this.onImageAdded,
    required this.onPreviewPressed,
    required this.onPublishPressed,
  });

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).newAd)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              Container(
                child: Text(
                  'Заполните все необходимые\nполя информаций работы',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                width: double.infinity,
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  image: DecorationImage(
                    image: AssetImage('assets/to_add/job.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                height: 70,
                width: double.infinity,
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormField(
                    title: 'Название Объявления',
                    child: TextFieldWidget(
                      controller: widget.titleController,
                      style: widget.style,
                      keyboardType: TextInputType.text,
                      hintText: 'Пример: Услуги трактора',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите название объявления';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Описание',
                    child: TextFieldWidget(
                      controller: widget.descriptionController,
                      style: widget.style,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 10,
                      hintText:
                          'Тип Занятости\nТребования\nОбязанности\nУсловия Работы',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите описание услуги';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Зарплата',
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                            hintText: 'ОТ',
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.center,
                                          controller: widget.maxPriceController,
                                          style: widget.style,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Введите максимальную цену';
                                            }
                                            if (double.tryParse(value) ==
                                                null) {
                                              return 'Введите корректную цену';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 50,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Т',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                            hintText: 'ДО',
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.center,
                                          controller: widget.priceController,
                                          style: widget.style,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Введите минимальную цену';
                                            }
                                            if (double.tryParse(value) ==
                                                null) {
                                              return 'Введите корректную цену';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 50,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Т',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FormField(
                    title: 'Местоположение',
                    child: TextFieldWidget(
                      style: widget.style,
                      hintText: widget.region?.name ?? S.of(context).region,
                      readOnly: true,
                      hintColor: widget.theme.colorScheme.onSurface,
                      validator: (value) {
                        if (widget.region == null) {
                          return 'Выберите область';
                        }
                        return null;
                      },
                      onTap: () async {
                        await showModalBottomSheetWrap(
                          context: context,
                          child: SelectRegion(
                            onChangedRegion: widget.onRegionChanged,
                            regions: kzRegions,
                          ),
                        );
                      },
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _FormField(
                    title: 'Населенный пункт',
                    child: TextFieldWidget(
                      hintText: widget.city?.name ?? S.of(context).settlement,
                      style: widget.style,
                      readOnly: true,
                      hintColor: widget.theme.colorScheme.onSurface,
                      validator: (value) {
                        if (widget.city == null) {
                          return 'Выберите населенный пункт';
                        }
                        return null;
                      },
                      onTap: () {
                        if (widget.region == null) {
                          showTopSnackBar(
                            context: context,
                            title: 'Выберите пожалуйста область',
                          );
                          return;
                        }
                        showModalBottomSheetWrap(
                          context: context,
                          child: SelectRegion(
                            onChangedCity: widget.onCityChanged,
                            cities: widget.region!.subCategories,
                          ),
                        );
                      },
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _FormField(
                    title: 'Название компании',
                    child: TextFieldWidget(
                      controller: widget.nameCompany,
                      style: widget.style,
                      keyboardType: TextInputType.text,
                      hintText: 'Введите название компании',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите название компании';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Контактное лицо',
                    child: TextFieldWidget(
                      controller: widget.contactFace,
                      style: widget.style,
                      keyboardType: TextInputType.text,
                      hintText: 'Введите имя контактного лица',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите имя контактного лица';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Номер телефона',
                    child: TextFieldWidget(
                      controller: widget.phoneNumber,
                      style: widget.style,
                      keyboardType: TextInputType.phone,
                      hintText: '+7 700000000',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        if (value.length < 10) {
                          return 'Введите корректный номер телефона';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Фотографии',
                    child: _ImageGrid(
                      images: widget.images,
                      onImageAdded: widget.onImageAdded,
                      width: widget.width,
                    ),
                  ),
                  BigButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: widget.onPreviewPressed,
                    label: S.of(context).preview,
                    isActive: false,
                  ),
                  const SizedBox(height: 12),
                  BlocConsumer<
                    AdvertisementScreenBloc,
                    AdvertisementScreenState
                  >(
                    listener: (context, state) async {
                      if (state is AdvertisementScreenError) {
                        showTopSnackBar(
                          context: context,
                          title: 'Произошла ошибка',
                          message: state.errorMassage,
                        );
                      }
                      if (state is AdvertisementScreenSuccess) {
                        showTopSnackBar(
                          context: context,
                          title: 'Объявление успешно создано',
                          titleColor: widget.theme.colorScheme.secondary,
                        );
                        await Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is AdvertisementScreenLoading) {
                        return Stack(
                          children: [
                            BigButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              label: "",
                            ),
                            const Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return BigButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: widget.onPublishPressed,
                        label: S.of(context).publish,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String title;
  final Widget child;
  final double spacing;
  final Function(String?)? validator;

  const _FormField({
    required this.child,
    this.title = "",
    this.spacing = 15,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: spacing),
          child,
          SizedBox(height: spacing),
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<XFile> images;
  final Function(XFile) onImageAdded;
  final double width;

  const _ImageGrid({
    required this.images,
    required this.onImageAdded,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: width * 0.03,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (images.isNotEmpty)
            ...List.generate(
              images.length,
              (index) =>
                  _ImagePreview(image: images[index], isMain: index == 0),
            ),
          ...List.generate(
            4 - (images.length),
            (index) => ImagePlaceholder(
              onTap: () async {
                final picture = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picture != null) {
                  onImageAdded(picture);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final XFile image;
  final bool isMain;

  const _ImagePreview({required this.image, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Image.file(
            File(image.path),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        if (isMain)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Text(
                "Главное фото",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
