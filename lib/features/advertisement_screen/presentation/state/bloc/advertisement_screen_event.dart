part of 'advertisement_screen_bloc.dart';

@immutable
sealed class AdvertisementScreenEvent {}

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
