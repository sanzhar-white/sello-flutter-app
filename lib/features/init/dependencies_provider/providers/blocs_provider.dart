import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:selo/features/favorite_adverts_button/state/bloc/favorite_adverts_button_bloc.dart';
import 'package:selo/features/favorite_batton/data/favorite_button_repo.dart';
import 'package:selo/features/favorite_batton/state/bloc/favorite_button_bloc.dart';
import 'package:selo/features/home_screen/data/home_screen_repo.dart';
import 'package:selo/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:selo/features/init/splash_screen/presentation/state/splash_screen_bloc.dart';
import 'package:selo/features/favorites_screen.dart/data/favorites_repo.dart';
import 'package:selo/features/favorites_screen.dart/presentation/state/bloc/favorites_screen_bloc.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/my_adverts/data/my_adverts_repo.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/my_adverts/presentation/state/bloc/my_adverts_screen_bloc.dart';
import '../../splash_screen/data/splash_screen_repository.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashScreenBloc>(
          create:
              (context) => SplashScreenBloc(
                splashScreenRepository: context.read<SplashScreenRepository>(),
                // authProvider: context.read<MyAuthProvider>(),
              )..add(Init()),
        ),
        BlocProvider<HomeScreenBloc>(
          create:
              (context) =>
                  HomeScreenBloc(repository: context.read<HomeScreenRepo>()),
        ),
        BlocProvider<FavoritesScreenBloc>(
          create:
              (context) => FavoritesScreenBloc(context.read<FavoritesRepo>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  FavoriteButtonBloc(context.read<FavoriteButtonRepo>()),
        ),
        BlocProvider(
          create:
              (context) => FavoriteAdvertsButtonBloc(
                context.read<FavoriteAdvertsButtonRepo>(),
              ),
        ),
        BlocProvider<MyAdvertsScreenBloc>(
          create:
              (context) => MyAdvertsScreenBloc(context.read<MyAdvertsRepo>()),
        ),
      ],
      child: child,
    );
  }
}
