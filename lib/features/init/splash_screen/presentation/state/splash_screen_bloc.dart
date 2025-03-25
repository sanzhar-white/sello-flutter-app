import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/splash_screen_repository.dart';
part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final SplashScreenRepository splashScreenRepository;

  SplashScreenBloc({
    required this.splashScreenRepository,
  }) : super(SplashScreenInitial()) {
    on<Init>((event, emit) async {
      try {
        emit(SplashScreenData());
      } on Exception catch (e) {
        print(e);
      }
    });
  }
}
