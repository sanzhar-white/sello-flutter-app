import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/product_detail_screen.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/core/extensions.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/advertisement_screen/data/models/categories.dart';
import 'package:selo/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/components/image_placeholder.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'job_form.dart';
import 'machine_form.dart';
import 'material_form.dart';
import 'package:selo/generated/l10n.dart';
// import 'package:uuid/uuid.dart';

// Константы для стилей

// Константы для отступов
const EdgeInsets kScreenPadding = EdgeInsets.symmetric(horizontal: 30.0);
const EdgeInsets kFormPadding = EdgeInsets.all(20.0);

class CreateAdvertisementScreen extends StatefulWidget {
  final ProductType? productType;

  const CreateAdvertisementScreen({super.key, required this.productType});

  @override
  State<CreateAdvertisementScreen> createState() =>
      _CreateAdvertisementScreenState();
}

class _CreateAdvertisementScreenState extends State<CreateAdvertisementScreen> {
  // Контроллеры для полей ввода
  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController stateController;
  late final TextEditingController contactFace;
  late final TextEditingController phoneNumber;
  late final TextEditingController amountController;
  late final TextEditingController maxPriceController;
  late final TextEditingController nameCompany;
  late final TextEditingController yearController;

  // Идентификатор объявления
  final int id = generateId();

  // Ключ для валидации формы
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Состояние формы
  List<XFile> images = [];
  Category? region;
  Category? city;
  DateTime dateTime = DateTime.now();
  bool canAgree = false;
  bool isNewState = true;
  bool isKilogrammAmount = true;
  bool isKilogrammPrice = true;
  bool isHerbicide = false;
  bool isMachine = true;
  ProductDto? productDto;
  Category? productState;
  Category? category;
  Category? subCategory;

  @override
  void initState() {
    _initializeControllers();
    super.initState();
  }

  void _initializeControllers() {
    titleController = TextEditingController();

    priceController = TextEditingController();
    priceController.addListener(() {
      final text = priceController.text;
      if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
        priceController.text = text.replaceAll(RegExp(r'[^\d]'), '');
        priceController.selection = TextSelection.fromPosition(
          TextPosition(offset: priceController.text.length),
        );
      }
    });

    amountController = TextEditingController();
    amountController.addListener(() {
      final text = amountController.text;
      if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
        amountController.text = text.replaceAll(RegExp(r'[^\d]'), '');
        amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: amountController.text.length),
        );
      }
    });

    phoneNumber = TextEditingController();
    phoneNumber.addListener(() {
      final text = phoneNumber.text;
      if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
        phoneNumber.text = text.replaceAll(RegExp(r'[^\d]'), '');
        phoneNumber.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumber.text.length),
        );
      }
    });

    maxPriceController = TextEditingController();
    maxPriceController.addListener(() {
      final text = maxPriceController.text;
      if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
        maxPriceController.text = text.replaceAll(RegExp(r'[^\d]'), '');
        maxPriceController.selection = TextSelection.fromPosition(
          TextPosition(offset: maxPriceController.text.length),
        );
      }
    });

    descriptionController = TextEditingController();
    stateController = TextEditingController();
    contactFace = TextEditingController();
    nameCompany = TextEditingController();
    yearController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    titleController.dispose();
    priceController.dispose();
    contactFace.dispose();
    descriptionController.dispose();
    stateController.dispose();
    phoneNumber.dispose();
    amountController.dispose();
    maxPriceController.dispose();
    nameCompany.dispose();
    yearController.dispose();
  }

  bool _validateForm(List<String?> checkList) {
    bool hasEmptyField = checkList.any(
      (field) => field?.trim().isEmpty ?? true,
    );

    if (hasEmptyField ||
        region == null ||
        city == null ||
        !_formKey.currentState!.validate()) {
      showTopSnackBar(context: context, title: 'Необходимо заполнить все поля');
      return false;
    }
    return true;
  }

  ProductDto _createProductDto(dynamic authProvider) {
    final baseDto = ProductDto(
      productType: widget.productType ?? ProductType.machine,
      id: id.toString(),
      title: titleController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0.0,
      city: city?.id ?? '',
      createdDate: DateTime.now().toString(),
      region: region?.id ?? "",
      contact: contactFace.text.trim(),
      authorPhoneNumber:
          phoneNumber.text.isEmpty
              ? authProvider!.phoneNumber
              : phoneNumber.text,
      isFavorite: false,
      images: [],
      canAgree: canAgree,
      description: descriptionController.text.trim(),
    );

    switch (widget.productType) {
      case ProductType.machine:
        return baseDto.copyWith(
          year: int.tryParse(yearController.text.trim()) ?? 0,
          isNewState: isNewState,
          isMachine: isMachine,
          type_price: isKilogrammPrice,
          type_amount: isKilogrammAmount,
          amount: int.tryParse(amountController.text.trim()) ?? 0,
        );
      case ProductType.fertiliser:
        return baseDto.copyWith(
          type_price: isKilogrammPrice,
          type_amount: isKilogrammAmount,
          amount: int.tryParse(amountController.text.trim()) ?? 0,
        );
      case ProductType.raw_material:
        return baseDto.copyWith(
          type_price: isKilogrammPrice,
          type_amount: isKilogrammAmount,
          amount: int.tryParse(amountController.text.trim()) ?? 0,
        );
      case ProductType.work:
        return baseDto.copyWith(
          subTitle: nameCompany.text.trim(),
          price: double.tryParse(priceController.text.trim()) ?? 0.0,
          maxPrice: double.tryParse(maxPriceController.text.trim()) ?? 0.0,
        );
      default:
        return baseDto;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>().userData;
    final width = MediaQuery.of(context).size.width;
    final style = TextStyle(fontSize: 16, color: theme.colors.black);

    switch (widget.productType) {
      case ProductType.machine:
        return MachineForm(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.colors.green,
              primary: theme.colors.green,
              secondary: theme.colors.green,
            ),
            scaffoldBackgroundColor: theme.colors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.colors.white,
              foregroundColor: theme.colors.black,
            ),
          ),
          authProvider: authProvider,
          width: width,
          style: style,
          formKey: _formKey,
          titleController: titleController,
          descriptionController: descriptionController,
          amountController: amountController,
          priceController: priceController,
          contactFace: contactFace,
          phoneNumber: phoneNumber,
          yearController: yearController,
          images: images,
          region: region,
          city: city,
          isMachine: isMachine,
          isNewState: isNewState,
          isKilogrammAmount: isKilogrammAmount,
          onKilogrammAmountChanged:
              (value) => setState(() => isKilogrammAmount = value),
          onRegionChanged: (value) => setState(() => region = value),
          onCityChanged: (value) => setState(() => city = value),
          onImageAdded: (image) => setState(() => images.add(image)),
          onPreviewPressed: _onPreviewPressed,
          onPublishPressed: _onPublishPressed,
        );
      case ProductType.fertiliser:
        return MaterialForm(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.colors.green,
              primary: theme.colors.green,
              secondary: theme.colors.green,
            ),
            scaffoldBackgroundColor: theme.colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.colors.white,
              foregroundColor: theme.colors.black,
            ),
          ),
          authProvider: authProvider,
          width: width,
          style: style,
          formKey: _formKey,
          titleController: titleController,
          amountController: amountController,
          priceController: priceController,
          contactFace: contactFace,
          phoneNumber: phoneNumber,
          images: images,
          region: region,
          city: city,
          isKilogrammAmount: isKilogrammAmount,
          isKilogrammPrice: isKilogrammPrice,
          onKilogrammAmountChanged:
              (value) => setState(() => isKilogrammAmount = value),
          onKilogrammPriceChanged:
              (value) => setState(() => isKilogrammPrice = value),
          onRegionChanged: (value) => setState(() => region = value),
          onCityChanged: (value) => setState(() => city = value),
          onImageAdded: (image) => setState(() => images.add(image)),
          onPreviewPressed: _onPreviewPressed,
          onPublishPressed: _onPublishPressed,
        );
      case ProductType.raw_material:
        return MaterialForm(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.colors.green,
              primary: theme.colors.green,
              secondary: theme.colors.green,
            ),
            scaffoldBackgroundColor: theme.colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.colors.white,
              foregroundColor: theme.colors.black,
            ),
          ),
          authProvider: authProvider,
          width: width,
          style: style,
          formKey: _formKey,
          titleController: titleController,
          amountController: amountController,
          priceController: priceController,
          contactFace: contactFace,
          phoneNumber: phoneNumber,
          images: images,
          region: region,
          city: city,
          isKilogrammAmount: isKilogrammAmount,
          isKilogrammPrice: isKilogrammPrice,
          onKilogrammAmountChanged:
              (value) => setState(() => isKilogrammAmount = value),
          onKilogrammPriceChanged:
              (value) => setState(() => isKilogrammPrice = value),
          onRegionChanged: (value) => setState(() => region = value),
          onCityChanged: (value) => setState(() => city = value),
          onImageAdded: (image) => setState(() => images.add(image)),
          onPreviewPressed: _onPreviewPressed,
          onPublishPressed: _onPublishPressed,
        );
      case ProductType.work:
        return JobForm(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.colors.green,
              primary: theme.colors.green,
              secondary: theme.colors.green,
            ),
            scaffoldBackgroundColor: theme.colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.colors.white,
              foregroundColor: theme.colors.black,
            ),
          ),
          authProvider: authProvider,
          width: width,
          style: style,
          formKey: _formKey,
          titleController: titleController,
          descriptionController: descriptionController,
          priceController: priceController,
          maxPriceController: maxPriceController,
          nameCompany: nameCompany,
          contactFace: contactFace,
          phoneNumber: phoneNumber,
          images: images,
          region: region,
          city: city,
          onRegionChanged: (value) => setState(() => region = value),
          onCityChanged: (value) => setState(() => city = value),
          onImageAdded: (image) => setState(() => images.add(image)),
          onPreviewPressed: _onPreviewPressed,
          onPublishPressed: _onPublishPressed,
        );
      default:
        return Scaffold(appBar: AppBar(title: Text('Error')));
    }
  }

  void _onPreviewPressed() {
    if (images.isEmpty) {
      showTopSnackBar(context: context, title: 'Выберите фото');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      showTopSnackBar(
        context: context,
        title: 'Проверьте правильность заполнения полей',
      );
      return;
    }

    if (region == null || city == null) {
      showTopSnackBar(context: context, title: 'Выберите регион и город');
      return;
    }

    productDto = _createProductDto(context.read<MyAuthProvider>().userData);
    navigateTo(
      context: context,
      fullScreenDialog: true,
      rootNavigator: true,
      screen: ProductDetailScreen(product: productDto!, images: images),
    );
  }

  void _onPublishPressed() {
    if (images.isEmpty) {
      showTopSnackBar(context: context, title: 'Выберите фото');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      showTopSnackBar(
        context: context,
        title: 'Проверьте правильность заполнения полей',
      );
      return;
    }

    if (region == null || city == null) {
      showTopSnackBar(context: context, title: 'Выберите регион и город');
      return;
    }

    productDto = _createProductDto(context.read<MyAuthProvider>().userData);
    context.read<AdvertisementScreenBloc>().add(
      AddAdvert(
        images: images,
        product: productDto!,
        userPhoneNumber:
            phoneNumber.text.isEmpty
                ? context.read<MyAuthProvider>().userData!.phoneNumber
                : phoneNumber.text,
        productType: widget.productType!,
      ),
    );
  }

  List<String> _getCheckList() {
    switch (widget.productType) {
      case ProductType.machine:
        return [
          titleController.text,
          priceController.text,
          descriptionController.text,
          contactFace.text,
          phoneNumber.text,
          amountController.text,
        ];
      case ProductType.fertiliser:
      case ProductType.raw_material:
        return [
          titleController.text,
          amountController.text,
          priceController.text,
          contactFace.text,
          phoneNumber.text,
        ];
      case ProductType.work:
        return [
          titleController.text,
          descriptionController.text,
          priceController.text,
          maxPriceController.text,
          nameCompany.text,
          contactFace.text,
          phoneNumber.text,
        ];
      default:
        return [];
    }
  }
}
