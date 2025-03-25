import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/components/product_card.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/presentation/state/bloc/my_adverts_screen_bloc.dart';
import 'package:sello/generated/l10n.dart';

class MyAdvertsScreen extends StatefulWidget {
  const MyAdvertsScreen({super.key});

  @override
  State<MyAdvertsScreen> createState() => _MyAdvertsScreenState();
}

class _MyAdvertsScreenState extends State<MyAdvertsScreen> {
  @override
  void initState() {
    final String phoneNumber =
        context.read<MyAuthProvider>().userData!.phoneNumber;
    context.read<MyAdvertsScreenBloc>().add(
      GetMyAdvertsEvent(phoneNumber: phoneNumber),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<MyAuthProvider>();
    final theme = AppThemeProvider.of(context).themeMode;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).myAds)),
      body: BlocConsumer<MyAdvertsScreenBloc, MyAdvertsScreenState>(
        listener: (context, state) async {},
        builder: (context, state) {
          if (state is MyAdvertsScreenData) {
            return state.products.isEmpty
                ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      SvgPicture.asset(
                        'assets/svg_images/no_data_cuate.svg',
                        width: 300,
                      ),
                      Text(
                        'У вас пока нет объявлений',
                        style: TextStyle(color: theme.colors.colorText2),
                      ),
                    ],
                  ),
                )
                : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 260,
                  ),
                  padding: EdgeInsets.all(16),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];

                    return ProductCard(
                      product: product,
                      isProfileScreen: true,
                      deleteAdvert: () {
                        context.read<MyAdvertsScreenBloc>().add(
                          DeleteAdvertsEvent(
                            phoneNumber: authProvider.userData!.phoneNumber,
                            id: product.id,
                          ),
                        );
                      },
                    );
                  },
                );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
