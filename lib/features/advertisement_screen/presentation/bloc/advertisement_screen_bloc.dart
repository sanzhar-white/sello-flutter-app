import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/product_dto.dart' as adv_product;
import '../../data/models/product_type.dart' as adv_type;
import '../../data/repository/advertisement_repo.dart';

// События
abstract class AdvertisementScreenEvent {}

class AddAdvert extends AdvertisementScreenEvent {
  final List<XFile> images;
  final adv_product.ProductDto product;
  final String userPhoneNumber;
  final adv_type.ProductType productType;

  AddAdvert({
    required this.images,
    required this.product,
    required this.userPhoneNumber,
    required this.productType,
  });
}

// Состояния
abstract class AdvertisementScreenState {}

class AdvertisementScreenInitial extends AdvertisementScreenState {}

class AdvertisementScreenLoading extends AdvertisementScreenState {}

class AdvertisementScreenSuccess extends AdvertisementScreenState {}

class AdvertisementScreenError extends AdvertisementScreenState {
  final String errorMassage;

  AdvertisementScreenError(this.errorMassage);
}

// Блок
class AdvertisementScreenBloc
    extends Bloc<AdvertisementScreenEvent, AdvertisementScreenState> {
  final AdvertisementRepo _repository;

  AdvertisementScreenBloc({required AdvertisementRepo repository})
    : _repository = repository,
      super(AdvertisementScreenInitial()) {
    on<AddAdvert>(_onAddAdvert);
  }

  Future<void> _onAddAdvert(
    AddAdvert event,
    Emitter<AdvertisementScreenState> emit,
  ) async {
    try {
      emit(AdvertisementScreenLoading());
      await _repository.addAdvert(
        images: event.images,
        product: event.product,
        userPhoneNumber: event.userPhoneNumber,
        productType: event.productType,
      );
      emit(AdvertisementScreenSuccess());
    } catch (e) {
      emit(AdvertisementScreenError(e.toString()));
    }
  }
}
