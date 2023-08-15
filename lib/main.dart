import 'package:flutter/material.dart';
import 'package:movies/ui/theme/dark_theme.dart';
import 'package:movies/ui/theme/light_theme.dart';
import 'ui/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}