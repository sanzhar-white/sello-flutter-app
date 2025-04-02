import 'package:flutter/material.dart';
import 'package:selo/components/big_button.dart';
import 'package:selo/components/show_modal_bottom_sheet_wrap.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/text_field_fidget.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/register_screen/data/models/region.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/phone_number_screen.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import 'package:selo/generated/l10n.dart';
import 'package:selo/repository/user_repo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController regionController;
  late final TextEditingController cityController;

  @override
  void initState() {
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    regionController = TextEditingController();
    cityController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    regionController.dispose();
    cityController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  Category? regionsKZ;
  Category? city;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).register)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                HintText(text: S.of(context).name),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  hintText: S.of(context).name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return S.of(context).requiredField;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                HintText(text: S.of(context).lastName),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: lastNameController,
                  keyboardType: TextInputType.text,
                  hintText: S.of(context).lastName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return S.of(context).requiredField;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                HintText(text: S.of(context).city),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: regionController,
                  hintText: regionsKZ?.name ?? S.of(context).region,
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
                          regionsKZ = value;
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
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: cityController,
                  hintText: city?.name ?? S.of(context).city,
                  readOnly: true,
                  hintColor: theme.colors.colorText2,
                  validator: (value) {
                    return null;
                  },
                  onTap: () {
                    if (regionsKZ == null) {
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
                        cities: regionsKZ!.subCategories,
                      ),
                    );
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colors.colorText3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BigButton(
              onPressed: () {
                if (!_formKey.currentState!.validate() ||
                    city == null ||
                    regionsKZ == null) {
                  showTopSnackBar(
                    context: context,
                    title: 'Необходимо заполнить все поля',
                  );
                  return;
                }
                navigateTo(
                  context: context,
                  screen: PhoneNumberScreen(
                    userData: UserData(
                      name: nameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      phoneNumber: '',
                      photo: '',
                      region: regionsKZ?.name ?? '',
                      city: city?.name ?? '',
                      amount: 0,
                    ),
                  ),
                );
              },
              label: S.of(context).register,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).alreadyRegistered,
                  style: TextStyle(color: theme.colors.colorText3),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    "  " + S.of(context).login,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  final String text;
  const HintText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: theme.colors.colorText2,
      ),
    );
  }
}

class SelectRegion extends StatelessWidget {
  final Function(Category)? onChangedRegion;
  final Function(Category)? onChangedCity;

  final List<Category>? regions;
  final List<Category>? cities;
  const SelectRegion({
    super.key,
    this.regions,
    this.cities,
    this.onChangedRegion,
    this.onChangedCity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: theme.colors.colorText3),
                ),
              ],
            ),
            if (cities == null && regions != null)
              ...regions!.map(
                (e) => GestureDetector(
                  onTap: () {
                    onChangedRegion!(e);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                          color: theme.colors.colorText2,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(color: theme.colors.colorText3, height: 24),
                    ],
                  ),
                ),
              ),
            if (cities != null)
              ...cities!.map(
                (e) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onChangedCity!(e);
                  },
                  child: Column(
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                          color: theme.colors.colorText2,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(color: theme.colors.colorText3, height: 24),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
