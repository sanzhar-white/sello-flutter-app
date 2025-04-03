import 'package:flutter/material.dart';
import 'package:selo/core/theme/models/color_palette.dart';

abstract class AppColorScheme {
  Color get white;
  Color get black;
  Color get gray;
  Color get backgroundWidget;
  Color get green;
  Color get backgroundWidget2;
}

class LightScheme implements AppColorScheme {
  const LightScheme();

  @override
  Color get white => ColorPalette.white;

  @override
  Color get black => ColorPalette.black;

  @override
  Color get gray => ColorPalette.gray;

  @override
  Color get backgroundWidget => ColorPalette.backgroundWidget;

  @override
  Color get backgroundWidget2 => ColorPalette.backgroundWidget2;

  @override
  Color get green => ColorPalette.green;
}

class DarkScheme implements AppColorScheme {
  const DarkScheme();

  @override
  Color get white => ColorPalette.white;

  @override
  Color get black => ColorPalette.black;

  @override
  Color get gray => ColorPalette.gray;

  @override
  Color get backgroundWidget => ColorPalette.backgroundWidget;
  Color get backgroundWidget2 => ColorPalette.backgroundWidget2;

  @override
  Color get green => ColorPalette.green;
}
