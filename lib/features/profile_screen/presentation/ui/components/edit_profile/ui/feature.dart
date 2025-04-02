import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/edit_profile/state/bloc/edit_profile_screen_bloc.dart';
import 'package:selo/features/profile_screen/presentation/ui/components/edit_profile/ui/edit_profile_screen.dart';
import 'package:selo/repository/user_repo.dart';

class EditProfileScreenFeature extends StatelessWidget {
  final UserData userData;
  const EditProfileScreenFeature({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileScreenBloc>(
      create: (context) => EditProfileScreenBloc(context.read<UserRepo>()),
      child: EditProfileScreen(userData: userData),
    );
  }
}
