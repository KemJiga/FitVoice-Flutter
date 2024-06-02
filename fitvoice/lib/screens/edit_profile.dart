// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:fitvoice/utils/config.dart';
import 'package:http/http.dart' as http;

import 'package:fitvoice/models/user_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user, required this.authToken});
  final String? authToken;
  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

enum Gender { hombre, mujer }

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final baseUrl = Config.url;

  final String ffamily = 'BrandonGrotesque';
  final double fsize = 20;
  final Color fcolor = Colors.black;

  Gender _selectedGender = Gender.hombre;
  String _enteredName = '';
  String _enteredLastName = '';
  var _enteredAge = '';
  var _enteredHeight = '';
  var _enteredWeight = '';

  @override
  void initState() {
    super.initState();
    _enteredName = widget.user.firstName;
    _enteredLastName = widget.user.lastName;
    if (widget.user.healthData == null) return;

    _enteredAge = widget.user.healthData!.age.toString();
    _enteredHeight = widget.user.healthData!.height.toString();
    _enteredWeight = widget.user.healthData!.weight.toString();
    _selectedGender =
        widget.user.healthData!.gender == 'male' ? Gender.hombre : Gender.mujer;
  }

  String getGender(Gender gender) {
    return gender == Gender.hombre ? 'male' : 'female';
  }

  String cap(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  void _submit() async {
    var URL = Uri.parse('$baseUrl/api/v1/auth/users/me/health-data');
    var URL2 = Uri.parse('$baseUrl/api/v1/auth/users/me');

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    String gender = getGender(_selectedGender);

    var res = await http.patch(
      URL,
      body: {
        'age': _enteredAge,
        'gender': gender,
        'height': _enteredHeight,
        'weight': _enteredWeight,
      },
      headers: {'Authorization': 'Bearer ${widget.authToken}'},
    );

    if (res.statusCode == 200) {
      var res2 = await http.patch(
        URL2,
        body: {
          'firstName': _enteredName,
          'lastName': _enteredLastName,
        },
        headers: {'Authorization': 'Bearer ${widget.authToken}'},
      );

      if (res2.statusCode == 200) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Actualización de información exitosa.',
              style: TextStyle(
                fontFamily: 'BrandonGrotesque',
              ),
            ),
          ),
        );
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          child: Form(
            key: _formKey,
            child: SizedBox(
              child: Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelStyle:
                                  Estilos.textStyle1(fsize, fcolor, 'normal'),
                              labelText: 'Nombre',
                            ),
                            style: Estilos.textStyle1(fsize, fcolor, 'normal'),
                            initialValue: widget.user.firstName,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingrese un nombre valido';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredName = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelStyle:
                                  Estilos.textStyle1(fsize, fcolor, 'normal'),
                              labelText: 'Apellido',
                            ),
                            style: Estilos.textStyle1(fsize, fcolor, 'normal'),
                            initialValue: widget.user.lastName,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingrese un apellido valido';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredLastName = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelStyle:
                                  Estilos.textStyle1(fsize, fcolor, 'normal'),
                              labelText: 'Edad',
                            ),
                            style: Estilos.textStyle1(fsize, fcolor, 'normal'),
                            initialValue: widget.user.healthData!.age
                                .toString()
                                .substring(
                                    0,
                                    widget.user.healthData!.age
                                            .toString()
                                            .length -
                                        2),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  int.parse(value) < 0 ||
                                  int.parse(value) > 100) {
                                return 'Por favor ingrese una edad valida';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredAge = value!;
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelStyle:
                                  Estilos.textStyle1(fsize, fcolor, 'normal'),
                              labelText: 'Altura (cm)',
                            ),
                            style: Estilos.textStyle1(fsize, fcolor, 'normal'),
                            initialValue: widget.user.healthData!.height
                                .toString()
                                .substring(
                                    0,
                                    widget.user.healthData!.height
                                            .toString()
                                            .length -
                                        2),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  int.parse(value) < 0 ||
                                  int.parse(value) > 250) {
                                return 'Por favor ingrese una altura valida.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredHeight = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle:
                                  Estilos.textStyle1(fsize, fcolor, 'normal'),
                              labelText: 'Peso',
                            ),
                            style: Estilos.textStyle1(fsize, fcolor, 'normal'),
                            initialValue:
                                widget.user.healthData!.weight.toString(),
                            validator: (value) {
                              if (value!.isEmpty || double.parse(value) < 0) {
                                return 'Por favor ingrese su peso.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredWeight = value!;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            'Guardar',
                            style: Estilos.textStyle1(
                                16, Estilos.color1, 'normal'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
