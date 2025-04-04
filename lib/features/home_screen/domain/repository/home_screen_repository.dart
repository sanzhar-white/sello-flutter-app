import 'package:selo/features/home_screen/data/models/product_dto.dart';

abstract class HomeScreenRepository {
  Future<List<ProductDto>> getAllKokparEvents({
    required String phoneNumber,
    String? searchQuery,
    Map<String, dynamic>? filters,
  });

  Future<List<String>> getFavoritesEvents(String phoneNumber);
}
