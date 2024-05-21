import 'dart:async';

import 'package:fitvoice/utils/date_translator.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_info_card.dart';
import 'package:fitvoice/models/meal_report_model.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MealReviewScreen extends StatefulWidget {
  final MealReportModel mealReport;
  final String? authToken;
  const MealReviewScreen(
      {Key? key, required this.mealReport, required this.authToken})
      : super(key: key);

  @override
  _MealReviewScreenState createState() => _MealReviewScreenState();
}

class _MealReviewScreenState extends State<MealReviewScreen> {
  late MealReportModel mealReport;
  late String? authToken;
  late bool isPending;

  int calories = 0;
  int proteins = 0;
  int fats = 0;
  int carbs = 0;

  @override
  void initState() {
    super.initState();
    mealReport = widget.mealReport;
    authToken = widget.authToken;
    isPending = mealReport.pending;
  }

  Future<List<MealInfoCard>> getCards() async {
    String baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';

    var URL =
        Uri.parse('$baseUrl/api/v1/foodlog/mrr/nutrition/${mealReport.id}');

    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      var info = jsonResponse['nutritionalInfo'];
      print(info);
      calories =
          info['calories'] is int ? info['calories'] : info['calories'].round();
      proteins =
          info['protein'] is int ? info['protein'] : info['protein'].round();
      fats = info['fat'] is int ? info['fat'] : info['fat'].round();
      carbs = info['carbohydrates'] is int
          ? info['carbohydrates']
          : info['carbohydrates'].round();
    } else if (res.statusCode == 401) {
      var jsonResponse = jsonDecode(res.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else if (res.statusCode == 404) {
      var jsonResponse = jsonDecode(res.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to load nutritional info');
    }

    var URL2 = Uri.parse('$baseUrl/api/v1/foodlog/frr?mrrId=${mealReport.id}');
    var res2 = await http.get(URL2, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    List<MealInfoCard> cards = [];

    if (res2.statusCode == 200) {
      var jsonResponse = jsonDecode(res2.body);
      for (var report in jsonResponse) {
        String foodReportId = report['id'];
        MealInfoCard card = MealInfoCard(
          mrrId: mealReport.id,
          frrId: foodReportId,
          authToken: authToken,
          onRefresh: () {
            setState(() {});
          },
        );
        cards.add(card);
      }
    } else if (res2.statusCode == 401) {
      var jsonResponse = jsonDecode(res2.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else if (res2.statusCode == 404) {
      var jsonResponse = jsonDecode(res2.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to load reports');
    }
    return cards;
  }

  Future<void> deleteReport(String id) async {
    var baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr/$id');

    var res = await http.delete(
      URL,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode == 204) {
      print('Reporte eliminado con exito!');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Reporte eliminado con exito.'),
        ),
      );
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } else {
      var jsonResponse = jsonDecode(res.body);
      print(
          'Error al eliminar el reporte: ${jsonResponse['errorInfo']['message']}');
    }
  }

  Future<bool> _saveMealReview(BuildContext context) async {
    var baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr/${mealReport.id}');

    var res = await http.patch(
      URL,
      body: jsonEncode({'pending': false}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode == 200) {
      return await showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
              dialogBackgroundColor: Colors.white,
            ),
            child: AlertDialog(
              title: const Text('Reporte de comida'),
              content: const Text('El reporte ha sido revisado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Cerrar',
                      style: TextStyle(color: Estilos.color1)),
                ),
              ],
            ),
          );
        },
      );
    } else {
      var jsonResponse = jsonDecode(res.body);
      print(
          'Error al actualizar el reporte: ${jsonResponse['errorInfo']['message']}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime mealTime = mealReport.mealRecordedAt;
    mealTime = mealTime.toLocal();
    var weekDay = DateFormat('EEEE');
    var day = DateFormat('d');
    var month = DateFormat('MMMM');
    var year = DateFormat('y');
    var timeFormatter = DateFormat('hh:mm a');

    String mealDay = day.format(mealTime);
    String mealMonth = DateTranslator().translateMonth(month.format(mealTime));
    String mealYear = year.format(mealTime);
    String mealWeekDay =
        DateTranslator().translateWeekDay(weekDay.format(mealTime));
    String mealTimeFormatted = timeFormatter.format(mealTime);

    String date =
        '$mealWeekDay, $mealDay de $mealMonth, $mealYear - $mealTimeFormatted';

    return FutureBuilder(
      future: getCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Estilos.color1,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<MealInfoCard> cards = snapshot.data as List<MealInfoCard>;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.075,
              title: const Text(
                'Revision de comida',
                style: TextStyle(
                  color: Estilos.color5,
                  fontFamily: 'BrandonGrotesque',
                ),
              ),
            ),
            // ignore: deprecated_member_use
            body: WillPopScope(
              onWillPop: () {
                if (isPending) return _saveMealReview(context);
                return Future.value(true);
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.925,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // General
                        Text(
                          'General',
                          style: Estilos.textStyle1(20, Estilos.color1, 'bold'),
                        ),
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Card(
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 30,
                                color: Estilos.color1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Transcripcion: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                            text:
                                                '${mealReport.rawTranscript}\n',
                                            style: Estilos.textStyle1(
                                                16, Colors.black, 'normal')),
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                          text: date,
                                          style: Estilos.textStyle1(
                                              16, Colors.black, 'normal'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Informacion nutricional
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Text(
                          'Informacion nutricional',
                          style: Estilos.textStyle1(20, Estilos.color1, 'bold'),
                        ),
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Card(
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 30,
                                color: Estilos.color1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Calorias: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                            text: '$calories Kcal\n',
                                            style: Estilos.textStyle1(
                                                16, Colors.black, 'normal')),
                                        TextSpan(
                                          text: 'Proteinas: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                            text: '$proteins gramos\n',
                                            style: Estilos.textStyle1(
                                                16, Colors.black, 'normal')),
                                        TextSpan(
                                          text: 'Grasas: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                            text: '$fats gramos\n',
                                            style: Estilos.textStyle1(
                                                16, Colors.black, 'normal')),
                                        TextSpan(
                                          text: 'Carbohidratos: ',
                                          style: Estilos.textStyle1(
                                              16, Estilos.color5, 'bold'),
                                        ),
                                        TextSpan(
                                            text: '$carbs gramos',
                                            style: Estilos.textStyle1(
                                                16, Colors.black, 'normal')),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Lista de alimentos
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Text(
                          'Alimentos',
                          style: Estilos.textStyle1(20, Estilos.color1, 'bold'),
                        ),
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Column(
                          children: cards,
                        ),
                        if (cards.isEmpty) ...[
                          Card(
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 30,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                    child: Text(
                                      'No se encontraron alimentos para este reporte. Por favor, revise la transcripcion e intentelo de nuevo.',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'normal'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await deleteReport(mealReport.id);
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Eliminar',
                                style: Estilos.textStyle1(
                                    14, Estilos.color1, 'bold'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
