import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sello/core/theme/app_colors.dart';

// Color changeColorLightness(Color color) =>
//     HSLColor.fromColor(color).withLightness(0.975).toColor(); //977

void darkStatusAndNavigationBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.kDarkBackgroundColor,
      systemNavigationBarDividerColor: AppColors.kDarkBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
}

void lightStatusAndNavigationBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.kBackgroundColor,
      systemNavigationBarDividerColor: AppColors.kBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}
