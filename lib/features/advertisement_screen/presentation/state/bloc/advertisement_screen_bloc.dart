import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:sello/core/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sello/features/home_screen/data/models/product_dto.dart';

// Events
abstract class AdvertisementScreenEvent {}

class AddAdvert extends AdvertisementScreenEvent {
  final List<XFile> images;
  final ProductDto product;
  final String userPhoneNumber;
  final ProductType productType;

  AddAdvert({
    required this.images,
    required this.product,
    required this.userPhoneNumber,
    required this.productType,
  });
}

// States
abstract class AdvertisementScreenState {}

class AdvertisementScreenInitial extends AdvertisementScreenState {}

class AdvertisementScreenLoading extends AdvertisementScreenState {}

class AdvertisementScreenSuccess extends AdvertisementScreenState {}

class AdvertisementScreenError extends AdvertisementScreenState {
  final String errorMassage;
  AdvertisementScreenError({required this.errorMassage});
}

// Bloc
class AdvertisementScreenBloc
    extends Bloc<AdvertisementScreenEvent, AdvertisementScreenState> {
  AdvertisementScreenBloc() : super(AdvertisementScreenInitial()) {
    on<AddAdvert>(_addAdvert);
  }

  Future<void> _addAdvert(
    AddAdvert event,
    Emitter<AdvertisementScreenState> emit,
  ) async {
    try {
      emit(AdvertisementScreenLoading());
      // TODO: Implement add advert logic
      emit(AdvertisementScreenSuccess());
    } catch (e) {
      emit(AdvertisementScreenError(errorMassage: e.toString()));
    }
  }
}
