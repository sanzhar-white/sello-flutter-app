import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sello/core/theme/app_colors.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/main_screen/presentation/view_model/main_screen_vm.dart';

class MainAppBottomBar extends StatefulWidget {
  const MainAppBottomBar({super.key});

  @override
  State<MainAppBottomBar> createState() => _MainAppBottomBarState();
}

class _MainAppBottomBarState extends State<MainAppBottomBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return Container(
      width: size,
      height: 70,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBarItem(
            iconUrl: 'assets/svg_icons/bottom_nav_bar/home_icon.svg',
            index: 0,
          ),
          _NavBarItem(
            iconUrl: 'assets/svg_icons/bottom_nav_bar/favorit_icon.svg',
            index: 1,
          ),
          _NavBarItem(
            iconUrl: 'assets/svg_icons/bottom_nav_bar/add_icon.svg',
            index: 2,
          ),
          _NavBarItem(
            iconUrl: 'assets/svg_icons/bottom_nav_bar/person_icon.svg',
            index: 3,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({required this.index, required this.iconUrl});

  final String iconUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return GestureDetector(
      onTap: () {
        context.read<MainScreenViewModel>().changeScreen(index);
      },
      child: Consumer<MainScreenViewModel>(
        builder: (context, value, child) {
          bool isActive = value.activeIndex == index;
          return Container(
            width: 56,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconUrl,
                  width: 22,
                  color: isActive ? theme.colors.black : AppColors.colorIcon,
                ),
                const SizedBox(height: 4),
                // Text(
                //   title,
                //   style: TextStyle(
                //     fontSize: 11,
                //     color: isActive
                //         ? theme.colors.primary
                //         : theme.colors.colorText3,
                //   ),
                //   overflow: TextOverflow.ellipsis,
                //   textAlign: TextAlign.center,
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}
