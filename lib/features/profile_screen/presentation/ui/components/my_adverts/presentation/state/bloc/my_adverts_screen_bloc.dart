import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sello/features/home_screen/data/models/product_dto.dart';
import 'package:sello/features/profile_screen/presentation/ui/components/my_adverts/data/my_adverts_repo.dart';

part 'my_adverts_screen_event.dart';
part 'my_adverts_screen_state.dart';

class MyAdvertsScreenBloc
    extends Bloc<MyAdvertsScreenEvent, MyAdvertsScreenState> {
  final MyAdvertsRepo repo;
  MyAdvertsScreenBloc(this.repo) : super(MyAdvertsScreenInitial()) {
    on<GetMyAdvertsEvent>((event, emit) async {
      try {
        emit(MyAdvertsScreenLoading(isLoading: true));
        final myAdverts = await repo.getAllProduct(event.phoneNumber);
        myAdverts.sort((a, b) {
          return DateTime.parse(
            b.createdDate,
          ).compareTo(DateTime.parse(a.createdDate));
        });
        emit(MyAdvertsScreenLoading(isLoading: false));
        emit(MyAdvertsScreenData(products: myAdverts));
      } on Exception catch (e) {
        emit(MyAdvertsScreenError(errorMassage: e.toString()));
      }
    });

    on<DeleteAdvertsEvent>((event, emit) async {
      try {
        emit(MyAdvertsScreenLoading(isLoading: true));
        await repo.deleteAdvert(event.phoneNumber, event.id);

        add(GetMyAdvertsEvent(phoneNumber: event.phoneNumber));
        emit(MyAdvertsScreenLoading(isLoading: false));
        emit(MyAdvertsScreenSuccess());
      } on Exception catch (e) {
        emit(MyAdvertsScreenError(errorMassage: e.toString()));
      }
    });
  }
}
