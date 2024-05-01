import 'package:fitvoice/screens/tabs_screen.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HealthFormScreenState();
  }
}

enum Gender { hombre, mujer }

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formHealth = GlobalKey<FormState>();

  String cap(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  String getGender(String gender) {
    gender = gender.toLowerCase();
    if (gender == 'hombre') return 'Male';
    if (gender == 'mujer') return 'Female';
    return '';
  }

  Gender _selectedGender = Gender.hombre;
  var _enteredAge = '';
  var _enteredHeight = '';
  var _enteredWeight = '';

  //TODO: implementar patch de info nutricional
  bool _submit() {
    final isValid = _formHealth.currentState!.validate();

    if (isValid) {
      _formHealth.currentState!.save();
      print(_enteredAge);
      print(_enteredHeight);
      print(_enteredWeight);
      print(_selectedGender.toString());
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            keyboardType: TextInputType.number,
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
                            keyboardType: TextInputType.number,
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
                                            color:
                                                Color.fromARGB(255, 81, 81, 81),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              bool valid = _submit();
                              if (valid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TabsScreen(),
                                  ),
                                );
                              }
                            },
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
    );
  }
}
