import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WFino',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF532C8C)),
        useMaterial3: true,
      ),
      home: const SplashScreen(
        duration: 3,
        child: LoginScreen(),
      ),
    );
  }
}
