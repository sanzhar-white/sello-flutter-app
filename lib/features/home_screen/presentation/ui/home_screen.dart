import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/components/is_loading.dart';
import 'package:sello/components/utils.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/calendar_screen/presentation/ui/feature.dart';
import 'package:sello/features/empty_screens/empty_screen.dart';
import 'package:sello/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:sello/features/favorite_batton/state/bloc/favorite_button_bloc.dart';
import 'package:sello/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:sello/features/home_screen/presentation/ui/components/event_card.dart';
import 'package:sello/features/home_screen/presentation/ui/components/notification_screen.dart';
import 'package:sello/features/home_screen/presentation/ui/components/product_type_card.dart';
import 'package:sello/features/home_screen/presentation/ui/components/kokpar_event_card.dart';
import 'package:sello/features/horse_screen/presentation/ui/feature.dart';
import 'package:sello/features/kokpar_screen.dart/presentation/ui/feature.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final authProvider = context.read<MyAuthProvider>();

    context.read<FavoriteButtonBloc>().add(
      GetFavoritesEvents(
        userPhoneNumber: authProvider.userData?.phoneNumber ?? '+77757777779',
      ),
    );

    context.read<FavoriteAdvertsButtonBloc>().add(
      GetFavoritesAdvertsEvents(
        userPhoneNumber: authProvider.userData?.phoneNumber ?? '+77757777779',
      ),
    );
    context.read<HomeScreenBloc>().add(
      GetAllKokparEvents(
        phoneNumber: authProvider.userData?.phoneNumber ?? '+77757777779',
      ),
    );

    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authProvider = context.read<MyAuthProvider>();
    final theme = AppThemeProvider.of(context).themeMode;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap:
                  () => navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: const CalendarScreenFeature(),
                  ),
              child: const Icon(Icons.calendar_month_outlined, size: 32),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  navigateTo(
                    context: context,
                    rootNavigator: true,
                    screen: NotificationScreen(),
                  );
                },
                child: Icon(Icons.notifications_outlined, size: 32),
              ),
              SizedBox(width: 20),
            ],
          ),
          body: RefreshIndicator(
            color: theme.colors.primary,
            onRefresh: () async {
              context.read<HomeScreenBloc>().add(
                GetAllKokparEvents(
                  phoneNumber: authProvider.userData!.phoneNumber,
                ),
              );
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 76,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.05,
                        mainAxisSpacing: width * 0.4,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          EventCard(
                            text: 'Көкпар',
                            labelInfo: '+ Жаңа',
                            imageUrl: 'assets/svg_images/kokpar.svg',
                            onTap:
                                () => navigateTo(
                                  context: context,
                                  rootNavigator: true,
                                  screen: const KokparScreenFeature(),
                                ),
                          ),
                          EventCard(
                            text: 'Жамбы ату',
                            labelInfo: 'Жақында',
                            imageUrl: 'assets/svg_images/jamby_atu.svg',
                            onTap: () {
                              navigateTo(
                                context: context,
                                rootNavigator: true,
                                screen: EmptyScreen(jambyAtu: true),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 76,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.05,
                        mainAxisSpacing: width * 0.4,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductTypeCard(
                                text: 'Жылқы',
                                imageUrl: 'assets/svg_images/jylky.svg',
                                onTap:
                                    () => navigateTo(
                                      context: context,
                                      rootNavigator: true,
                                      screen: const HorseScreenFeature(
                                        productType: ProductType.horse,
                                      ),
                                    ),
                              ),
                              ProductTypeCard(
                                text: 'Экипировка',
                                imageUrl: 'assets/svg_images/ekipirovka.svg',
                                onTap:
                                    () => navigateTo(
                                      context: context,
                                      rootNavigator: true,
                                      screen: const HorseScreenFeature(
                                        productType: ProductType.product,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          EventCard(
                            text: 'Бәйге',
                            labelInfo: 'Жақында',
                            imageUrl: 'assets/svg_images/baige.svg',
                            onTap: () {
                              navigateTo(
                                context: context,
                                rootNavigator: true,
                                screen: EmptyScreen(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<HomeScreenBloc, HomeScreenState>(
                      listener: (context, state) {
                        // if (state is HomeScreenSuccess) {
                        //   showTopSnackBar(
                        //     context: context,
                        //     title: 'Мероприятие добавлено в избранное',
                        //     titleColor: AppColors.greenColor,
                        //   );
                        // }
                      },
                      buildWhen:
                          (previous, current) =>
                              current is HomeScreenData ||
                              current is HomeScreenLoading,
                      builder: (context, state) {
                        if (state is HomeScreenLoading && state.isLoading) {
                          return Column(
                            children: [
                              ...List.generate(
                                5,
                                (index) => KokparEventCard.placeholder(),
                              ),
                            ],
                          );
                        }
                        if (state is HomeScreenData) {
                          return Column(
                            children: [
                              ...List.generate(
                                state.events.length,
                                (index) => KokparEventCard(
                                  kokparEventDto: state.events[index],
                                ),
                              ),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) const IsLoadingWidget(),
      ],
    );
  }
}
