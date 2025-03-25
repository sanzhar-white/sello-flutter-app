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

  Future<AuthStatus> verifyPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      AuthStatus status = const AuthStatus(status: false, value: '');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(
              phoneAuthCredential,
            );
            status = AuthStatus(status: true, value: 'auto');
          } catch (e) {
            log('Auto verification failed: $e');
          }
        },
        verificationFailed: (error) {
          log('Verification failed: ${error.toString()}');
          status = AuthStatus(status: false, value: error.toString());
        },
        codeSent: (verificationId, forceResendingToken) {
          log('Code sent: $verificationId');
          status = AuthStatus(status: true, value: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          log('Auto retrieval timeout: $verificationId');
        },
      );

      return status;
    } on Exception catch (e) {
      log('Error in verifyPhoneNumber: $e');
      return const AuthStatus(status: false, value: '');
    }
  }

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

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        cred,
      );

      if (userCredential.user != null) {
        if (usr != null) {
          await userRepo.create(usr);
          await SharedPrefs.instance.setString('user', usr.toJson());
        }
        await updateUserData(phoneNumber: phoneNumber);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.message}');
      return false;
    } on Exception catch (e) {
      log('Error in signInWithCredential: $e');
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPrefs.instance.remove('user');
      userData = null;
      notifyListeners();
    } catch (e) {
      log('Error in logOut: $e');
      rethrow;
    }
  }
}

class AuthStatus {
  final bool status;
  final String value;

  const AuthStatus({required this.status, required this.value});
}
