import 'package:flutter/material.dart';

class ColorPalette {
  static Color get primary => const Color(0xFF2B654D);

  static Color get secondary => const Color(0xFF33c9ff);

  static Color get secondary2 => const Color(0xFF41e94b);

  static Color get white => const Color(0xFFFFFFFF);

  static Color get accent => const Color(0xFFEB702D);

  static Color get redColor => const Color(0xffFFFFFF);

  static Color get redColorD => const Color(0xff2B654D);

  static Color get paleRed => const Color(0xFFFFFFFF);

  static Color get greenColor => const Color(0xFF40bf40);

  static Color get greenColorD => const Color(0xFF339933);

  static Color get orange => const Color(0xFFEC8C00);

  static Color get orangeD => const Color(0xFFb36b00);

  static Color get redLight => const Color(0xff2B654D);

  static Color get redLightD => const Color(0xff2B654D);

  static Color get greenLight => const Color(0xff66cc66);

  static Color get greenLightD => const Color(0xff1f601f);

  static Color get darkContainerColor => const Color(0xff262626);

  static Color get background3 => const Color(0xFFE1EEEC);

  static Color get backgroundBottomSheetDark => const Color(0xff1a1a1a);
  static Color get black => const Color(0xFF131313);
  static Color get grey => const Color(0xFF333333);
  static Color get solid => const Color(0xFFD9D9D9);
  static Color get beige => const Color(0xFFF5E1BE);
  static Color get backgroundColor => const Color(0XFFF7F7F8);
  static Color get kDarkbackgroundColor => const Color(0xff0f0f0f);
  static Color get colorText1 => const Color(0xff090E2C);
  static Color get colorText2 => const Color(0xff3B4158);
  static Color get colorText3 => const Color(0xff9194A2);
  static Color get colorText1D => const Color(0xfff7f7f7);
  static Color get colorText2D => const Color(0xffb3b3b3);
  static Color get colorText3D => const Color(0xff737373);

  static Color get themeColor => const Color(0xff737373);

  static Color get black2 => const Color(0xff000000);
}

Color changeColorLightness(Color color, double value) =>
    HSLColor.fromColor(color).withLightness(value).toColor();
