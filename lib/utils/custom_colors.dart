import 'package:flutter/material.dart';

class CustomColor {
  static const Map<int, Color> customGreen = {
    50:Color.fromRGBO(76, 175,82, .1),
    100: Color.fromRGBO(76, 175,82, .2),
    200: Color.fromRGBO(76, 175,82, .3),
    300: Color.fromRGBO(76, 175,82, .4),
    400: Color.fromRGBO(76, 175,82, .5),
    500: Color.fromRGBO(76, 175,82, .6),
    600: Color.fromRGBO(76, 175,82, .7),
    700: Color.fromRGBO(76, 175,82, .8),
    800: Color.fromRGBO(76, 175,82, .9),
    900: Color.fromRGBO(76, 175,82, 1),
  };
  static const MaterialColor customGreenMaterial = MaterialColor(0xff4caf52, customGreen);
}
