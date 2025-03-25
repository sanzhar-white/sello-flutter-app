import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/login/presentation/ui/feature.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/register_screen.dart';
import 'package:sello/generated/l10n.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SvgPicture.asset(
        'assets/svg_images/splash_screen_bg.svg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BigButton(
              onPressed:
                  () => navigateTo(
                    context: context,
                    screen: const LoginScreenFeature(),
                  ),
              label: S.of(context).login,
              borderColor: Colors.white,
            ),
            const SizedBox(height: 16),
            BigButton(
              onPressed: () {
                navigateTo(context: context, screen: const RegisterScreen());
              },
              label: S.of(context).register,
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }
}
