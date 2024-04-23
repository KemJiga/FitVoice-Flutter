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
                    Text(
                      'No food reports',
                      style: TextStyle(
                        fontSize: 30,
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
                  color: Color.fromRGBO(225, 66, 90, 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.59,
                  child: FoodReportList(reports: foodReports),
                ),
              ),
            ],
          );
  }
}
