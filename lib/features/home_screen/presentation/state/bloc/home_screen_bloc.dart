import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';

// Events
abstract class HomeScreenEvent {}

class GetAllProducts extends HomeScreenEvent {
  final String phoneNumber;
  GetAllProducts({required this.phoneNumber});
}

// States
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenData extends HomeScreenState {
  final List<ProductDto> products;
  HomeScreenData({required this.products});
}

class HomeScreenError extends HomeScreenState {
  final String message;
  HomeScreenError({required this.message});
}

// Bloc
class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<GetAllProducts>(_getAllProducts);
  }

  Future<void> _getAllProducts(
    GetAllProducts event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      emit(HomeScreenLoading());
      // TODO: Implement get all products logic
      emit(HomeScreenData(products: []));
    } catch (e) {
      emit(HomeScreenError(message: e.toString()));
    }
  }
}
