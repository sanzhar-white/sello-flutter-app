import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selo/features/auth/auth_provider/auth_provider.dart';
import 'package:selo/features/main_screen/presentation/view_model/main_screen_vm.dart';
import 'package:selo/repository/user_repo.dart';

class VMsProvider extends StatelessWidget {
  const VMsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        MultiProvider(
          providers: [
            ChangeNotifierProvider<MyAuthProvider>(
              create:
                  (_) =>
                      MyAuthProvider(userRepo: context.read<UserRepo>())
                        ..init(),
            ),
            ChangeNotifierProvider<MainScreenViewModel>(
              create: (_) => MainScreenViewModel(),
            ),
          ],
        ),
      ],
      child: child,
    );
  }
}
