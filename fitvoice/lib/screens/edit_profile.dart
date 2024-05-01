import 'dart:async';

import 'package:fitvoice/models/healthdata_model.dart';
import 'package:fitvoice/models/user_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  Gender _selectedGender = Gender.hombre;
  //bool _isVisible = false;

  String cap(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar perfil'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                        initialValue: widget.user.firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su nombre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.user.firstName = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apellido',
                        ),
                        initialValue: widget.user.lastName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su apellido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.user.firstName = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Edad',
                        ),
                        //initialValue: widget.user.healthData!.age.toString(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su edad';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.user.firstName = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButtonFormField<String>(
                          value: _selectedGender.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = Gender.values.firstWhere(
                                  (element) => element.toString() == newValue);
                            });
                          },
                          items: Gender.values
                              .map((e) => DropdownMenuItem(
                                    value: e.toString(),
                                    child: Text(
                                      cap(e.toString().split('.').last),
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 81, 81, 81),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Altura',
                        ),
                        //initialValue: widget.user.firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su altura';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.user.firstName = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Peso',
                        ),
                        //initialValue: widget.user.firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su peso';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.user.firstName = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      //TODO: implementar el patch de usuario
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Informacion guardada ✅'),
                            ),
                          );
                          Timer(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Estilos.color1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
