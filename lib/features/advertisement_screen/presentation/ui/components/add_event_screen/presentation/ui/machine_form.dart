import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/components/big_button.dart';
import 'package:selo/components/show_modal_bottom_sheet_wrap.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/text_field_fidget.dart';
import 'package:selo/components/product_detail_screen.dart';
import 'package:selo/core/extensions.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/advertisement_screen/data/models/categories.dart';
import 'package:selo/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/image_placeholder.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/register_screen.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/generated/l10n.dart';

class MachineForm extends StatefulWidget {
  ThemeData theme;
  dynamic authProvider;
  double width;
  TextStyle style;
  GlobalKey<FormState> formKey;
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController amountController;
  TextEditingController priceController;
  TextEditingController contactFace;
  TextEditingController phoneNumber;
  TextEditingController yearController;
  List<XFile> images;
  Category? region;
  Category? city;
  bool isKilogrammAmount;
  Function(bool) onKilogrammAmountChanged;
  Function(Category) onRegionChanged;
  Function(Category) onCityChanged;
  Function(XFile) onImageAdded;
  VoidCallback onPreviewPressed;
  VoidCallback onPublishPressed;
  ProductDto? productDto;
  ProductType? productType;

  bool isNewState;
  bool isMachine;

  MachineForm({
    super.key,
    required this.theme,
    required this.authProvider,
    required this.width,
    required this.style,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.amountController,
    required this.priceController,
    required this.contactFace,
    required this.phoneNumber,
    required this.yearController,
    required this.images,
    required this.region,
    required this.city,
    required this.isMachine,
    required this.isNewState,
    required this.isKilogrammAmount,
    required this.onKilogrammAmountChanged,
    required this.onRegionChanged,
    required this.onCityChanged,
    required this.onImageAdded,
    required this.onPreviewPressed,
    required this.onPublishPressed,
    this.productDto,
    this.productType,
  });

  @override
  State<MachineForm> createState() => _MachineFormState();
}

class _MachineFormState extends State<MachineForm> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
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
                  'Заполните все необходимые\nполя информаций машины',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                width: double.infinity,
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: theme.colors.backgroundWidget,
                  borderRadius: BorderRadius.circular(1),
                  image: DecorationImage(
                    image: AssetImage('assets/to_add/machine.png'),
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: theme.colors.backgroundWidget,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.isMachine = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color:
                                    widget.isMachine
                                        ? theme.colors.green
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      widget.isMachine
                                          ? theme.colors.green
                                          : theme.colors.backgroundWidget,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Спецтехника',
                                  style: TextStyle(
                                    color:
                                        widget.isMachine
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.isMachine = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color:
                                    !widget.isMachine
                                        ? theme.colors.green
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      !widget.isMachine
                                          ? theme.colors.green
                                          : theme.colors.backgroundWidget,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Запчасти',
                                  style: TextStyle(
                                    color:
                                        !widget.isMachine
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  _FormField(
                    title: 'Название Объявления',
                    child: TextFieldWidget(
                      controller: widget.titleController,
                      style: widget.style,
                      keyboardType: TextInputType.text,
                      hintText: 'Пример: Трактор МТЗ-82',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите название объявления';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Год Выпуска',
                    child: TextFieldWidget(
                      controller: widget.yearController,
                      style: widget.style,
                      keyboardType: TextInputType.number,
                      hintText: 'Введите дату',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите дату';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Введите корректную дату';
                        }
                        return null;
                      },
                    ),
                  ),
                  _FormField(
                    title: 'Состояние Спецтехники',
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: theme.colors.backgroundWidget,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isNewState = true;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color:
                                      widget.isNewState
                                          ? theme.colors.green
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        widget.isNewState
                                            ? theme.colors.green
                                            : theme.colors.backgroundWidget,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Новый',
                                    style: TextStyle(
                                      color:
                                          widget.isNewState
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isNewState = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color:
                                      !widget.isNewState
                                          ? theme.colors.green
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        !widget.isNewState
                                            ? theme.colors.green
                                            : theme.colors.backgroundWidget,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Б/У',
                                    style: TextStyle(
                                      color:
                                          !widget.isNewState
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _FormField(
                    title: 'Цена',
                    child: TextFieldWidget(
                      controller: widget.priceController,
                      style: widget.style,
                      keyboardType: TextInputType.number,
                      hintText: 'Введите цену',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите цену';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Введите корректную цену';
                        }
                        return null;
                      },
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
                    title: 'Описание',
                    child: TextFieldWidget(
                      controller: widget.descriptionController,
                      style: widget.style,
                      keyboardType: TextInputType.text,
                      hintText: 'Пример: Трактор МТЗ-82',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите описание';
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
                    padding: EdgeInsets.all(0),
                    onPressed: widget.onPreviewPressed,
                    label: S.of(context).preview,
                    isActive: false,
                  ),
                  SizedBox(height: 12),
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
                        await Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is AdvertisementScreenLoading) {
                        return Stack(
                          children: [
                            BigButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              label: "",
                            ),
                            Positioned.fill(
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
                        padding: EdgeInsets.all(0),
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

  Future<void> _onPublishPressed() async {
    if (widget.images.isEmpty) {
      showTopSnackBar(context: context, title: 'Выберите фото');
      return;
    }

    if (!widget.formKey.currentState!.validate()) {
      showTopSnackBar(
        context: context,
        title: 'Проверьте правильность заполнения полей',
      );
      return;
    }

    try {
      for (var i = 0; i < 3; i++) {
        // Максимум 3 попытки
        try {
          await Future.delayed(
            Duration(seconds: i * 2),
          ); // Экспоненциальная задержка
          context.read<AdvertisementScreenBloc>().add(
            AddAdvert(
              images: widget.images,
              product: widget.productDto!,
              userPhoneNumber:
                  widget.phoneNumber.text.isEmpty
                      ? widget.authProvider.phoneNumber
                      : widget.phoneNumber.text,
              productType: widget.productType!,
            ),
          );
          break; // Если успешно, выходим из цикла
        } catch (e) {
          if (i == 2)
            throw e; // Если все попытки исчерпаны, пробрасываем ошибку
        }
      }
    } catch (e) {
      showTopSnackBar(
        context: context,
        title: 'Ошибка при загрузке',
        message: e.toString(),
      );
    }
  }
}

class _FormField extends StatelessWidget {
  String title;
  Widget child;
  double spacing;
  Function(String?)? validator;

  _FormField({
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
  List<XFile> images;
  Function(XFile) onImageAdded;
  double width;

  _ImageGrid({
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
        physics: NeverScrollableScrollPhysics(),
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
                var picture = await ImagePicker().pickImage(
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
  XFile image;
  bool isMain;

  _ImagePreview({required this.image, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
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
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: theme.colors.backgroundWidget,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
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
