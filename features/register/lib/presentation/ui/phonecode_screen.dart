import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class PhoneCodeScreen extends StatefulWidget {
  final String phone;

  const PhoneCodeScreen({super.key, required this.phone});

  @override
  State<PhoneCodeScreen> createState() => _PhoneCodeScreenState();
}

class _PhoneCodeScreenState extends State<PhoneCodeScreen> {
  bool isLogin = false;
  String errorMessage = '';
  String verificationId = '';
  final TextEditingController _codeController = TextEditingController();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> _verifyPhoneNumber() async {
    try {
      await Auth().createUserWithPhoneNumber(widget.phone);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone number: ${widget.phone}')),
      body: Column(children: [TextField(controller: _codeController)]),
    );
  }
}
