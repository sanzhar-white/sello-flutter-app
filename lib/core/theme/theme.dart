import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selo/core/theme/app_colors.dart';

// Color changeColorLightness(Color color) =>
//     HSLColor.fromColor(color).withLightness(0.975).toColor(); //977

void darkStatusAndNavigationBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarDividerColor: AppColors.black,
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
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarDividerColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}
