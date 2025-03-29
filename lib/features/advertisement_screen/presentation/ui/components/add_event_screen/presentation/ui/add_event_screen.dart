import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/calendar.dart';
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
import 'package:sello/core/theme/app_theme_provider.dart';
import 'package:sello/core/utils/date_formatter.dart';
import 'package:sello/core/utils/navigation.dart';
import 'package:sello/core/widgets/big_button.dart';
import 'package:sello/core/widgets/hint_text.dart';
import 'package:sello/core/widgets/image_placeholder.dart';
import 'package:sello/core/widgets/show_bottom_sheet_time_picker.dart';
import 'package:sello/core/widgets/show_modal_bottom_sheet_wrap.dart';
import 'package:sello/core/widgets/text_field_widget.dart';
import 'package:sello/features/advertisement_screen/data/models/categories.dart'
    as adv_categories;
import 'package:sello/features/advertisement_screen/data/models/product_dto.dart'
    as adv_product;
import 'package:sello/features/advertisement_screen/data/models/product_type.dart'
    as adv_type;
import 'package:sello/features/advertisement_screen/presentation/bloc/advertisement_screen_bloc.dart'
    as adv_bloc;
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/bloc/add_event_screen_bloc.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/calendar_widget.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/preview_screen.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/product_detail_screen.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/select_region.dart';
import 'package:sello/features/home_screen/presentation/bloc/home_screen_bloc.dart';
import 'package:sello/features/home_screen/presentation/bloc/home_screen_event.dart';
import 'package:sello/features/my_auth/presentation/bloc/my_auth_provider.dart';
import 'package:sello/features/my_auth/presentation/bloc/my_auth_state.dart';
import 'package:sello/utils/constants.dart';
import 'package:sello/utils/money_text_input_formatter.dart';
import 'package:sello/utils/show_top_snack_bar.dart';
import 'package:sello/utils/uuid.dart';
// import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  final adv_type.ProductType? productType;

  const AddEventScreen({super.key, required this.productType});

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

  adv_categories.Category? region;

  adv_categories.Category? city;

  DateTime dateTime = DateTime.now();

  bool canAgree = false;

  adv_product.ProductDto? productDto;

  adv_categories.Category? productState;

  adv_categories.Category? category;

  adv_categories.Category? subCategory;

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
                        productType: widget.productType,
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
                const SizedBox(height: 20),
                HintText(text: '${S.of(context).price} (тг.)'),
                const SizedBox(height: 8),
                TextFieldWidget(
                  style: style,
                  controller: prizeFoundController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [MoneyTextInputFormatter()],
                ),
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
                const SizedBox(height: 20),
                HintText(text: S.of(context).description),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: descriptionController,
                  minLines: 3,
                  style: style,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                HintText(text: S.of(context).settlement),
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
                        region == null ||
                        category == null ||
                        subCategory == null ||
                        productState == null) {
                      showTopSnackBar(
                        context: context,
                        title: 'Необходимо заполнить все поля',
                      );
                      return;
                    }

                    productDto = adv_product.ProductDto(
                      id: id.toString(),
                      title: titleController.text.trim(),
                      authorPhoneNumber: authProvider!.phoneNumber,
                      subTitle: subtitleController.text.trim(),
                      city: city?.id ?? '',
                      createdDate: DateTime.now().toString(),
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

                    navigateTo(
                      context: context,
                      fullScreenDialog: true,
                      rootNavigator: true,
                      screen: ProductDetailScreen(
                        product: productDto!,
                        images: images,
                      ),
                    );
                  },
                  label: S.of(context).preview,
                  isActive: false,
                ),
                const SizedBox(height: 12),
                BlocConsumer<
                  adv_bloc.AdvertisementScreenBloc,
                  adv_bloc.AdvertisementScreenState
                >(
                  listener: (context, state) async {
                    if (state is adv_bloc.AdvertisementScreenError) {
                      showTopSnackBar(
                        context: context,
                        title: 'Произошла ошибка',
                        message: state.errorMassage,
                      );
                    }
                    if (state is adv_bloc.AdvertisementScreenSuccess) {
                      context.read<HomeScreenBloc>().add(
                        GetAllKokparEvents(
                          phoneNumber: authProvider!.phoneNumber,
                        ),
                      );
                      showTopSnackBar(
                        context: context,
                        title: 'Объявление успешно создано',
                        titleColor: theme.colors.green,
                      );

                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is adv_bloc.AdvertisementScreenLoading) {
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
                            region == null ||
                            category == null ||
                            subCategory == null ||
                            productState == null) {
                          showTopSnackBar(
                            context: context,
                            title: 'Необходимо заполнить все поля',
                          );
                          return;
                        }

                        productDto = adv_product.ProductDto(
                          id: id.toString(),
                          title: titleController.text.trim(),
                          authorPhoneNumber: authProvider!.phoneNumber,
                          subTitle: subtitleController.text.trim(),
                          city: city?.id ?? '',
                          createdDate: DateTime.now().toString(),
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

                        context.read<adv_bloc.AdvertisementScreenBloc>().add(
                          adv_bloc.AddAdvert(
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
  final Function(adv_categories.Category) changeCategory;
  final List<adv_categories.Category>? subCategories;
  final bool state;
  final adv_type.ProductType? productType;

  const _SelectCategory({
    required this.changeCategory,
    this.subCategories,
    this.state = false,
    this.productType,
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
        if (state)
          ...adv_categories.productState.map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        if (productType != null)
          ..._getCategoriesForProductType(productType!).map(
            (e) => _ChangeCategory(category: e, changeCategory: changeCategory),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<adv_categories.Category> _getCategoriesForProductType(
    adv_type.ProductType type,
  ) {
    switch (type) {
      case adv_type.ProductType.machine:
        return adv_categories.machineCategories;
      case adv_type.ProductType.raw_material:
        return adv_categories.rawMaterialCategories;
      case adv_type.ProductType.work:
        return adv_categories.workCategories;
      case adv_type.ProductType.fertiliser:
        return adv_categories.fertiliserCategories;
      default:
        return [];
    }
  }
}

class _ChangeCategory extends StatelessWidget {
  final Function(adv_categories.Category) changeCategory;
  final adv_categories.Category category;

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
