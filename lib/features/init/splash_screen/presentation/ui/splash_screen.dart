import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/auth_screen.dart';
import 'package:selo/features/main_screen/presentation/ui/feature.dart';
import 'package:selo/features/init/splash_screen/presentation/state/splash_screen_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// TODO anonymys
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<MyAuthProvider>();
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is SplashScreenData) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) =>
                      vm.userData == null
                          ? const AuthScreen()
                          : const MainScreenFeature(),
            ),
          );
        }
      },
      child: Scaffold(
        body: SvgPicture.asset(
          'assets/svg_images/splash_screen_bg.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
