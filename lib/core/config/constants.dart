import 'package:flutter/material.dart';

Map<int, Color> primaries = {
  50: Color.fromRGBO(0, 51, 255, .1),
  100: Color.fromRGBO(0, 51, 255, .2),
  200: Color.fromRGBO(0, 51, 255, .3),
  300: Color.fromRGBO(0, 51, 255, .4),
  400: Color.fromRGBO(0, 51, 255, .5),
  500: Color.fromRGBO(0, 51, 255, .6),
  600: Color.fromRGBO(0, 51, 255, .7),
  700: Color.fromRGBO(0, 51, 255, .8),
  800: Color.fromRGBO(0, 51, 255, .9),
  900: Color.fromRGBO(0, 51, 255, 1),
};

var colorPrimary = MaterialColor(0xFF0033FF, primaries);
var colorAccent = MaterialColor(0xFFF1DD55, primaries);
