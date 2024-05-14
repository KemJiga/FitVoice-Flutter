import 'package:fitvoice/utils/styles.dart';
import 'package:flutter/material.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Proximamente...',
          style: Estilos.textStyle1(30, Estilos.color5, 'bold')),
    );
  }
}
