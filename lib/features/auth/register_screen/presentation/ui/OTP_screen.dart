import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sello/components/big_button.dart';
import 'package:sello/components/show_top_snack_bar.dart';
import 'package:sello/core/theme/theme_provider.dart';
import 'package:sello/features/auth/auth_provider/auth_provider.dart';
import 'package:sello/features/main_screen/presentation/ui/feature.dart';
import 'package:sello/generated/l10n.dart';
import 'package:sello/repository/user_repo.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final bool isLogin;

  final UserData? userData;
  const OTPScreen({
    super.key,
    required this.verificationId,
    this.userData,
    required this.phoneNumber,
    this.isLogin = false,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late final TextEditingController controller;

  final formKey = GlobalKey<FormState>();

  late String verificationId;

  bool isActive = false;

  bool isLoading = false;

  @override
  void initState() {
    controller = TextEditingController();
    verificationId = widget.verificationId;
    startTimer();
    super.initState();
  }

  late Timer timer;
  int _start = 45;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    final authProvider = context.read<MyAuthProvider>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(S.of(context).register)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  "Қалпына келтіру коды сіздің телефоныңызға жіберілді ұялы. Кодтың жарамдылық мерзімі - 45 секунд. \nКодты енгізіңіз:",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30,
                  ),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 6) {
                        return "Не верно указан код";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(14),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.grey.shade200,
                      selectedFillColor: Colors.grey.shade200,
                      inactiveFillColor: Colors.grey.shade200,
                      activeColor: Colors.grey.shade400,
                      inactiveColor: Colors.grey.shade400,
                      selectedColor: Colors.grey.shade400,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                    onCompleted: (v) {
                      setState(() {
                        isActive = true;
                      });
                    },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");

                      return true;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:
                        _start == 0
                            ? () async {
                              final response = await authProvider
                                  .verifyPhoneNumber(
                                    context,
                                    widget.phoneNumber,
                                  );

                              if (response.status) {
                                verificationId = response.value;
                              }
                              _start = 45;
                              startTimer();
                            }
                            : null,
                    child: Text(
                      S.of(context).resendCode,
                      style: TextStyle(
                        color:
                            _start == 0 ? Colors.blue : theme.colors.colorText3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _start.toString(),
                    style: TextStyle(color: theme.colors.colorText3),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: BigButton(
              onPressed: () async {
                if (isActive) {
                  setState(() {
                    isActive = true;
                  });
                  final status = await authProvider.signInWithCredential(
                    verificationId: verificationId,
                    smsCode: controller.text,
                    phoneNumber: widget.phoneNumber,
                    context: context,
                    usr: widget.isLogin ? null : widget.userData,
                  );
                  if (status) {
                    setState(() {
                      isActive = false;
                    });
                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreenFeature(),
                      ),
                      (_) => false,
                    );
                  } else {
                    setState(() {
                      isActive = false;
                    });
                    if (!context.mounted) return;
                    showTopSnackBar(
                      context: context,
                      title: 'Произошла ошибка, попробуйте еще раз',
                    );
                  }
                }
              },
              isActive: isActive,
              label:
                  widget.isLogin ? S.of(context).login : S.of(context).register,
            ),
          ),
        ),
        if (isLoading)
          ColoredBox(
            color: theme.colors.backgroundColorContainer.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          ),
      ],
    );
  }
}
