import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:sello/features/home_screen/presentation/state/bloc/home_screen_bloc.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/presentation/state/bloc/my_adverts_screen_bloc.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/data/my_adverts_repo.dart';

class BlocsProvider extends StatelessWidget {
  final Widget child;

  const BlocsProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeScreenBloc()),
        BlocProvider(create: (context) => AdvertisementScreenBloc()),
        BlocProvider(create: (context) => MyAdvertsScreenBloc(MyAdvertsRepo())),
      ],
      child: child,
    );
  }
}
