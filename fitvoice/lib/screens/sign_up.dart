// ignore_for_file: use_build_context_synchronously, unused_field, unused_catch_clause

//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitvoice/screens/health_form.dart';

import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

//final _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;

  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
  final _regexPattern =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d$@$!%*?&-_]{8,100}$');

  final _formSignUp = GlobalKey<FormState>();
  String _enteredName = '';
  String _enteredLastName = '';
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _submit() async {
    var URL = Uri.parse('$baseUrl/api/v1/auth/users');

    final isValid = _formSignUp.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formSignUp.currentState!.save();

    var res = await http.post(
      URL,
      body: {
        'firstName': _enteredName,
        'lastName': _enteredLastName,
        'email': _enteredEmail,
        'password': _enteredPassword,
      },
    );
    if (res.statusCode == 201) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Registro exitoso.',
            style: TextStyle(
              fontFamily: 'BrandonGrotesque',
            ),
          ),
        ),
      );
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthFormScreen(
              email: _enteredEmail,
              password: _enteredPassword,
            ),
          ),
        );
      });
    } else if (res.statusCode == 400) {
      var jsonResponse = jsonDecode(res.body);
      var errorInfo = jsonResponse['errorInfo'];
      var errorMessage = errorInfo['message'];

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            'Error: $errorMessage',
            style: const TextStyle(
              fontFamily: 'BrandonGrotesque',
            ),
          ),
        ),
      );
    } else if (res.statusCode == 409) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Ya existe un usuario con este correo electrónico.',
            style: TextStyle(
              fontFamily: 'BrandonGrotesque',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrarse',
          style: TextStyle(
            fontFamily: 'BrandonGrotesque',
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/icon/icon.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formSignUp,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, ingrese un nombre.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredName = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Apellido',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, ingrese un apellido.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredLastName = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Correo electronico',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Por favor, ingrese un correo valido.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            obscureText: _isObscure,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, ingrese una contraseña.';
                              }
                              if (!_regexPattern.hasMatch(value)) {
                                return 'La contraseña debe tener al menos 8 caracteres y una minuscula, una mayuscula, un numero y un caracter especial.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                color: Estilos.color1,
                                fontFamily: 'BrandonGrotesque',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
