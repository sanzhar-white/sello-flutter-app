import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sello/components/show_top_snack_bar.dart';
import 'package:sello/core/shared_prefs_utils.dart';
import 'package:sello/repository/user_repo.dart';

class MyAuthProvider extends ChangeNotifier {
  final UserRepo userRepo;
  final auth = FirebaseAuth.instance;

  UserData? userData;

  MyAuthProvider({required this.userRepo});

  Future<void> init() async {
    updateUserData();
  }

  Future<void> updateUserData({String? phoneNumber}) async {
    final String? userInfo = SharedPrefs.instance.getString('user');
    if (userInfo != null) {
      userData = UserData.fromJson(userInfo);
      notifyListeners();
      return;
    }

    if (userData == null) {
      UserData? data = await userRepo.getUserData(phoneNumber!);

      if (data != null) {
        userData = data;
        await SharedPrefs.instance.setString('user', data.toJson());
        await updateUserData();
      }
    }
    notifyListeners();
  }

  // авторизация по номеру телефона

  Future<AuthStatus> verifyPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      AuthStatus status = const AuthStatus(status: false, value: '');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          log(error.toString());
          status = AuthStatus(status: false, value: error.toString());
        },
        codeSent: (verificationId, forceResendingToken) {
          log(verificationId.toString());

          status = AuthStatus(status: true, value: verificationId);
          return;
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );

      return status;
    } on Exception catch (e) {
      print(e.toString());
      return const AuthStatus(status: false, value: '');
    }
  }

  // Вход в приложение

  Future<bool> signInWithCredential({
    required String verificationId,
    required String smsCode,
    required String phoneNumber,
    required BuildContext context,
    UserData? usr,
  }) async {
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      if (usr != null) {
        await userRepo.create(usr);
        await SharedPrefs.instance.setString('user', usr.toJson());
      }
      await updateUserData(phoneNumber: phoneNumber);

      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Выход из приложения

  Future<void> logOut(BuildContext context) async {
    try {
      await auth.signOut();

      await SharedPrefs.instance.remove('user');
      userData = null;
    } catch (e) {
      if (!context.mounted) return;
      showTopSnackBar(context: context, title: e.toString());
    } finally {}
  }
}

class AuthStatus {
  const AuthStatus({required this.status, required this.value});

  final bool status;
  final String value;
}
