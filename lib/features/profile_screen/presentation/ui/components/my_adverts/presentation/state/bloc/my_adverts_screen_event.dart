part of 'my_adverts_screen_bloc.dart';

@immutable
sealed class MyAdvertsScreenEvent {}

final class GetMyAdvertsEvent extends MyAdvertsScreenEvent {
  final String phoneNumber;

  GetMyAdvertsEvent({required this.phoneNumber});
}

final class DeleteAdvertsEvent extends MyAdvertsScreenEvent {
  final String phoneNumber;
  final String id;

  DeleteAdvertsEvent({
    required this.phoneNumber,
    required this.id,
  });
}
