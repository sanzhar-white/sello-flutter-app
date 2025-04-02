import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/core/enums.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';
import '../../data/repository/advertisement_repo.dart';

// События
abstract class AdvertisementScreenEvent {}

class AddAdvert extends AdvertisementScreenEvent {
  final List<XFile> images;
  final ProductDto product;
  final String userPhoneNumber;
  final ProductType productType;

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
        event: event.product,
        userPhoneNumber: event.userPhoneNumber,
        productType: event.productType,
      );
      emit(AdvertisementScreenSuccess());
    } catch (e) {
      emit(AdvertisementScreenError(e.toString()));
    }
  }
}
