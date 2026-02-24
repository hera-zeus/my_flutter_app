import 'package:flutter/material.dart';
import 'package:veto_app/views/Homepage_screen.dart';
import 'package:veto_app/views/home_screen.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const VetoApp());
}

class VetoApp extends StatelessWidget {
  const VetoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Veto App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        'home': (context) => const HomeScreen(),
      },
    );
  }
}
