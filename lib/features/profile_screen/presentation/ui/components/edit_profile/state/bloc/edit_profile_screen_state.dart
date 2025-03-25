part of 'edit_profile_screen_bloc.dart';

@immutable
sealed class EditProfileScreenState {}

final class EditProfileScreenInitial extends EditProfileScreenState {}

final class EditProfileScreenSuccess extends EditProfileScreenState {}

final class EditProfileScreenLoading extends EditProfileScreenState {
  final bool isLoading;

  EditProfileScreenLoading({required this.isLoading});
}

final class EditProfileScreenError extends EditProfileScreenState {
  final String error;

  EditProfileScreenError({required this.error});
}

final class AccountDeleted extends EditProfileScreenState {}

final class DeleteAccountError extends EditProfileScreenState {}
