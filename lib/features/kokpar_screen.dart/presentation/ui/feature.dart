import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/features/kokpar_screen.dart/data/kokpar_screen_repo.dart';
import 'package:selo/features/kokpar_screen.dart/presentation/state/bloc/kokpar_screen_bloc.dart';
import 'package:selo/features/kokpar_screen.dart/presentation/ui/kokpar_screen.dart';

class KokparScreenFeature extends StatelessWidget {
  const KokparScreenFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => KokparScreenRepo(),
      child: BlocProvider(
        create:
            (context) =>
                KokparScreenBloc(context.read<KokparScreenRepo>())
                  ..add(GetAllEvents()),
        child: const KokparScreen(),
      ),
    );
  }
}
