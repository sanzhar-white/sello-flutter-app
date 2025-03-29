import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/show_modal_bottom_sheet_wrap.dart';
import 'package:sello/components/show_top_snack_bar.dart';
import 'package:sello/components/text_field_fidget.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/auth/register_screen/data/models/region.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/auth_screen.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/register_screen.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/edit_profile/state/bloc/edit_profile_screen_bloc.dart';
import 'package:sello/generated/l10n.dart';
import 'package:sello/repository/user_repo.dart';
import 'package:collection/collection.dart';

class EditProfileScreen extends StatefulWidget {
  final UserData userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneController;
  late final TextEditingController regionController;
  late final TextEditingController cityController;

  XFile? image;

  Category? city;
  Category? region;

  bool isLoading = false;

  @override
  void initState() {
    region = kzRegions.firstWhereOrNull(
      (element) => element.id == widget.userData.region,
    );
    city = region?.subCategories?.firstWhereOrNull(
      (element) => element.id == widget.userData.city,
    );
    ;
    nameController = TextEditingController(text: widget.userData.name);
    lastNameController = TextEditingController(text: widget.userData.lastName);
    phoneController = TextEditingController(text: widget.userData.phoneNumber);
    regionController = TextEditingController(text: region?.name);
    cityController = TextEditingController(text: city?.name);

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    regionController.dispose();
    cityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>();

    return BlocConsumer<EditProfileScreenBloc, EditProfileScreenState>(
      listener: (context, state) {
        if (state is EditProfileScreenSuccess) {
          context.read<MyAuthProvider>().updateUserData();
          showTopSnackBar(
            context: context,
            title: 'Данные успешно сохранены',
            titleColor: theme.colors.greenLight,
          );
        }
        if (state is DeleteAccountError) {
          showTopSnackBar(
            context: context,
            title:
                'Для удаления аккаунта необходимо выйти из аккаунта и повтороно авторизоваться',
          );
        }

        if (state is EditProfileScreenError) {
          showTopSnackBar(context: context, title: state.error);
        }
        if (state is AccountDeleted) {
          navigateToReplacement(
            rootNavigator: true,
            context: context,
            screen: const AuthScreen(),
          );
        }
        if (state is EditProfileScreenLoading) {
          setState(() {
            isLoading = state.isLoading;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  'Настройки Личной Информации',
                  style: TextStyle(
                    color: theme.colors.colorText1,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (image != null)
                        ClipOval(
                          child: Image.file(
                            File(image!.path),
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (image == null && widget.userData.photo == '')
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: theme.colors.colorText3.withOpacity(
                            0.3,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: theme.colors.colorText3,
                          ),
                        ),
                      if (image == null && widget.userData.photo != '')
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.userData.photo ?? '',
                            fit: BoxFit.cover,
                            width: 160,
                            height: 160,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                            errorWidget:
                                (context, url, error) => Icon(
                                  Icons.person,
                                  size: 64,
                                  color: theme.colors.colorText3,
                                ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final picture = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (picture != null) {
                            image = picture;
                            setState(() {});
                          }
                        },
                        child: Text(
                          S.of(context).editPhoto,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: theme.colors.colorText3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: lastNameController,
                        hint: 'Иссабаев',
                        letter: 'Ф',
                        iconColor: Colors.purple,
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: nameController,
                        hint: 'Нуржан',
                        letter: 'И',
                        iconColor: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: TextEditingController(),
                        hint: 'Нурланович',
                        letter: 'О',
                        iconColor: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: phoneController,
                        hint: '+7 777 031 81 94',
                        readOnly: true,
                        isPhone: true,
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: regionController,
                        hint: 'Область',
                        readOnly: true,
                        onTap: () async {
                          city = null;
                          await showModalBottomSheetWrap(
                            context: context,
                            child: SelectRegion(
                              onChangedRegion: (value) {
                                region = value;
                                setState(() {});
                              },
                              regions: kzRegions,
                            ),
                          );
                        },
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: cityController,
                        hint: 'Город',
                        readOnly: true,
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
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                      const SizedBox(height: 24),
                      BigButton(
                        onPressed: () {
                          context.read<EditProfileScreenBloc>().add(
                            UpdateUserData(
                              userData: UserData(
                                name: nameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                phoneNumber: phoneController.text.trim(),
                                photo: '',
                                region: region?.id ?? '',
                                city: city?.id ?? '',
                                amount: widget.userData.amount,
                              ),
                              image: image,
                            ),
                          );
                        },
                        label: 'Сохранить',
                        padding: const EdgeInsets.all(0),
                      ),
                      const SizedBox(height: 36),
                      GestureDetector(
                        onTap: () {
                          context.read<EditProfileScreenBloc>().add(
                            DeleteAccount(
                              userData: authProvider.userData!,
                              imageUrl: authProvider.userData!.photo ?? '',
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).deleteAccount,
                          style: TextStyle(
                            color: theme.colors.primary.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              ColoredBox(
                color: theme.colors.backgroundColorContainer.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    Color? iconColor,
    String? letter,
    bool isPhone = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (letter != null)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor ?? Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (isPhone)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone, color: Colors.black54, size: 20),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: suffixIcon,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
