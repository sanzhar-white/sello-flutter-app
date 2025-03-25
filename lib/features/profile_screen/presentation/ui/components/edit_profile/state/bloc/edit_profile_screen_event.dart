part of 'edit_profile_screen_bloc.dart';

@immutable
sealed class EditProfileScreenEvent {}

final class UpdateUserData extends EditProfileScreenEvent {
  final UserData userData;
  final XFile? image;
  UpdateUserData({
    this.image,
    required this.userData,
  });
}

final class DeleteAccount extends EditProfileScreenEvent {
  final UserData userData;
  final String imageUrl;

  DeleteAccount({required this.userData, required this.imageUrl});
}
