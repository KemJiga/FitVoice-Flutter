import 'package:fitvoice/models/healthdata_model.dart';
import 'package:fitvoice/models/user_model.dart';
import 'package:fitvoice/screens/edit_profile.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.authToken});
  final String? authToken;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
  late UserModel user;

  Future<UserModel> getUserInfo() async {
    var URL = Uri.parse('$baseUrl/api/v1/auth/users/me');
    var res = await http.get(
      URL,
      headers: {
        'Authorization': 'Bearer ${widget.authToken}',
      },
    );

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      var authUser = jsonResponse['authUser'];
      var appUser = jsonResponse['appUser'];
      var hData = appUser['healthData'];

      String firstName = appUser['firstName'];
      String lastName = appUser['lastName'];
      String email = authUser['email'];
      HealthData healthData = HealthData(
        age: double.parse(hData['age']),
        height: double.parse(hData['height']),
        weight: double.parse(hData['weight']),
        gender: hData['gender'],
      );

      String createdAt = appUser['createdAt'];

      UserModel userAux = UserModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        healthData: healthData,
        createdAt: DateTime.parse(createdAt),
      );
      user = userAux;
      return userAux;
      // setState(() {
      //   user = userAux;
      // });
    } else if (res.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Estilos.color1,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nombre: ${user.firstName}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BrandonGrotesque'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Apellido: ${user.lastName}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BrandonGrotesque'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'E-mail: ${user.email}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BrandonGrotesque'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          user: user,
                          authToken: widget.authToken,
                        ),
                      ),
                    ).then((_) {
                      getUserInfo();
                    });
                  },
                  child: Text(
                    'Editar perfil',
                    style: Estilos.textStyle1(16, Estilos.color1, 'normal'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    'Cerrar sesion',
                    style: Estilos.textStyle1(16, Estilos.color4, 'normal'),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
