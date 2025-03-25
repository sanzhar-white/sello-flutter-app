import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/login/presentation/state/bloc/login_screen_bloc.dart';
import 'package:sello/features/auth/register_screen/presentation/ui/login/presentation/ui/log_in_screen.dart';
import 'package:sello/repository/user_repo.dart';

class LoginScreenFeature extends StatelessWidget {
  const LoginScreenFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginScreenBloc(context.read<UserRepo>()),
      child: const LoginScreen(),
    );
  }
}
