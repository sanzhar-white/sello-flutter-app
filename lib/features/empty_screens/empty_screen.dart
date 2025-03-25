import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/core/theme/theme_provider.dart';

class EmptyScreen extends StatelessWidget {
  final bool jambyAtu;
  const EmptyScreen({super.key, this.jambyAtu = false});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final String url =
        jambyAtu
            ? 'assets/svg_images/Group.svg'
            : 'assets/svg_images/Group (1).svg';
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.sizeOf(context).height / 5,
            child: SvgPicture.asset(url),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 6.5,
            right: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Жақында',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.primary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  jambyAtu ? 'Жамбы ату' : 'Бәйге',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.colorText2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
