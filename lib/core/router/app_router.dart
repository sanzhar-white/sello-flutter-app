import 'package:go_router/go_router.dart';
import 'package:register/register.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/phonecode/:phone',
      builder: (context, state) =>
          PhoneCodeScreen(phone: state.pathParameters['phone']!),
    ),
  ],
);
