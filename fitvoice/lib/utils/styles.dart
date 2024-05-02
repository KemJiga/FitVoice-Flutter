import 'package:flutter/material.dart';

class Estilos {
  //static const color1 = Color.fromRGBO(46, 209, 46, 1);
  //static const color2 = Color.fromRGBO(255, 169, 53, 1);
  static const color1 = Color.fromRGBO(0, 193, 162, 1);
  static const color2 = Color.fromRGBO(232, 210, 174, 1);
  static const color3 = Color.fromRGBO(215, 178, 157, 1);
  static const color4 = Color.fromRGBO(203, 133, 137, 1);
  static const color5 = Color.fromRGBO(121, 100, 101, 1);
  static const fontFamily = 'BrandonGrotesque';

  static TextStyle textStyle1(double size, Color color, String type) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: type == 'bold' ? FontWeight.bold : FontWeight.normal,
    );
  }
}
