import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:selo/core/shared_prefs_utils.dart';
import 'package:selo/repository/user_repo.dart';
part 'edit_profile_screen_event.dart';
part 'edit_profile_screen_state.dart';

class EditProfileScreenBloc
    extends Bloc<EditProfileScreenEvent, EditProfileScreenState> {
  final UserRepo userRepo;

  EditProfileScreenBloc(this.userRepo) : super(EditProfileScreenInitial()) {
    on<UpdateUserData>((event, emit) async {
      try {
        emit(EditProfileScreenLoading(isLoading: true));
        String? imageUrl;
        if (event.image != null) {
          final ref = FirebaseStorage.instance.ref().child(
            "user_photos/${event.image!.name}",
          );

          final uploadTask = ref.putFile(File(event.image!.path));

          final snapshot = await uploadTask.whenComplete(() => null);
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        await userRepo.update(event.userData.copyWith(photo: imageUrl ?? ''));
        await SharedPrefs.instance.setString(
          'user',
          event.userData.copyWith(photo: imageUrl ?? '').toJson(),
        );
        emit(EditProfileScreenLoading(isLoading: false));
        emit(EditProfileScreenSuccess());
      } on Exception catch (e) {
        emit(EditProfileScreenLoading(isLoading: false));
        emit(EditProfileScreenError(error: e.toString()));
      }
    });

    on<DeleteAccount>((event, emit) async {
      try {
        emit(EditProfileScreenLoading(isLoading: true));
        await userRepo.deleteAccount(userData: event.userData);
        emit(EditProfileScreenLoading(isLoading: false));
        emit(AccountDeleted());
      } on Exception catch (e) {
        print(e);
        emit(EditProfileScreenLoading(isLoading: false));
        emit(DeleteAccountError());
      }
    });
  }
}
