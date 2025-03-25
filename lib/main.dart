import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sello/core/shared_prefs_utils.dart';
import 'package:sello/core/theme/theme.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/main_screen/presentation/view_model/main_screen_vm.dart';
import 'package:sello/features/init/dependencies_provider/dependencies_provider.dart';
import 'package:sello/features/init/splash_screen/presentation/ui/splash_screen.dart';
import 'package:sello/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sello/generated/l10n.dart';
import 'package:sello/services/notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await NotificationService.init();
  tz.initializeTimeZones();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    lightStatusAndNavigationBar();
    return DependenciesProvider(
      builder: (context) {
        return Consumer<MainScreenViewModel>(
          builder: (context, vm, _) {
            return AppThemeProvider(
              themeMode: vm.themeMode,
              child: MaterialApp(
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: vm.locale,
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    foregroundColor: vm.themeMode.colors.colorText3,
                    centerTitle: false,
                    titleTextStyle: TextStyle(
                      color: vm.themeMode.colors.colorText1,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                  useMaterial3: false,
                ),
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                home: SplashScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
