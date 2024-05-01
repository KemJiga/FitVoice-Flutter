import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fitvoice/widgets/food_report.dart';
import 'package:fitvoice/widgets/freport_list.dart';

class ListOfFoodReports extends StatelessWidget {
  final List<FoodReportCard> foodReports;

  const ListOfFoodReports({
    super.key,
    required this.foodReports,
  });

  @override
  Widget build(BuildContext context) {
    return foodReports.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'No hay alimentos!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
              const Text(
                'Alimentos:',
                style: TextStyle(
                  fontSize: 20,
                  color: Estilos.color1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: FoodReportList(reports: foodReports),
                ),
              ),
            ],
          );
  }
}
