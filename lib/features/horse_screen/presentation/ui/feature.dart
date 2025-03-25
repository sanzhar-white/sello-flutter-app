import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/horse_screen/data/horse_screen_repo.dart';
import 'package:sello/features/horse_screen/presentation/state/bloc/horse_screen_bloc.dart';
import 'package:sello/features/horse_screen/presentation/ui/horse_screen.dart';

class HorseScreenFeature extends StatelessWidget {
  final ProductType productType;
  const HorseScreenFeature({super.key, required this.productType});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HorseScreenRepo(),
      child: BlocProvider(
        create:
            (context) =>
                HorseScreenBloc(context.read<HorseScreenRepo>())
                  ..add(GetAllHorseProduct(productType: productType)),
        child: HorseScreen(productType: productType),
      ),
    );
  }
}
