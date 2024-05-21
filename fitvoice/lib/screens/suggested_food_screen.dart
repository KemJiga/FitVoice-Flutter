// ignore_for_file: use_build_context_synchronously

import 'package:fitvoice/models/food_items_model.dart';
import 'package:fitvoice/models/food_model.dart';
import 'package:fitvoice/models/food_report_model.dart';
import 'package:fitvoice/models/user_report_model.dart';
import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SuggestedFoodScreen extends StatefulWidget {
  final String mrrId;
  final String frrId;
  final UserReportModel userReport;
  final FoodItemsModel foodItems;
  final String? authToken;

  const SuggestedFoodScreen(
      {super.key,
      required this.mrrId,
      required this.frrId,
      required this.foodItems,
      required this.userReport,
      required this.authToken});

  @override
  State<StatefulWidget> createState() {
    return _SuggestedFoodScreenState();
  }
}

class _SuggestedFoodScreenState extends State<SuggestedFoodScreen> {
  String? mrrId;
  String? frrId;
  UserReportModel? userReport;
  FoodItemsModel? foodItems;
  String? authToken;

  final formKey = GlobalKey<FormState>();
  late String _enteredAmount;

  final baseUrl = 'https://psihkiugab.us-east-1.awsapprunner.com';

  @override
  void initState() {
    super.initState();
    mrrId = widget.mrrId;
    frrId = widget.frrId;
    userReport = widget.userReport;
    foodItems = widget.foodItems;
    authToken = widget.authToken;
  }

  Future<void> deleteReport(String id, String mmrId) async {
    var URL = Uri.parse('$baseUrl/api/v1/foodlog/frr/$id?mrrId=$mmrId');

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

  Future<void> editAmount() async {
    var URL =
        Uri.parse('$baseUrl/api/v1/foodlog/frr/$frrId/found-food?mrrId=$mrrId');
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    var res = await http.patch(
      URL,
      body: jsonEncode({'amount': double.parse(_enteredAmount)}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Cantidad actualizada!'),
        ),
      );
    } else {
      var jsonResponse = jsonDecode(res.body);
      var errorInfo = jsonResponse['errorInfo']['message'];
      print(errorInfo);
    }
  }

  Future<void> changeFoundFood(String suggId) async {
    var URL = Uri.parse(
        '$baseUrl/api/v1/foodlog/frr/$frrId/change-food?suggestionId=$suggId&mrrId=$mrrId');

    var res = await http.patch(
      URL,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Alimento actualizado!'),
        ),
      );
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } else {
      var jsonResponse = jsonDecode(res.body);
      var errorInfo = jsonResponse['errorInfo']['message'];
      print(errorInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget setSuggestions(List<FoodReportModel> itemSuggestions) {
      List<Card> suggestions = [];
      for (FoodReportModel suggestion in itemSuggestions) {
        FoodModel food = suggestion.food;
        String foodName = food.foodName[0].toUpperCase() +
            food.foodName.substring(1).toLowerCase();
        String otherNames = food.getOtherNames().isNotEmpty
            ? food.getOtherNames()
            : 'No disponibles';
        String foodDescription = food.getDescription().isNotEmpty
            ? food.getDescription()
            : 'No hay descripción disponible';

        Card card = Card(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 30,
                    color: Estilos.color1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Nombre: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '$foodName\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Otros nombres: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '$otherNames\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Descripcion: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '$foodDescription\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Porcion: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text:
                                    '${food.portionSize.round()} ${food.portionSizeUnit}\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Racion: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text:
                                    '${food.servingSize.round()} ${food.servingSizeUnit}\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Calorias: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '${food.calories} Kcal\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Proteinas: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '${food.protein} g\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Grasas: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '${food.fat} g\n',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                            TextSpan(
                              text: 'Carbohidratos: ',
                              style: Estilos.textStyle1(
                                  16, Estilos.color5, 'bold'),
                            ),
                            TextSpan(
                                text: '${food.carbohydrates} g',
                                style: Estilos.textStyle1(
                                    16, Estilos.color5, 'normal')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await changeFoundFood(suggestion.id);
                      },
                      child: Text(
                        'Reemplazar',
                        style: Estilos.textStyle1(14, Estilos.color1, 'bold'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        suggestions.add(card);
      }
      return Column(
        children: suggestions,
      );
    }

    String getAmountConvertionMessage() {
      var BASIC_UNITS_TO_GRAMS = {
        "g": 1,
        "gramos": 1,
        "kg": 1000,
        "kilo": 1000,
        "ml": 1,
        "mililitros": 1,
        "l": 1000,
        "litros": 1000,
        "cucharada": 15,
        "cucharadita": 5,
        "taza": 200,
      };
      String unit = userReport!.unit;
      double amount = userReport!.amount;

      if (foodItems!.foodFoundItem!.amountByUser) {
        return 'Usando cantidad ingresada por el usuario';
      }

      if (unit == '') {
        if (amount > 0) {
          return 'Usando cantidad * tamaño de racion';
        } else {
          return 'Usando cantidad por defecto del alimento';
        }
      } else {
        if (BASIC_UNITS_TO_GRAMS.containsKey(unit)) {
          return 'Usando cantidad transformada ${amount.round()} $unit \u2192 ${(amount * (BASIC_UNITS_TO_GRAMS[unit] as int)).round()} g';
        } else {
          return 'Usando cantidad por defecto';
        }
      }
    }

    bool hasFood = foodItems!.foodFoundItem != null;
    String foodDescription = userReport!.getDescription().isNotEmpty
        ? userReport!.getDescription()
        : 'Sin descripción';
    String foodName = userReport!.foodName[0].toUpperCase() +
        userReport!.foodName.substring(1).toLowerCase();
    FoodModel? food;
    String foodName2 = '';
    String foodDescription2 = '';
    String otherNames = '';
    String amount = '';
    if (hasFood) {
      food = foodItems!.foodFoundItem!.food;
      foodName2 = foodItems!.foodFoundItem!.food.foodName[0].toUpperCase() +
          foodItems!.foodFoundItem!.food.foodName.substring(1).toLowerCase();
      foodDescription2 =
          foodItems!.foodFoundItem!.food.getDescription().isNotEmpty
              ? foodItems!.foodFoundItem!.food.getDescription()
              : 'Sin descripción';
      otherNames = foodItems!.foodFoundItem!.food.getOtherNames().isNotEmpty
          ? foodItems!.foodFoundItem!.food.getOtherNames()
          : 'Sin variantes';

      amount = foodItems!.foodFoundItem!.amount.round().toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Revision de alimento',
          style:
              TextStyle(fontFamily: 'BrandonGrotesque', color: Estilos.color5),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.925,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alimento reportado',
                      style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
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
                            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Nombre: ',
                                    style: Estilos.textStyle1(
                                        16, Estilos.color5, 'bold'),
                                  ),
                                  TextSpan(
                                      text: '$foodName\n',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'normal')),
                                  TextSpan(
                                    text: 'Descripcion: ',
                                    style: Estilos.textStyle1(
                                        16, Estilos.color5, 'bold'),
                                  ),
                                  TextSpan(
                                      text: '$foodDescription\n',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'normal')),
                                  TextSpan(
                                    text: 'Unidad: ',
                                    style: Estilos.textStyle1(
                                        16, Estilos.color5, 'bold'),
                                  ),
                                  TextSpan(
                                      text:
                                          '${userReport!.unit.isEmpty ? 'No especificada' : userReport!.unit}\n',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'normal')),
                                  TextSpan(
                                    text: 'Cantidad: ',
                                    style: Estilos.textStyle1(
                                        16, Estilos.color5, 'bold'),
                                  ),
                                  TextSpan(
                                      text:
                                          '${userReport!.amount.round() == 0 ? 'Sin especificar' : userReport!.amount.round()}',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'normal')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  if (foodItems!.foodFoundItem != null) ...[
                    Text('Mejor alimento encontrado',
                        style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
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
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Nombre: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '$foodName2\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Otros nombres: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '$otherNames\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Descripcion: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '$foodDescription2\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Porcion: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text:
                                            '${food!.portionSize.round()} ${food.portionSizeUnit}\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Racion: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text:
                                            '${food.servingSize.round()} ${food.servingSizeUnit}\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Calorias: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '${food.calories} Kcal\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Proteinas: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '${food.protein} g\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Grasas: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '${food.fat} g\n',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                    TextSpan(
                                      text: 'Carbohidratos: ',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    TextSpan(
                                        text: '${food.carbohydrates} g',
                                        style: Estilos.textStyle1(
                                            16, Estilos.color5, 'normal')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
                    Text('Cantidad final y unidades',
                        style: Estilos.textStyle1(20, Estilos.color1, 'bold')),
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
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad final en gramos/ml',
                                      style: Estilos.textStyle1(
                                          16, Estilos.color5, 'bold'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                      width: double.infinity,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        maxLines: 1,
                                        cursorColor: Estilos.color1,
                                        decoration: InputDecoration(
                                          suffixText: 'g/ml',
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            borderSide: const BorderSide(
                                                color: Estilos.color1),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                        ),
                                        style: Estilos.textStyle1(
                                            16, Colors.black, 'normal'),
                                        initialValue: amount,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Por favor, ingrese una cantidad.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredAmount = value!;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                      width: double.infinity,
                                    ),
                                    Text('\t${getAmountConvertionMessage()}',
                                        style: Estilos.textStyle1(
                                            14, Estilos.color5, 'normal')),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            onPressed: editAmount,
                                            child: Text(
                                              'Actualizar',
                                              style: Estilos.textStyle1(
                                                  14, Estilos.color1, 'bold'),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (foodItems!.suggestions.isNotEmpty) ...[
                      const SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      Text('Alternativas',
                          style:
                              Estilos.textStyle1(20, Estilos.color1, 'bold')),
                      const SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      setSuggestions(foodItems!.suggestions),
                    ] else ...[
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
                                  'No se encontraron sugerencias para este alimento',
                                  style: Estilos.textStyle1(
                                      18, Estilos.color5, 'normal'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ] else ...[
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
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                              child: Text(
                                'Lo sentimos, no pudimos encontrar un alimento',
                                style: Estilos.textStyle1(
                                    18, Estilos.color5, 'bold'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  ElevatedButton(
                    onPressed: () async {
                      await deleteReport(widget.frrId, widget.mrrId);
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Eliminar Alimento',
                        style: Estilos.textStyle1(14, Estilos.color1, 'bold')),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
