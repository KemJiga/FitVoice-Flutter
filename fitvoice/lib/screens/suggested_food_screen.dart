import 'package:fitvoice/models/food_items_model.dart';
import 'package:flutter/material.dart';

import 'dart:async';

final _formKey = GlobalKey<FormState>();
late int length;

// ignore: must_be_immutable
class SuggestedFoodScreen extends StatefulWidget {
  final List<FoodItemsModel> foodItems;
  late List<FoodItemsModel> suggestions;

  SuggestedFoodScreen({super.key, required this.foodItems}) {
    if (foodItems.isEmpty) {
      length = 0;
    } else {
      suggestions =
          foodItems.where((element) => element.suggestions.isNotEmpty).toList();
      length = suggestions.length;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _SuggestedFoodScreenState();
  }
}

class _SuggestedFoodScreenState extends State<SuggestedFoodScreen> {
  List<bool?> areChecked = List.generate(length, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias de comida'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'Si la IA no comprendio el alimento que mencionaste, puedes ver algunas sugerencias de cambio aqui:'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    for (var i = 0; i < length; i++)
                      CheckboxListTile(
                        title:
                            Text(widget.suggestions[i].suggestions[0].foodName),
                        subtitle: Text(
                            "A cambio de: ${widget.suggestions[i].foodFoodItem.foodName}"),
                        value: areChecked[i],
                        onChanged: (bool? value) {
                          setState(() {
                            areChecked[i] = value;
                          });
                        },
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    //TODO: Implementar la actualizacion de la comida
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Alimentos actualizados ✅'),
                            ),
                          );
                          Timer(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
