import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selo/core/enums.dart';

import 'package:selo/features/advertisement_screen/data/advertisement_repo.dart';
import 'package:selo/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:selo/features/home_screen/data/models/product_dto.dart';

part 'advertisement_screen_event.dart';
part 'advertisement_screen_state.dart';

class AdvertisementScreenBloc
    extends Bloc<AdvertisementScreenEvent, AdvertisementScreenState> {
  AdvertisementRepo repo;
  AdvertisementScreenBloc(this.repo) : super(AdvertisementScreenInitial()) {
    on<AddAdvertisement>((event, emit) async {
      try {
        emit(AdvertisementScreenLoading());
        List<String> imageUrls = [];
        String? imageUrl;
        if (event.images.isNotEmpty) {
          for (var element in event.images) {
            final ref = FirebaseStorage.instance.ref().child(
              "kokpar_events_images/${element.name}",
            );

            final uploadTask = ref.putFile(File(element.path));

            final snapshot = await uploadTask.whenComplete(() => null);
            imageUrl = await snapshot.ref.getDownloadURL();
            imageUrls.add(imageUrl);
          }
        }

        emit(AdvertisementScreenSuccess());
      } catch (e) {
        emit(AdvertisementScreenError(errorMassage: e.toString()));
      }
    });

    on<AddAdvert>((event, emit) async {
      try {
        emit(AdvertisementScreenLoading());
        List<String> imageUrls = [];
        String? imageUrl;
        if (event.images.isNotEmpty) {
          for (var element in event.images) {
            final ref = FirebaseStorage.instance.ref().child(
              "product_images/${element.name}",
            );

            final uploadTask = ref.putFile(File(element.path));

            final snapshot = await uploadTask.whenComplete(() => null);
            imageUrl = await snapshot.ref.getDownloadURL();
            imageUrls.add(imageUrl);
          }
        }
        await repo.addAdvert(
          event: event.product.copyWith(images: imageUrls),
          userPhoneNumber: event.userPhoneNumber,
          productType: event.productType,
        );

        emit(AdvertisementScreenSuccess());
      } catch (e) {
        print(e);
        debugPrint(e.toString());
        emit(AdvertisementScreenError(errorMassage: e.toString()));
      }
    });
  }
}
