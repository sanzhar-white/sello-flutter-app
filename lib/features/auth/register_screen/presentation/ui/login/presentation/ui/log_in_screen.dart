import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/components/big_button.dart';
import 'package:selo/components/phone_field.dart';
import 'package:selo/components/show_top_snack_bar.dart';
import 'package:selo/components/utils.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/OTP_screen.dart';
import 'package:selo/features/auth/register_screen/presentation/ui/login/presentation/state/bloc/login_screen_bloc.dart';
import 'package:selo/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController controller;

  final fire = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? phoneNumber;

  bool isLoading = false;

  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return BlocConsumer<LoginScreenBloc, LoginScreenState>(
      listener: (context, state) {
        if (state is NoAccountEvent) {
          setState(() {
            isLoading = false;
          });
          showTopSnackBar(context: context, title: "Номер не зарегистрирован");
        }

        if (state is LoginScreenError) {
          setState(() {
            isLoading = false;
          });
          showTopSnackBar(
            context: context,
            title: "Произошла ошибка, попробуйте позже",
          );
        }

        if (state is LoginScreenSuccess) {
          setState(() {
            isLoading = false;
          });
          navigateTo(
            context: context,
            screen: OTPScreen(
              verificationId: state.value,
              isLogin: true,
              phoneNumber: phoneNumber ?? '',
            ),
          );
        }

        if (state is LoginScreenLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text(S.of(context).login)),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Номер',
                        style: TextStyle(
                          color: theme.colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PhoneFieldWidget(
                        controller: controller,
                        onChanged: (phone) {
                          phoneNumber = phone.completeNumber;
                          final bool currentState =
                              (_formKey.currentState?.validate() ?? false) &&
                              phoneNumber != null &&
                              phoneNumber!.length > 5;
                          if (currentState) {
                            setState(() {
                              isActive = true;
                            });
                          } else {
                            setState(() {
                              isActive = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BigButton(
                  onPressed: () async {
                    final bool currentState =
                        (_formKey.currentState?.validate() ?? false) &&
                        phoneNumber != null &&
                        phoneNumber!.length > 5;
                    if (!currentState) {
                      showTopSnackBar(
                        context: context,
                        title: 'Не верно указан номер телефона',
                      );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    final data =
                        await fire
                            .collection(FireCollections.users)
                            .doc(phoneNumber)
                            .get();
                    final Map? userMap = data.data();

                    if (userMap == null) {
                      setState(() {
                        isLoading = false;
                      });
                      if (!context.mounted) return;
                      showTopSnackBar(
                        context: context,
                        title: "Номер не зарегистрирован",
                      );
                      return;
                    }

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted: (phoneAuthCredential) {},
                      verificationFailed: (error) {
                        setState(() {
                          isLoading = false;
                        });

                        showTopSnackBar(
                          context: context,
                          title: error.toString(),
                        );
                      },
                      codeSent: (verificationId, forceResendingToken) {
                        setState(() {
                          isLoading = false;
                        });
                        navigateTo(
                          context: context,
                          screen: OTPScreen(
                            verificationId: verificationId,
                            isLogin: true,
                            phoneNumber: phoneNumber ?? '',
                          ),
                        );
                        return;
                      },
                      codeAutoRetrievalTimeout: (verificationId) {},
                    );
                  },
                  isActive: isActive,
                  label: S.of(context).sendSMSCode,
                ),
              ),
            ),
            if (isLoading)
              ColoredBox(
                color: theme.colors.backgroundWidget.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        );
      },
    );
  }
}
