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
              appBar: AppBar(title: const Text('Профиль')),
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
                      TextFieldWidget(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: lastNameController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),
                      TextFieldWidget(
                        controller: phoneController,
                        readOnly: true,
                        style: TextStyle(color: theme.colors.colorText3),
                      ),
                      const SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: region?.name ?? S.of(context).region,
                        readOnly: true,
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
                        hintText: city?.name ?? S.of(context).city,
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
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.colors.colorText3,
                        ),
                      ),
                      const SizedBox(height: 36),
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
                        label: S.of(context).save,
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
}
