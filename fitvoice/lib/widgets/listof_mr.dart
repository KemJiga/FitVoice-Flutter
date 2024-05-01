import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:fitvoice/widgets/report_list.dart';

class ListOfMealReports extends StatelessWidget {
  final List<MealReportCard> newMealReports;
  final void Function(int) changePage;
  final List<MealReportCard> readedReports;

  const ListOfMealReports({
    super.key,
    required this.newMealReports,
    required this.changePage,
    required this.readedReports,
  });

  @override
  Widget build(BuildContext context) {
    return newMealReports.isEmpty && readedReports.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aun no hay reportes de comidas!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => changePage(2),
                      child: const Text(
                        'Agrega aqui!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Estilos.color1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (newMealReports.isNotEmpty)
                const Text(
                  'Nuevos reportes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Estilos.color1,
                  ),
                ),
              if (newMealReports.isNotEmpty)
                ReportList(reports: newMealReports),
              if (readedReports.isNotEmpty)
                const Text(
                  'Reportes leidos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Estilos.color2,
                  ),
                ),
              if (readedReports.isNotEmpty) ReportList(reports: readedReports),
            ],
          );
  }
}
