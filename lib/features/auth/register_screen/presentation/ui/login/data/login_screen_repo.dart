import 'package:firebase_auth/firebase_auth.dart';

class LoginScreenRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
  ) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
