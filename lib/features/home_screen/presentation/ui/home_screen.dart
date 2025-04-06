import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/components/is_loading.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/empty_screens/empty_screen.dart';
import 'package:selo/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:selo/features/favorite_batton/state/bloc/favorite_button_bloc.dart';
import 'package:selo/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:selo/features/home_screen/presentation/ui/components/event_card.dart';
import 'package:selo/features/home_screen/presentation/ui/components/mini_card.dart';
import 'package:selo/features/home_screen/presentation/ui/components/banners_widget.dart';
import 'package:selo/features/home_screen/presentation/ui/search/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic> activeFilters = {};
  String searchQuery = '';

  @override
  void initState() {
    _loadInitialData();
    super.initState();
  }

  void _loadInitialData() {
    final authProvider = context.read<MyAuthProvider>();

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
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = context.read<MyAuthProvider>();

      await Future.wait<void>([
        Future(() {
          context.read<FavoriteAdvertsButtonBloc>().add(
            GetFavoritesAdvertsEvents(
              userPhoneNumber:
                  authProvider.userData?.phoneNumber ?? '+77757777779',
            ),
          );
        }),
        Future(() {
          context.read<HomeScreenBloc>().add(
            GetAllKokparEvents(
              phoneNumber: authProvider.userData?.phoneNumber ?? '+77757777779',
            ),
          );
        }),
      ]);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    _applySearchAndFilters();
  }

  void _applySearchAndFilters() {
    final authProvider = context.read<MyAuthProvider>();
    context.read<HomeScreenBloc>().add(
      GetAllKokparEvents(
        phoneNumber: authProvider.userData?.phoneNumber ?? '+77757777779',
        searchQuery: searchQuery,
        filters: activeFilters,
      ),
    );
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
    final theme = AppThemeProvider.of(context).themeMode;

    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {},
      buildWhen:
          (previous, current) =>
              current is HomeScreenData || current is HomeScreenLoading,
      builder: (context, state) {
        if (state is HomeScreenLoading && state.isLoading) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: theme.colors.white,
                appBar: AppBar(
                  title: Column(
                    children: [
                      BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (searchController.text.isNotEmpty ||
                                        activeFilters.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SearchResultsScreen(
                                                searchQuery:
                                                    searchController.text,
                                                results:
                                                    state is HomeScreenData
                                                        ? state.events
                                                        : [],
                                                onApplyFilters: (filters) {
                                                  setState(() {
                                                    activeFilters = filters;
                                                  });
                                                  _applySearchAndFilters();
                                                },
                                                activeFilters: activeFilters,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: theme.colors.backgroundWidget,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: theme.colors.gray,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: searchController,
                                            onChanged: _onSearchChanged,
                                            decoration: InputDecoration(
                                              hintText: 'Поиск в Алматы',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              IconButton(
                                icon: Icon(
                                  Icons.tune,
                                  color:
                                      activeFilters.isNotEmpty
                                          ? theme.colors.green
                                          : theme.colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SearchResultsScreen(
                                            searchQuery: searchController.text,
                                            results:
                                                state is HomeScreenData
                                                    ? state.events
                                                    : [],
                                            onApplyFilters: (filters) {
                                              setState(() {
                                                activeFilters = filters;
                                              });
                                              _applySearchAndFilters();
                                            },
                                            activeFilters: activeFilters,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     navigateTo(
                              //       context: context,
                              //       rootNavigator: true,
                              //       screen: NotificationScreen(),
                              //     );
                              //   },
                              //   child: Icon(Icons.notifications_outlined, size: 32),
                              // ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                body: RefreshIndicator(
                  color: theme.colors.green,
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          child: BannersCarousel(
                            banners: [
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
                            ],
                            isPlaceholder: true,
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
                                      imageUrl: 'assets/categories/machine.svg',
                                      onTap:
                                          () => navigateTo(
                                            context: context,
                                            rootNavigator: true,
                                            screen: const Scaffold(),
                                          ),
                                      isPlaceholder: true,
                                    ),
                                    EventCard(
                                      text: 'Работа',
                                      imageUrl: 'assets/categories/job.svg',
                                      isPlaceholder: true,
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
                                    EventCard(
                                      text: 'Сырьё',
                                      imageUrl:
                                          'assets/categories/raw_materials.svg',
                                      isPlaceholder: true,
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
                                      imageUrl:
                                          'assets/categories/fertiliser.svg',
                                      isPlaceholder: true,
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
                                  if (state is HomeScreenLoading &&
                                      state.isLoading) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.6,
                                          ),
                                      itemCount: 6,
                                      itemBuilder:
                                          (context, index) =>
                                              MiniCard.placeholder(),
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
        if (state is HomeScreenData) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: theme.colors.white,
                appBar: AppBar(
                  title: Column(
                    children: [
                      BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (searchController.text.isNotEmpty ||
                                        activeFilters.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SearchResultsScreen(
                                                searchQuery:
                                                    searchController.text,
                                                results:
                                                    state is HomeScreenData
                                                        ? state.events
                                                        : [],
                                                onApplyFilters: (filters) {
                                                  setState(() {
                                                    activeFilters = filters;
                                                  });
                                                  _applySearchAndFilters();
                                                },
                                                activeFilters: activeFilters,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: theme.colors.backgroundWidget,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: theme.colors.gray,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: searchController,
                                            onChanged: _onSearchChanged,
                                            decoration: InputDecoration(
                                              hintText: 'Поиск в Алматы',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              IconButton(
                                icon: Icon(
                                  Icons.tune,
                                  color:
                                      activeFilters.isNotEmpty
                                          ? theme.colors.green
                                          : theme.colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SearchResultsScreen(
                                            searchQuery: searchController.text,
                                            results:
                                                state is HomeScreenData
                                                    ? state.events
                                                    : [],
                                            onApplyFilters: (filters) {
                                              setState(() {
                                                activeFilters = filters;
                                              });
                                              _applySearchAndFilters();
                                            },
                                            activeFilters: activeFilters,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     navigateTo(
                              //       context: context,
                              //       rootNavigator: true,
                              //       screen: NotificationScreen(),
                              //     );
                              //   },
                              //   child: Icon(Icons.notifications_outlined, size: 32),
                              // ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                body: RefreshIndicator(
                  color: theme.colors.green,
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          child: BannersCarousel(
                            banners: [
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
                              BannerModel(
                                imageUrl: 'assets/banners/banner1.svg',
                              ),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: EventCard(
                                        text: 'Спец-техника',
                                        imageUrl:
                                            'assets/categories/machine.svg',
                                        onTap: () {
                                          navigateTo(
                                            context: context,
                                            rootNavigator: true,
                                            screen: EmptyScreen(),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.05,
                                    ), // Расстояние между карточками
                                    Expanded(
                                      child: EventCard(
                                        text: 'Работа',
                                        imageUrl: 'assets/categories/job.svg',
                                        onTap: () {
                                          navigateTo(
                                            context: context,
                                            rootNavigator: true,
                                            screen: EmptyScreen(),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 76,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: EventCard(
                                        text: 'Сырьё',
                                        imageUrl:
                                            'assets/categories/raw_materials.svg',
                                        onTap: () {
                                          navigateTo(
                                            context: context,
                                            rootNavigator: true,
                                            screen: EmptyScreen(),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.05,
                                    ), // Расстояние между карточками
                                    Expanded(
                                      child: EventCard(
                                        text: 'Гербицид/\nУдобрение',
                                        imageUrl:
                                            'assets/categories/fertiliser.svg',
                                        onTap: () {
                                          navigateTo(
                                            context: context,
                                            rootNavigator: true,
                                            screen: EmptyScreen(),
                                          );
                                        },
                                      ),
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
                                  if (state is HomeScreenData) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.58,
                                          ),
                                      itemCount: state.events.length,
                                      itemBuilder:
                                          (context, index) => MiniCard(
                                            product: state.events[index],
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

        return const SizedBox.shrink();
      },
    );

    // Stack(
    //   children: [
    //     Scaffold(
    //       backgroundColor: theme.colors.white,
    //       appBar: AppBar(
    //         title: Column(
    //           children: [
    //             BlocBuilder<HomeScreenBloc, HomeScreenState>(
    //               builder: (context, state) {
    //                 return Row(
    //                   children: [
    //                     Expanded(
    //                       child: GestureDetector(
    //                         onTap: () {
    //                           if (searchController.text.isNotEmpty ||
    //                               activeFilters.isNotEmpty) {
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder:
    //                                     (context) => SearchResultsScreen(
    //                                       searchQuery: searchController.text,
    //                                       results:
    //                                           state is HomeScreenData
    //                                               ? state.events
    //                                               : [],
    //                                       onApplyFilters: (filters) {
    //                                         setState(() {
    //                                           activeFilters = filters;
    //                                         });
    //                                         _applySearchAndFilters();
    //                                       },
    //                                       activeFilters: activeFilters,
    //                                     ),
    //                               ),
    //                             );
    //                           }
    //                         },
    //                         child: Container(
    //                           height: 40,
    //                           decoration: BoxDecoration(
    //                             color: theme.colors.backgroundWidget,
    //                             borderRadius: BorderRadius.circular(8),
    //                           ),
    //                           child: Row(
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.symmetric(
    //                                   horizontal: 12,
    //                                 ),
    //                                 child: Icon(
    //                                   Icons.search,
    //                                   color: theme.colors.gray,
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: TextField(
    //                                   controller: searchController,
    //                                   onChanged: _onSearchChanged,
    //                                   decoration: InputDecoration(
    //                                     hintText: 'Поиск в Алматы',
    //                                     border: InputBorder.none,
    //                                     contentPadding: EdgeInsets.symmetric(
    //                                       vertical: 8,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(width: 12),
    //                     IconButton(
    //                       icon: Icon(
    //                         Icons.tune,
    //                         color:
    //                             activeFilters.isNotEmpty
    //                                 ? theme.colors.green
    //                                 : theme.colors.black,
    //                       ),
    //                       onPressed: () {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder:
    //                                 (context) => SearchResultsScreen(
    //                                   searchQuery: searchController.text,
    //                                   results:
    //                                       state is HomeScreenData
    //                                           ? state.events
    //                                           : [],
    //                                   onApplyFilters: (filters) {
    //                                     setState(() {
    //                                       activeFilters = filters;
    //                                     });
    //                                     _applySearchAndFilters();
    //                                   },
    //                                   activeFilters: activeFilters,
    //                                 ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                     // GestureDetector(
    //                     //   onTap: () {
    //                     //     navigateTo(
    //                     //       context: context,
    //                     //       rootNavigator: true,
    //                     //       screen: NotificationScreen(),
    //                     //     );
    //                     //   },
    //                     //   child: Icon(Icons.notifications_outlined, size: 32),
    //                     // ),
    //                   ],
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //       body: RefreshIndicator(
    //         color: theme.colors.green,
    //         onRefresh: _refreshData,
    //         child: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    //                 child: BannersCarousel(
    //                   banners: [
    //                     BannerModel(imageUrl: 'assets/banners/banner1.png'),
    //                     BannerModel(imageUrl: 'assets/banners/banner1.png'),
    //                     BannerModel(imageUrl: 'assets/banners/banner1.png'),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(20),
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       height: 40,
    //                       width: double.infinity,
    //                       child: Text(
    //                         'Категории',
    //                         style: TextStyle(
    //                           color: theme.colors.black,
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 18,
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 76,
    //                       child: GridView.count(
    //                         crossAxisCount: 2,
    //                         crossAxisSpacing: width * 0.05,
    //                         mainAxisSpacing: width * 0.4,
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         children: [
    //                           EventCard(
    //                             text: 'Спец-\nтехника',
    //                             imageUrl: 'assets/categories/special_tech.png',
    //                             onTap:
    //                                 () => navigateTo(
    //                                   context: context,
    //                                   rootNavigator: true,
    //                                   screen: const Scaffold(),
    //                                 ),
    //                           ),
    //                           EventCard(
    //                             text: 'Работа',
    //                             imageUrl: 'assets/categories/work.png',
    //                             onTap: () {
    //                               navigateTo(
    //                                 context: context,
    //                                 rootNavigator: true,
    //                                 screen: EmptyScreen(jambyAtu: true),
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     const SizedBox(height: 8),
    //                     SizedBox(
    //                       height: 76,
    //                       child: GridView.count(
    //                         crossAxisCount: 2,
    //                         crossAxisSpacing: width * 0.05,
    //                         mainAxisSpacing: width * 0.4,
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         children: [
    //                           EventCard(
    //                             text: 'Сырьё',
    //                             imageUrl: 'assets/categories/raw.png',
    //                             onTap: () {
    //                               navigateTo(
    //                                 context: context,
    //                                 rootNavigator: true,
    //                                 screen: EmptyScreen(),
    //                               );
    //                             },
    //                           ),
    //                           EventCard(
    //                             text: 'Гербицид/\nУдобрение',
    //                             imageUrl: 'assets/categories/fertiliser.png',
    //                             onTap: () {
    //                               navigateTo(
    //                                 context: context,
    //                                 rootNavigator: true,
    //                                 screen: EmptyScreen(),
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(height: 32),
    //                     Container(
    //                       child: Text(
    //                         'Все объявления',
    //                         style: TextStyle(
    //                           color: theme.colors.black,
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 18,
    //                         ),
    //                       ),
    //                       width: double.infinity,
    //                     ),
    //                     SizedBox(height: 10),
    //                     BlocConsumer<HomeScreenBloc, HomeScreenState>(
    //                       listener: (context, state) {},
    //                       buildWhen:
    //                           (previous, current) =>
    //                               current is HomeScreenData ||
    //                               current is HomeScreenLoading,
    //                       builder: (context, state) {
    //                         if (state is HomeScreenLoading && state.isLoading) {
    //                           return GridView.builder(
    //                             shrinkWrap: true,
    //                             physics: NeverScrollableScrollPhysics(),
    //                             gridDelegate:
    //                                 SliverGridDelegateWithFixedCrossAxisCount(
    //                                   crossAxisCount: 2,
    //                                   crossAxisSpacing: 10,
    //                                   mainAxisSpacing: 10,
    //                                   childAspectRatio: 0.6,
    //                                 ),
    //                             itemCount: 6,
    //                             itemBuilder:
    //                                 (context, index) => MiniCard.placeholder(),
    //                           );
    //                         }
    //                         if (state is HomeScreenData) {
    //                           return GridView.builder(
    //                             shrinkWrap: true,
    //                             physics: NeverScrollableScrollPhysics(),
    //                             gridDelegate:
    //                                 SliverGridDelegateWithFixedCrossAxisCount(
    //                                   crossAxisCount: 2,
    //                                   crossAxisSpacing: 20,
    //                                   mainAxisSpacing: 10,
    //                                   childAspectRatio: 0.59,
    //                                 ),
    //                             itemCount: state.events.length,
    //                             itemBuilder:
    //                                 (context, index) =>
    //                                     MiniCard(product: state.events[index]),
    //                           );
    //                         }

    //                         return const SizedBox.shrink();
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     if (isLoading) const IsLoadingWidget(),
    //   ],
    // );
  }
}
