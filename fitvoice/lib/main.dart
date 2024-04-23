import 'package:fitvoice/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', 'ES'),
      title: 'Fit Voice',
      theme: ThemeData(
        //scaffoldBackgroundColor: const Color.fromARGB(255, 22, 22, 25),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 22, 22, 25),
          selectedItemColor: Color.fromRGBO(46, 209, 46, 1),
          unselectedItemColor: Color.fromRGBO(26, 28, 36, 1),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color.fromRGBO(46, 209, 46, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
