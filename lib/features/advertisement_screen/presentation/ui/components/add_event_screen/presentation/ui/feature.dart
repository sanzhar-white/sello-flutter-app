import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/advertisement_screen/data/advertisement_repo.dart';
import 'package:selo/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:selo/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/add_event_screen.dart';

class AddEventScreenFeature extends StatelessWidget {
  final ProductType? productType;

  const AddEventScreenFeature({super.key, this.productType});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AdvertisementRepo(),
      child: BlocProvider<AdvertisementScreenBloc>(
        create:
            (context) =>
                AdvertisementScreenBloc(context.read<AdvertisementRepo>()),
        child: CreateAdvertisementScreen(productType: productType),
      ),
    );
  }
}
