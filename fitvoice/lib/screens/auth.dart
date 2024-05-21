import 'package:fitvoice/screens/login.dart';
import 'package:fitvoice/screens/sign_up.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a FitVoice',
              style: Estilos.textStyle1(24, Estilos.color1, 'bold'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Iniciar sesión',
                style: Estilos.textStyle1(16, Estilos.color1, 'normal'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: Text(
                'Registrarse',
                style: Estilos.textStyle1(16, Estilos.color1, 'normal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
