import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sello/core/enums.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/horse_screen/data/horse_screen_repo.dart';

part 'horse_screen_event.dart';
part 'horse_screen_state.dart';

class HorseScreenBloc extends Bloc<HorseScreenEvent, HorseScreenState> {
  final HorseScreenRepo repo;
  HorseScreenBloc(this.repo) : super(HorseScreenInitial()) {
    List<ProductDto> allProducts = [];
    on<GetAllHorseProduct>((event, emit) async {
      try {
        emit(HorseScreenLoading());
        final products = await repo.getAllHorseProduct(event.productType);
        allProducts = products;

        emit(HorseScreenData(products: products));
      } on Exception catch (e) {
        emit(HorseScreenError(errorMassage: e.toString()));
      }
    });

    on<GetHorseByCategoryProduct>((event, emit) async {
      try {
        emit(HorseScreenLoading());
        final List<ProductDto> sortedProducts = [];
        final List<ProductDto> sortedProductsBySubCategory = [];

        for (var element in allProducts) {
          if (element.categoryId == event.category) {
            sortedProducts.add(element);
          }
        }

        if (event.subCategory != null) {
          for (var element in sortedProducts) {
            if (element.subCategoryId == event.subCategory) {
              sortedProductsBySubCategory.add(element);
            }
          }
          emit(HorseScreenData(products: sortedProductsBySubCategory));
          return;
        }

        emit(HorseScreenData(products: sortedProducts));
      } on Exception catch (e) {
        emit(HorseScreenError(errorMassage: e.toString()));
      }
    });
  }
}
