import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:selo/features/calendar_screen/data/calendar_screen_repo.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

part 'calendar_screen_event.dart';
part 'calendar_screen_state.dart';

class CalendarScreenBloc
    extends Bloc<CalendarScreenEvent, CalendarScreenState> {
  final CalendarScreenRepo repo;
  CalendarScreenBloc(this.repo) : super(CalendarScreenInitial()) {
    on<GetDataCalendarScreen>((event, emit) async {
      try {
        emit(CalendarScreenLoading(isLoading: true));
        final response = await repo.getKokparEventsByDate();
        final favoriteEvents = await repo.getFavoritesEvents(event.phoneNumber);
        emit(CalendarScreenLoading(isLoading: false));
        emit(
          CalendarScreenData(data: response, favoriteEvents: favoriteEvents),
        );
      } on Exception catch (e) {
        print(e);
        emit(CalendarScreenLoading(isLoading: false));
        emit(CalendarScreenError());
      }
    });
  }
}
