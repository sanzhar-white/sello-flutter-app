import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/components/is_loading.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/calendar_screen/presentation/ui/feature.dart';
import 'package:selo/features/empty_screens/empty_screen.dart';
import 'package:selo/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:selo/features/favorite_batton/state/bloc/favorite_button_bloc.dart';
import 'package:selo/features/filter_screen/presentation/ui/filter_screen.dart';
import 'package:selo/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:selo/features/home_screen/presentation/ui/components/event_card.dart';
import 'package:selo/features/home_screen/presentation/ui/components/notification_screen.dart';
import 'package:selo/features/home_screen/presentation/ui/components/kokpar_event_card.dart';
import 'package:selo/features/home_screen/presentation/ui/components/banners_widget.dart';
import 'package:selo/features/kokpar_screen.dart/presentation/ui/feature.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
            toolbarHeight: 120,
            title: Column(
              children: [
                // Row(
                //   children: [
                //     GestureDetector(
                //       onTap:
                //           () => navigateTo(
                //             context: context,
                //             rootNavigator: true,
                //             screen: const CalendarScreenFeature(),
                //           ),
                //       child: const Icon(
                //         Icons.calendar_month_outlined,
                //         size: 32,
                //       ),
                //     ),
                //     Spacer(),
                //     GestureDetector(
                //       onTap: () {
                //         navigateTo(
                //           context: context,
                //           rootNavigator: true,
                //           screen: NotificationScreen(),
                //         );
                //       },
                //       child: Icon(Icons.notifications_outlined, size: 32),
                //     ),
                //     SizedBox(width: 20),
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Поиск в Алматы',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: theme.colors.colorText3.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colors.colorText3.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.tune),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: BannersCarousel(
                      banners: [
                        BannerModel(imageUrl: 'assets/banners/banner1.png'),
                        BannerModel(imageUrl: 'assets/banners/banner1.png'),
                        BannerModel(imageUrl: 'assets/banners/banner1.png'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          child: Text(
                            'Категории',
                            style: TextStyle(
                              color: theme.colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 76,
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: width * 0.05,
                            mainAxisSpacing: width * 0.4,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              EventCard(
                                text: 'Спец-\nтехника',
                                imageUrl: 'assets/categories/special_tech.png',
                                onTap:
                                    () => navigateTo(
                                      context: context,
                                      rootNavigator: true,
                                      screen: const KokparScreenFeature(),
                                    ),
                              ),
                              EventCard(
                                text: 'Работа',
                                imageUrl: 'assets/categories/work.png',
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
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     ProductTypeCard(
                              //       text: 'Жылқы',
                              //       imageUrl: 'assets/svg_images/jylky.svg',
                              //       onTap:
                              //           () => navigateTo(
                              //             context: context,
                              //             rootNavigator: true,
                              //             screen: const HorseScreenFeature(
                              //               productType: ProductType.horse,
                              //             ),
                              //           ),
                              //     ),
                              //     ProductTypeCard(
                              //       text: 'Экипировка',
                              //       imageUrl:
                              //           'assets/svg_images/ekipirovka.svg',
                              //       onTap:
                              //           () => navigateTo(
                              //             context: context,
                              //             rootNavigator: true,
                              //             screen: const HorseScreenFeature(
                              //               productType: ProductType.product,
                              //             ),
                              //           ),
                              //     ),
                              //   ],
                              // ),
                              EventCard(
                                text: 'Сырьё',
                                imageUrl: 'assets/categories/raw.png',
                                onTap: () {
                                  navigateTo(
                                    context: context,
                                    rootNavigator: true,
                                    screen: EmptyScreen(),
                                  );
                                },
                              ),
                              EventCard(
                                text: 'Гербицид/\nУдобрение',
                                imageUrl: 'assets/categories/fertiliser.png',
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
                        SizedBox(height: 32),
                        Container(
                          child: Text(
                            'Все объявления',
                            style: TextStyle(
                              color: theme.colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          width: double.infinity,
                        ),
                        SizedBox(height: 10),
                        BlocConsumer<HomeScreenBloc, HomeScreenState>(
                          listener: (context, state) {},
                          buildWhen:
                              (previous, current) =>
                                  current is HomeScreenData ||
                                  current is HomeScreenLoading,
                          builder: (context, state) {
                            if (state is HomeScreenLoading && state.isLoading) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio:
                                          0.8, // Adjust this for desired card size
                                    ),
                                itemCount: 6, // Number of placeholder items
                                itemBuilder:
                                    (context, index) =>
                                        KokparEventCard.placeholder(),
                              );
                            }
                            if (state is HomeScreenData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio:
                                          0.8, // Adjust this for desired card size
                                    ),
                                itemCount: state.events.length,
                                itemBuilder:
                                    (context, index) => KokparEventCard(
                                      kokparEventDto: state.events[index],
                                    ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const IsLoadingWidget(),
      ],
    );
  }
}
