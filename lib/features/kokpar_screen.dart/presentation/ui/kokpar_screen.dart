import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/home_screen/presentation/ui/components/kokpar_event_card.dart';
import 'package:sello/features/kokpar_screen.dart/presentation/state/bloc/kokpar_screen_bloc.dart';

class KokparScreen extends StatefulWidget {
  const KokparScreen({super.key});

  @override
  State<KokparScreen> createState() => _KokparScreenState();
}

class _KokparScreenState extends State<KokparScreen> {
  String? category;

  @override
  Widget build(BuildContext context) {
    // final theme = AppThemeProvider.of(context).themeMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кокпар'),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       category = null;
        //       setState(() {});
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(20),
        //       child: Text(
        //         'Все',
        //         style: TextStyle(color: Colors.grey.shade600),
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: BlocBuilder<KokparScreenBloc, KokparScreenState>(
        builder: (context, state) {
          if (state is KokparScreenData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 16),
                //   child: Text(
                //     'Категория',
                //     style: TextStyle(
                //       color: theme.colors.colorText1,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                // SizedBox(
                //   height: 80,
                //   child: ListView(
                //     padding: const EdgeInsets.only(left: 16),
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       ...List.generate(kokparEventCategories(context).length,
                //           (index) {
                //         final list = kokparEventCategories(context);

                //         return CategoryCard(
                //           text: list[index].name,
                //           imageUrl: 'assets/svg_images/kokpar.svg',
                //           onTap: () {
                //             category = list[index].id;
                //             setState(() {});
                //           },
                //         );
                //       }),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 24),
                // Divider(
                //   thickness: 8,
                //   color: theme.colors.colorText3.withOpacity(0.2),
                // ),
                // const SizedBox(height: 24),
                // Padding(
                //   padding: const EdgeInsets.only(left: 16),
                //   child: Text(
                //     'Сізге ұсынылады',
                //     style: TextStyle(
                //       color: theme.colors.colorText1,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.events.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      if (category != null && event.category == category) {
                        return KokparEventCard(kokparEventDto: event);
                      }

                      if (category == null) {
                        return KokparEventCard(kokparEventDto: event);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(right: 8),
        width: 110,
        height: 70,
        decoration: BoxDecoration(
          color: theme.colors.colorText3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            SvgPicture.asset(imageUrl, height: 40, width: 40),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: theme.colors.colorText2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
