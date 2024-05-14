// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<StatefulWidget> createState() {
    return _HealthFormScreenState();
  }
}

enum Gender { hombre, mujer }

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formHealth = GlobalKey<FormState>();
  String? authToken;

  Future<String?> login(String email, String password) async {
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: email, password: password);
      return await userCredentials.user!.getIdToken(true);
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  String cap(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  String getGender(Gender gender) {
    if (gender == Gender.hombre) return 'male';
    if (gender == Gender.mujer) return 'female';
    return '';
  }

  Gender _selectedGender = Gender.hombre;
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
  var _enteredAge = '';
  var _enteredHeight = '';
  var _enteredWeight = '';

  void _submit() async {
    var URL = Uri.parse('$baseUrl/api/v1/auth/users/me/health-data');
    authToken = await login(widget.email, widget.password);

    final isValid = _formHealth.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formHealth.currentState!.save();

    String gender = getGender(_selectedGender);

    var res = await http.patch(
      URL,
      body: {
        'age': _enteredAge,
        'gender': gender,
        'height': _enteredHeight,
        'weight': _enteredWeight,
      },
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      var data = jsonResponse['healthData'];
      print(data);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Registro de informacion exitoso.',
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
            builder: (context) => TabsScreen(
              authToken: authToken!,
            ),
          ),
        );
      });
    } else if (res.statusCode == 400 || res.statusCode == 401) {
      var jsonResponse = jsonDecode(res.body);
      var errorInfo = jsonResponse['errorInfo'];
      var errorMessage = errorInfo['message'];
      print(errorMessage);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Informacion personal'),
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
                        key: _formHealth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Edad',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty ||
                                    int.parse(value) < 0 ||
                                    int.parse(value) > 100) {
                                  return 'Por favor ingrese su edad';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredAge = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Altura (cm)',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty ||
                                    int.parse(value) < 0 ||
                                    int.parse(value) > 250) {
                                  return 'Por favor ingrese su altura';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredHeight = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Peso (kg)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty || double.parse(value) < 0) {
                                  return 'Por favor ingrese su peso';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredWeight = value!;
                              },
                            ),
                            DropdownButtonFormField<String>(
                                value: _selectedGender.toString(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = Gender.values.firstWhere(
                                        (element) =>
                                            element.toString() == newValue);
                                  });
                                },
                                items: Gender.values
                                    .map((e) => DropdownMenuItem(
                                          value: e.toString(),
                                          child: Text(
                                            cap(e.toString().split('.').last),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 81, 81, 81),
                                            ),
                                          ),
                                        ))
                                    .toList()),
                            const SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(color: Estilos.color1),
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
      ),
    );
  }
}
