import 'package:fitvoice/models/meal_report_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportsScreen extends StatefulWidget {
  final void Function(int) changePage;
  final String? authToken;

  const ReportsScreen(
      {super.key, required this.changePage, required this.authToken});

  @override
  State<StatefulWidget> createState() {
    return _ReportScreenState();
  }
}

class _ReportScreenState extends State<ReportsScreen> {
  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';
  final List<MealReportCard> pending = [];
  final List<MealReportCard> notPending = [];

  Future<List<List<MealReportCard>>> getDisplayableReports() async {
    List<MealReportCard> _pendingReports = [];
    List<MealReportCard> _readedReports = [];

    //?fetchFoodReports=true
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/mrr');

    var res = await http.get(URL, headers: {
      'Authorization': 'Bearer ${widget.authToken}',
    });

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      for (var report in jsonResponse) {
        String mealId = report['id'];
        String appUserId = report['appUserId'];
        String audioId = report['audioId'];
        String rawTranscript = report['rawTranscript'];

        String dbLookupPreference = report['dbLookupPreference'];
        DateTime mealRecordedAt = DateTime.parse(report['mealRecordedAt']);
        bool pending = report['pending'].toString().toLowerCase() == 'true';

        MealReportModel meal = MealReportModel(
          id: mealId,
          appUserId: appUserId,
          audioId: audioId,
          rawTranscript: rawTranscript,
          dbLookupPreference: dbLookupPreference,
          mealRecordedAt: mealRecordedAt,
          pending: pending,
        );

        if (meal.pending) {
          _pendingReports.add(MealReportCard(
            mealReport: meal,
            authToken: widget.authToken,
            callout: () {
              setState(() {});
            },
          ));
        } else {
          _readedReports.add(MealReportCard(
            mealReport: meal,
            authToken: widget.authToken,
            callout: () {
              setState(() {});
            },
          ));
        }
      }

      List<List<MealReportCard>> mealReportCards = [];
      mealReportCards.add(_pendingReports);
      mealReportCards.add(_readedReports);
      return mealReportCards;
    } else if (res.statusCode == 401) {
      var jsonResponse = jsonDecode(res.body);
      var message = jsonResponse['errorInfo']['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDisplayableReports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Estilos.color1,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error building: ${snapshot.error}'),
          );
        } else {
          List<MealReportCard> pending = snapshot.data![0];
          List<MealReportCard> notPending = snapshot.data![1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pending.isEmpty && notPending.isEmpty) ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Aun no hay reportes de comidas!',
                            textAlign: TextAlign.center,
                            style:
                                Estilos.textStyle1(25, Estilos.color1, 'bold'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                //getDisplayableReports();
                              });
                            },
                            child: Text('Actualizar',
                                style: Estilos.textStyle1(
                                    14, Estilos.color1, 'bold')),
                          )
                        ],
                      ),
                    )
                  ],
                  if (pending.isNotEmpty) ...[
                    Text('Reportes pendientes',
                        style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
                    const SizedBox(height: 10, width: double.infinity),
                    Column(
                      children: pending,
                    ),
                  ],
                  if (notPending.isNotEmpty) ...[
                    const SizedBox(height: 10, width: double.infinity),
                    Text('Reportes leidos',
                        style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
                    const SizedBox(height: 10, width: double.infinity),
                    Column(
                      children: notPending,
                    ),
                  ],
                  if (pending.isNotEmpty || notPending.isNotEmpty) ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          //getDisplayableReports();
                        });
                      },
                      child: Text('Actualizar',
                          style:
                              Estilos.textStyle1(14, Estilos.color1, 'bold')),
                    )
                  ],
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
