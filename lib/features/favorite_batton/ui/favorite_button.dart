import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/favorite_batton/data/favorite_button_repo.dart';
import 'package:sello/features/favorite_batton/state/bloc/favorite_button_bloc.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:collection/collection.dart';
import 'package:sello/services/notifications.dart';

class FavoriteButton extends StatelessWidget {
  final KokparEventDto event;
  const FavoriteButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>();
    final repo = context.watch<FavoriteButtonRepo>();
    final allFavorites = repo.favorites;
    final like = allFavorites.firstWhereOrNull(
      (element) => element.id == event.id,
    );

    return GestureDetector(
      onTap: () {
        DateTime date = DateTime.parse(event.date);
        like == null
            ? {
              context.read<FavoriteButtonBloc>().add(
                AddToFavoritesEvent(
                  userPhoneNumber: authProvider.userData!.phoneNumber,
                  event: event,
                ),
              ),
              if (date.isAfter(DateTime.now().add(Duration(days: 1))))
                {
                  NotificationService.scheduleNotification(
                    int.parse(event.id),
                    "sello",
                    event.title,
                    // DateTime.now().add(Duration(seconds: 5))
                    DateTime(
                      date.year,
                      date.month,
                      date.day - 1,
                      date.hour,
                      date.minute,
                    ),
                  ),
                },
            }
            : {
              context.read<FavoriteButtonBloc>().add(
                RemoveFromFavorites(
                  userPhoneNumber: authProvider.userData!.phoneNumber,
                  event: event,
                ),
              ),
              NotificationService.disableNotification(int.parse(event.id)),
            };
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.colorText3),
          color: theme.colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Icon(
          like != null ? Icons.favorite : Icons.favorite_outline,
          size: 20,
          color: like != null ? theme.colors.redLight : theme.colors.colorText1,
        ),
      ),
    );
  }
}
