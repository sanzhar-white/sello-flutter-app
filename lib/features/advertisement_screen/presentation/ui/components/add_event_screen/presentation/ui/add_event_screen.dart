import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/calendar.dart';
import 'package:sello/components/product_card.dart';
import 'package:sello/components/show_modal_bottom_sheet_wrap.dart';
import 'package:sello/components/show_top_snack_bar.dart';
import 'package:sello/components/text_field_fidget.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/constants.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/core/extensions.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/image_placeholder.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/preview_screen.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/time_picker.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/register_screen.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:sello/features/horse_screen/presentation/ui/components/product_detail_screen/presentation/ui/product_detail_screen.dart';
import 'package:sello/generated/l10n.dart';
// import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  final ProductType? productType;
  final bool product;
  final bool hors;

  const AddEventScreen({
    super.key,
    this.product = false,
    required this.productType,
    this.hors = false,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController prizeFoundController;
  late TextEditingController descriptionController;
  late TextEditingController stateController;

  final id = generateId();

  final GlobalKey<FormState> _formKey = GlobalKey();

  List<XFile> images = [];

  Category? region;

  Category? city;

  DateTime dateTime = DateTime.now();

  bool canAgree = false;

  ProductDto? productDto;

  Category? productState;

  Category? category;

  Category? subCategory;

  @override
  void initState() {
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    prizeFoundController = TextEditingController();
    descriptionController = TextEditingController();
    stateController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    prizeFoundController.dispose();
    descriptionController.dispose();
    stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>().userData;
    double width = MediaQuery.of(context).size.width;

    final style = TextStyle(fontSize: 16, color: theme.colors.colorText2);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).newAd)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                HintText(text: S.of(context).addPhoto),
                const SizedBox(height: 8),
                SizedBox(
                  height: 95,
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: width * 0.03,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...List.generate(
                        images.length,
                        (index) => ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: Image.file(
                            File(images[index].path),
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ...List.generate(
                        4 - images.length,
                        (index) => ImagePlaceholder(
                          onTap: () async {
                            final picture = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );

                            if (picture != null) {
                              images.add(picture);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                HintText(text: S.of(context).adName),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: titleController,
                  style: style,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                HintText(text: S.of(context).shortDescription),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: subtitleController,
                  style: style,
                  keyboardType: TextInputType.text,
                ),
                if (widget.product) ...[
                  const SizedBox(height: 20),
                  HintText(text: S.of(context).category),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    style: style,
                    readOnly: true,
                    hintColor: theme.colors.colorText2,
                    validator: (value) {
                      return null;
                    },
                    hintText: category?.name ?? S.of(context).selectCategories,
                    onTap: () async {
                      subCategory = null;
                      await showModalBottomSheetWrap(
                        context: context,
                        child: _SelectCategory(
                          horse: widget.hors,
                          productCategory: widget.product && !widget.hors,
                          kokparEventCategory: !widget.product,
                          changeCategory: (value) {
                            category = value;
                          },
                        ),
                      );
                      setState(() {});
                    },
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colors.colorText3,
                    ),
                  ),
                ],
                if (widget.product && !widget.hors) ...[
                  const SizedBox(height: 20),
                  const HintText(text: 'Подкатегория'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    style: style,
                    readOnly: true,
                    hintColor: theme.colors.colorText2,
                    validator: (value) {
                      return null;
                    },
                    hintText:
                        subCategory?.name ?? S.of(context).selectSubCategories,
                    onTap: () async {
                      if (category == null) {
                        showTopSnackBar(
                          context: context,
                          title: S.of(context).selectCategories,
                        );
                        return;
                      }
                      await showModalBottomSheetWrap(
                        context: context,
                        child: _SelectCategory(
                          subCategories: category!.subCategories,
                          changeCategory: (value) {
                            subCategory = value;
                          },
                        ),
                      );
                      setState(() {});
                    },
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colors.colorText3,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                HintText(
                  text:
                      widget.product
                          ? '${S.of(context).price} (тг.)'
                          : '${S.of(context).prizeFund} (тг.)',
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  style: style,
                  controller: prizeFoundController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [MoneyTextInputFormatter()],
                ),
                if (widget.product && !widget.hors) ...[
                  const SizedBox(height: 20),
                  HintText(text: S.of(context).condition),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    style: style,
                    readOnly: true,
                    hintColor: theme.colors.colorText2,
                    validator: (value) {
                      return null;
                    },
                    hintText: productState?.name ?? S.of(context).condition,
                    onTap: () async {
                      await showModalBottomSheetWrap(
                        context: context,
                        child: _SelectCategory(
                          state: true,
                          changeCategory: (value) {
                            productState = value;
                          },
                        ),
                      );
                      setState(() {});
                    },
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colors.colorText3,
                    ),
                  ),
                ],
                if (widget.product) ...[
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    style: style,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    hintText: S.of(context).negotiable,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: SizedBox(
                      width: 10,
                      height: 10,
                      child: Icon(
                        canAgree
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: theme.colors.primary,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        canAgree = !canAgree;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 20),
                HintText(text: S.of(context).description),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: descriptionController,
                  minLines: 3,
                  style: style,
                  keyboardType: TextInputType.text,
                ),
                if (!widget.product) ...[
                  const SizedBox(height: 20),
                  HintText(text: S.of(context).eventDate),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    hintColor: theme.colors.colorText2,
                    readOnly: true,
                    hintText: dateFormatYMMMd(dateTime),
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: SizedBox(
                      width: 10,
                      height: 10,
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: theme.colors.colorText3.withOpacity(0.7),
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheetWrap(
                        context: context,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: CalendarWidget(
                            calendarFormat: CalendarFormat.month,
                            headerVisible: true,
                            currentDay: DateTime.now(),
                            chosenDayCallBack: (value) {
                              setState(() {
                                dateTime = value;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const HintText(text: 'Время проведения'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    hintText: dateFormatHMd(dateTime),
                    hintColor: theme.colors.colorText2,
                    readOnly: true,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: Icon(
                      Icons.alarm,
                      color: theme.colors.colorText3.withOpacity(0.7),
                    ),
                    onTap: () async {
                      await showModalBottomSheetWrap(
                        context: context,
                        child: ShowBottomSheetTimePicker(
                          onDateTimeChanged: (DateTime date) {
                            dateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              date.hour,
                              date.minute,
                            );
                          },
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ],
                const SizedBox(height: 20),
                HintText(
                  text:
                      widget.product
                          ? S.of(context).settlement
                          : S.of(context).eventLocation,
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  style: style,
                  hintText: region?.name ?? S.of(context).region,
                  readOnly: true,
                  hintColor: theme.colors.colorText2,
                  validator: (value) {
                    return null;
                  },
                  onTap: () async {
                    city = null;
                    await showModalBottomSheetWrap(
                      context: context,
                      child: SelectRegion(
                        onChangedRegion: (value) {
                          region = value;
                        },
                        regions: kzRegions,
                      ),
                    );
                    setState(() {});
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colors.colorText3,
                  ),
                ),
                const SizedBox(height: 12),
                TextFieldWidget(
                  hintText: city?.name ?? S.of(context).settlement,
                  style: style,
                  readOnly: true,
                  validator: (value) {
                    return null;
                  },
                  hintColor: theme.colors.colorText2,
                  onTap: () {
                    if (region == null) {
                      showTopSnackBar(
                        context: context,
                        title: 'Выберите пожалуйста область',
                      );
                      return;
                    }
                    showModalBottomSheetWrap(
                      context: context,
                      child: SelectRegion(
                        onChangedCity: (value) {
                          city = value;
                          setState(() {});
                        },
                        cities: region!.subCategories,
                      ),
                    );
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colors.colorText3,
                  ),
                ),
                const SizedBox(height: 30),
                BigButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    if (images.isEmpty) {
                      showTopSnackBar(context: context, title: 'Выберите фото');
                      return;
                    }
                    if (!_formKey.currentState!.validate() ||
                        city == null ||
                        region == null) {
                      if (widget.product && widget.hors && category == null) {
                        showTopSnackBar(
                          context: context,
                          title: 'Необходимо заполнить все пол',
                        );
                        return;
                      } else {
                        showTopSnackBar(
                          context: context,
                          title: 'Необходимо заполнить все поля',
                        );
                        return;
                      }
                    }

                    final event = KokparEventDto(
                      id: id.toString(),
                      title: titleController.text.trim(),
                      authorPhoneNumber: authProvider!.phoneNumber,
                      subTitle: subtitleController.text.trim(),
                      city: city?.id ?? '',
                      date: dateTime.toString(),
                      region: region?.id ?? "",
                      prizeFund: prizeFoundController.text.trim().toDouble(),
                      description: descriptionController.text.trim(),
                      isFavorite: false,
                      category: category?.id ?? '',
                      images: [],
                    );

                    if (widget.product) {
                      productDto = ProductDto(
                        id: id.toString(),
                        title: titleController.text.trim(),
                        authorPhoneNumber: authProvider.phoneNumber,
                        subTitle: subtitleController.text.trim(),
                        city: city?.id ?? '',
                        createdDate: dateTime.toString(),
                        region: region?.id ?? "",
                        price: prizeFoundController.text.trim().toDouble(),
                        description: descriptionController.text.trim(),
                        isFavorite: false,
                        categoryId: category?.id ?? '',
                        subCategoryId: subCategory?.id ?? '',
                        images: [],
                        canAgree: canAgree,
                        state: productState?.id ?? '',
                      );
                    }

                    widget.product
                        ? navigateTo(
                          context: context,
                          fullScreenDialog: true,
                          rootNavigator: true,
                          screen: ProductDetailScreen(
                            product: productDto!,
                            images: images,
                          ),
                        )
                        : navigateTo(
                          context: context,
                          fullScreenDialog: true,
                          rootNavigator: true,
                          screen: PreviewScreen(
                            kokparEventDto: event,
                            images: images,
                          ),
                        );
                  },
                  label: S.of(context).preview,
                  isActive: false,
                ),
                const SizedBox(height: 12),
                BlocConsumer<AdvertisementScreenBloc, AdvertisementScreenState>(
                  listener: (context, state) async {
                    if (state is AdvertisementScreenError) {
                      showTopSnackBar(
                        context: context,
                        title: 'Произошла ошибка',
                        message: state.errorMassage,
                      );
                    }
                    if (state is AdvertisementScreenSuccess) {
                      context.read<HomeScreenBloc>().add(
                        GetAllProducts(phoneNumber: authProvider!.phoneNumber),
                      );
                      showTopSnackBar(
                        context: context,
                        title: 'Мероприятие успешно создан',
                        titleColor: theme.colors.green,
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
                      onPressed: () {
                        if (images.isEmpty) {
                          showTopSnackBar(
                            context: context,
                            title: 'Выберите фото',
                          );
                          return;
                        }
                        if (!_formKey.currentState!.validate() ||
                            city == null ||
                            region == null) {
                          if (widget.product &&
                              widget.hors &&
                              category == null) {
                            showTopSnackBar(
                              context: context,
                              title: 'Необходимо заполнить все пол',
                            );
                            return;
                          } else {
                            showTopSnackBar(
                              context: context,
                              title: 'Необходимо заполнить все поля',
                            );
                            return;
                          }
                        }
                        final event = KokparEventDto(
                          id: id.toString(),
                          title: titleController.text.trim(),
                          authorPhoneNumber: authProvider!.phoneNumber,
                          subTitle: subtitleController.text.trim(),
                          city: city?.id ?? '',
                          date: dateTime.toString(),
                          region: region?.id ?? "",
                          prizeFund:
                              prizeFoundController.text.trim().toDouble(),
                          description: descriptionController.text.trim(),
                          isFavorite: false,
                          category: category?.id ?? '',
                          images: [],
                        );

                        if (widget.product) {
                          productDto = ProductDto(
                            id: id.toString(),
                            title: titleController.text.trim(),
                            authorPhoneNumber: authProvider.phoneNumber,
                            subTitle: subtitleController.text.trim(),
                            city: city?.id ?? '',
                            createdDate: dateTime.toString(),
                            region: region?.id ?? "",
                            price: prizeFoundController.text.trim().toDouble(),
                            description: descriptionController.text.trim(),
                            isFavorite: false,
                            categoryId: category?.id ?? '',
                            subCategoryId: subCategory?.id ?? '',
                            images: [],
                            canAgree: canAgree,
                            state: productState?.id ?? '',
                          );
                        }

                        widget.product
                            ? context.read<AdvertisementScreenBloc>().add(
                              AddAdvert(
                                images: images,
                                product: productDto!,
                                userPhoneNumber: authProvider.phoneNumber,
                                productType: widget.productType!,
                              ),
                            )
                            : context.read<AdvertisementScreenBloc>().add(
                              AddAdvert(
                                images: images,
                                product: productDto!,
                                userPhoneNumber: authProvider.phoneNumber,
                                productType: widget.productType!,
                              ),
                            );
                      },
                      label: S.of(context).publish,
                    );
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectCategory extends StatelessWidget {
  final Function(Category) changeCategory;
  final List<Category>? subCategories;
  final bool kokparEventCategory;
  final bool state;
  final bool productCategory;
  final bool horse;

  const _SelectCategory({
    required this.changeCategory,
    this.subCategories,
    this.kokparEventCategory = false,
    this.state = false,
    this.productCategory = false,
    this.horse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (subCategories != null)
          ...subCategories!.map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        if (productCategory)
          ...productCategories(context).map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        if (kokparEventCategory)
          ...kokparEventCategories(context).map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        if (state)
          ...productState.map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        if (horse)
          ...horseCategories.map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ChangeCategory extends StatelessWidget {
  final Function(Category) changeCategory;
  final Category category;

  const _ChangeCategory({required this.changeCategory, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final style = TextStyle(
      color: theme.colors.colorText2,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    return GestureDetector(
      onTap: () {
        changeCategory(category);
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          Text(category.name, style: style),
          Divider(color: theme.colors.colorText3, height: 24),
        ],
      ),
    );
  }
}
