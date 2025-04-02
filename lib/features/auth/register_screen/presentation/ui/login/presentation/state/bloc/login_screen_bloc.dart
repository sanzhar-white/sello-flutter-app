import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:selo/repository/user_repo.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final UserRepo userRepo;
  LoginScreenBloc(this.userRepo) : super(LoginScreenInitial()) {
    String? verificationId;

    on<LoginEvent>((event, emit) async {
      try {
        emit(LoginScreenLoading());
        final UserData? userData = await userRepo.getUserData(
          event.phoneNumber,
        );

        if (userData != null) {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (phoneAuthCredential) {},
            verificationFailed: (error) {
              print(error);
              // emit(LoginScreenError(error: error.toString()));
            },
            codeSent: (id, forceResendingToken) {
              verificationId = id;
            },
            codeAutoRetrievalTimeout: (id) {},
          );

          if (verificationId != null) {
            emit(LoginScreenSuccess(value: verificationId!));
          }
        } else {
          emit(NoAccountEvent());
        }
      } catch (e) {
        print(e.toString());
        emit(LoginScreenError(error: e.toString()));
      }
    });
  }
}
