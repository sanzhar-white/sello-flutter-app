import 'package:flutter/material.dart';
import 'package:sello/core/theme/app_theme_data.dart';
import 'package:sello/core/shared_prefs_utils.dart';

class MainScreenViewModel extends ChangeNotifier {
  int activeIndex = 0;

  AppThemeMode themeMode = AppThemeMode.light;

  Locale _locale = Locale('ru');

  Locale get locale => _locale;

  MainScreenViewModel() {
    getAppLocale();
  }

  set locale(Locale value) {
    _locale = value;
    notifyListeners();
  }

  final navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  setActiveIndex(value) {
    activeIndex = value;
    notifyListeners();
  }

  void changeScreen(int index) {
    if (index == activeIndex) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }

    activeIndex = index;
    notifyListeners();
  }

  // void clearStack(int? stackIndex) {
  //   navigatorKeys[stackIndex ?? activeIndex]
  //       .currentState
  //       ?.popUntil((route) => route.isFirst);
  // }

  void setAppLocale(Locale locale) {
    SharedPrefs.instance.setString('locale', locale.languageCode);
    locale = locale;

    notifyListeners();
  }

  void getAppLocale() {
    final String? value = SharedPrefs.instance.getString('locale');
    if (value != null) {
      locale = Locale(value);
    }

    notifyListeners();
  }
}
