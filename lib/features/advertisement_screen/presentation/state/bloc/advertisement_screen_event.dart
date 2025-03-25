part of 'advertisement_screen_bloc.dart';

@immutable
sealed class AdvertisementScreenEvent {}

final class AddAdvertisement extends AdvertisementScreenEvent {
  final KokparEventDto event;
  final String userPhoneNumber;
  final List<XFile> images;

  AddAdvertisement({
    required this.images,
    required this.event,
    required this.userPhoneNumber,
  });
}

final class AddAdvert extends AdvertisementScreenEvent {
  final ProductDto product;
  final String userPhoneNumber;
  final ProductType productType;
  final List<XFile> images;

  AddAdvert({
    required this.images,
    required this.product,
    required this.userPhoneNumber,
    required this.productType,
  });
}
