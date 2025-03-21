import 'package:flutter/material.dart';
import 'package:handmadetest_app/core/router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'SELO App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2B654D),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
