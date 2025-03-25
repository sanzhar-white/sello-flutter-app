import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sello/components/show_modal_bottom_sheet_wrap.dart';
import 'package:sello/components/show_top_snack_bar.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/auth_screen.dart';
import 'package:sello/features/main_screen/presentation/view_model/main_screen_vm.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/edit_profile/ui/feature.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/presentation/ui/feature.dart';
import 'package:sello/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.watch<MyAuthProvider>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(S.of(context).profile)),
          body: Column(
            children: [
              authProvider.userData?.photo != '' &&
                      authProvider.userData != null
                  ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: authProvider.userData?.photo ?? '',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
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
                  )
                  : CircleAvatar(
                    radius: 80,
                    backgroundColor: theme.colors.colorText3.withOpacity(0.3),
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: theme.colors.colorText3,
                    ),
                  ),
              const SizedBox(height: 12),
              Text(
                "${authProvider.userData?.name}  ${authProvider.userData?.lastName}",
                style: TextStyle(
                  color: theme.colors.colorText2,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap:
                    () => navigateTo(
                      context: context,
                      rootNavigator: true,
                      screen: EditProfileScreenFeature(
                        userData: authProvider.userData!,
                      ),
                    ),
                child: Text(
                  S.of(context).editProfile,
                  style: TextStyle(
                    color: theme.colors.colorText3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                thickness: 8,
                color: theme.colors.colorText3.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              MyListTile(
                onTap:
                    () => navigateTo(
                      context: context,
                      rootNavigator: true,
                      screen: const MyAdvertsScreenFeature(),
                    ),
                iconUrl: 'assets/svg_icons/badge_dollar_sign.svg',
                text: S.of(context).myAds,
              ),

              // MyListTile(
              //   onTap: () => navigateTo(
              //     context: context,
              //     rootNavigator: true,
              //     screen: const PaymentsScreenFeature(),
              //   ),
              //   iconUrl: 'assets/svg_icons/badge_dollar_sign.svg',
              //   text: 'Оплата',
              // ),
              MyListTile(
                onTap: () {
                  showModalBottomSheetWrap(
                    context: context,
                    child: _SelectLanguage(),
                  );
                },
                iconData: Icons.language,
                text: S.of(context).language,
              ),
              // if (Platform.isAndroid)
              MyListTile(
                onTap: () {
                  Platform.isAndroid
                      ? Share.share(
                        'https://play.google.com/store/apps/details?id=com.application.sello',
                      )
                      : Share.share(
                        'https://play.google.com/store/apps/details?id=com.application.sello',
                      );
                },
                iconData: Icons.share,
                text: S.of(context).share,
              ),
              MyListTile(
                onTap:
                    () => launchUrl(
                      Uri.parse('mailto:application.sello@gmail.com'),
                      mode: LaunchMode.externalApplication,
                    ),
                iconData: Icons.email_outlined,
                text: S.of(context).feedback,
              ),
              // if (Platform.isAndroid)
              MyListTile(
                onTap: () {
                  Platform.isIOS
                      ? launchUrl(
                        Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.application.sello',
                        ),
                        mode: LaunchMode.externalApplication,
                      )
                      : launchUrl(
                        Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.application.sello',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                  ;
                },
                iconData: Icons.star,
                text: S.of(context).rateUs,
              ),

              const Spacer(),
              GestureDetector(
                onTap: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await authProvider.logOut(context);
                    setState(() {
                      isLoading = false;
                    });
                    if (!context.mounted) return;
                    navigateToReplacement(
                      rootNavigator: true,
                      context: context,
                      screen: const AuthScreen(),
                    );
                  } on Exception catch (e) {
                    showTopSnackBar(
                      context: context,
                      title: 'Произошла ошибка попробуйте позже',
                      message: e.toString(),
                    );
                  }
                },
                child: Text(
                  S.of(context).logout,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.colorText3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        if (isLoading)
          ColoredBox(
            color: theme.colors.backgroundColorContainer.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          ),
      ],
    );
  }
}

class MyListTile extends StatelessWidget {
  final String? iconUrl;
  final String text;
  final VoidCallback onTap;
  final IconData? iconData;
  const MyListTile({
    super.key,
    this.iconUrl,
    required this.text,
    required this.onTap,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(4),
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
          color: theme.colors.primary,
        ),
        child:
            iconData != null
                ? Icon(iconData, color: theme.colors.white)
                : SvgPicture.asset(iconUrl!),
      ),
      onTap: onTap,
      title: Text(
        text,
        style: TextStyle(
          color: theme.colors.colorText2,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _SelectLanguage extends StatelessWidget {
  const _SelectLanguage();

  @override
  Widget build(BuildContext context) {
    List<String> list = ['қазақша', 'русский', 'english'];
    List<Locale> languageCodes = [Locale('kk'), Locale('ru'), Locale('en')];

    final theme = AppThemeProvider.of(context).themeMode;
    final vm = context.read<MainScreenViewModel>();
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32),
            ...List.generate(list.length, (index) {
              return GestureDetector(
                onTap: () {
                  vm.locale = languageCodes[index];
                  vm.setAppLocale(vm.locale);
                  Navigator.of(context).pop();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 24),
                        Icon(
                          vm.locale == languageCodes[index]
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: theme.colors.primary,
                        ),
                        SizedBox(width: 12),
                        Text(
                          list[index],
                          style: TextStyle(
                            color: theme.colors.colorText2,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: theme.colors.colorText3, height: 24),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
