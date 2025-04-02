import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:selo/features/favorite_adverts_button/data/favorite_adverts_button_repo.dart';
import 'package:selo/features/favorite_batton/data/favorite_button_repo.dart';
import 'package:selo/features/home_screen/data/home_screen_repo.dart';
import 'package:selo/features/init/splash_screen/data/splash_screen_repository.dart';
import 'package:selo/features/favorites_screen.dart/data/favorites_repo.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/my_adverts/data/my_adverts_repo.dart';
import 'package:selo/repository/user_repo.dart';

class ReposProvider extends StatelessWidget {
  const ReposProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => MyAdvertsRepo()),
        RepositoryProvider(create: (context) => SplashScreenRepository()),
        RepositoryProvider(create: (context) => UserRepo()),
        RepositoryProvider(create: (context) => HomeScreenRepo()),
        RepositoryProvider(create: (context) => FavoritesRepo()),
        ChangeNotifierProvider(
          create: (context) => FavoriteAdvertsButtonRepo(),
        ),
        ChangeNotifierProvider(create: (context) => FavoriteButtonRepo()),
      ],
      child: child,
    );
  }
}
