import 'package:flutter/material.dart';

class ColorPalette {
  static Color get black => const Color(0xFF000000);
  static Color get white => const Color(0xFFFFFFFF);

  static Color get gray => const Color(0xFF000000);
  static Color get backgroundWidget => const Color(0xFFF2F2F7);
  static Color get backgroundWidget2 => const Color(0xFFF0F0F5);

  static Color get green => const Color(0xFF2B654D);
}

Color changeColorLightness(Color color, double value) =>
    HSLColor.fromColor(color).withLightness(value).toColor();
