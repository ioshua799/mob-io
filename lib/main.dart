import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Burger Station',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7047EB)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}