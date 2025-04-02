import 'package:flutter/material.dart';
import 'package:selo/core/theme/models/color_palette.dart';

abstract class AppColorScheme {
  Color get primary;

  Color get secondary;

  Color get secondary2;

  Color get white;

  Color get backgroundColor;

  Color get backgroundColorContainer;

  Color get colorText1;

  Color get colorText2;

  Color get colorText3;

  Color get greyLight;

  Color get grey;

  Color get red;

  Color get green;

  Color get orange;

  Color get redLight;

  Color get greenLight;

  Color get backgroundBottomSheet;

  Color get habitOneDayColor;

  Color get textFieldColor;

  Color get black;
  Color get whiteBlack;
}

class LightScheme implements AppColorScheme {
  const LightScheme();

  @override
  Color get white => ColorPalette.white;

  @override
  Color get backgroundColor => ColorPalette.backgroundColor;

  @override
  Color get backgroundColorContainer => ColorPalette.white;

  @override
  Color get green => ColorPalette.greenColor;

  @override
  Color get red => ColorPalette.redColor;

  @override
  Color get colorText1 => ColorPalette.colorText1;

  @override
  Color get colorText2 => ColorPalette.colorText2;

  @override
  Color get colorText3 => ColorPalette.colorText3;

  @override
  Color get greyLight => const Color.fromARGB(255, 245, 245, 245);

  @override
  Color get orange => ColorPalette.orange;

  @override
  Color get redLight => ColorPalette.redLight;

  @override
  Color get greenLight => ColorPalette.greenLight;

  @override
  Color get backgroundBottomSheet => ColorPalette.backgroundColor;

  @override
  Color get grey => ColorPalette.backgroundColor;

  @override
  Color get habitOneDayColor => ColorPalette.white;

  @override
  Color get primary => ColorPalette.primary;

  @override
  Color get secondary => ColorPalette.secondary;

  @override
  Color get secondary2 => ColorPalette.secondary2;

  @override
  Color get textFieldColor => ColorPalette.white;

  @override
  Color get black => ColorPalette.black;
  Color get whiteBlack => ColorPalette.white;
}

class DarkScheme implements AppColorScheme {
  const DarkScheme();

  @override
  Color get white => ColorPalette.white;

  @override
  Color get black => ColorPalette.black;

  @override
  Color get backgroundColor => ColorPalette.kDarkbackgroundColor;

  @override
  Color get backgroundColorContainer => ColorPalette.darkContainerColor;

  @override
  Color get green => ColorPalette.greenColorD;

  @override
  Color get red => ColorPalette.redColorD;

  @override
  Color get colorText1 => ColorPalette.colorText1D;

  @override
  Color get colorText2 => ColorPalette.colorText2D;

  @override
  Color get colorText3 => ColorPalette.colorText3D;

  @override
  Color get greyLight => const Color.fromARGB(255, 97, 97, 97);

  @override
  Color get orange => ColorPalette.orangeD;

  @override
  Color get redLight => ColorPalette.redLightD;

  @override
  Color get greenLight => ColorPalette.greenLightD;

  @override
  Color get backgroundBottomSheet => ColorPalette.backgroundBottomSheetDark;

  @override
  Color get grey => ColorPalette.grey;

  @override
  Color get habitOneDayColor => ColorPalette.grey;

  @override
  Color get primary => ColorPalette.primary;

  @override
  Color get secondary => ColorPalette.secondary;

  @override
  Color get secondary2 => ColorPalette.secondary2;

  @override
  Color get textFieldColor => ColorPalette.darkContainerColor;

  @override
  Color get whiteBlack => ColorPalette.black;
}
