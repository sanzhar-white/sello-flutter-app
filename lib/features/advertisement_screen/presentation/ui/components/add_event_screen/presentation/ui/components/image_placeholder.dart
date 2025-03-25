import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/core/theme/theme_provider.dart';

class ImagePlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const ImagePlaceholder({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.colorText3.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Center(
          child: SvgPicture.asset('assets/svg_icons/image_plaseholder.svg'),
        ),
      ),
    );
  }
}
