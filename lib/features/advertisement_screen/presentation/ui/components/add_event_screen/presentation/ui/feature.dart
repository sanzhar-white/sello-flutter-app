import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/advertisement_screen/presentation/state/bloc/advertisement_screen_bloc.dart';
import 'package:sello/features/advertisement_screen/presentation/ui/components/add_event_screen/presentation/ui/add_event_screen.dart';

class AddEventScreenFeature extends StatelessWidget {
  final bool product;
  final ProductType? productType;
  final bool horse;

  const AddEventScreenFeature({
    super.key,
    this.product = false,
    this.productType,
    this.horse = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdvertisementScreenBloc>(
      create: (context) => AdvertisementScreenBloc(),
      child: AddEventScreen(
        product: product,
        productType: productType,
        hors: horse,
      ),
    );
  }
}
