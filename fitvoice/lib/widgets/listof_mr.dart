import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/meal_report.dart';
import 'package:fitvoice/widgets/report_list.dart';

class ListOfMealReports extends StatelessWidget {
  final List<MealReportCard> newMealReports;
  final void Function(int) changePage;
  final List<MealReportCard> readedReports;
  final void Function() callback;

  const ListOfMealReports({
    super.key,
    required this.newMealReports,
    required this.changePage,
    required this.readedReports,
    required this.callback,
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
                        fontFamily: 'BrandonGrotesque',
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
                          fontFamily: 'BrandonGrotesque',
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
                Text('Nuevos reportes',
                    style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
              if (newMealReports.isNotEmpty)
                ReportList(reports: newMealReports),
              if (readedReports.isNotEmpty)
                Text('Reportes leidos',
                    style: Estilos.textStyle1(20, Estilos.color3, 'bold')),
              if (readedReports.isNotEmpty) ReportList(reports: readedReports),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => callback(),
                  child: Text(
                    'Actualizar',
                    style: Estilos.textStyle1(18, Estilos.color1, 'normal'),
                  ),
                ),
              ),
            ],
          );
  }
}
