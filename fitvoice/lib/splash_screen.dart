import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fitvoice/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splashIconSize: 300,
      backgroundColor: Colors.white,
      splash: Center(
        child: Lottie.asset('assets/animations/splash.json'),
      ),
      nextScreen: const TabsScreen(),
    );
  }
}
