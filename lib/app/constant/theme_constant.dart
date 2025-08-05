import 'package:flutter/material.dart';

class ThemeConstant {
  ThemeConstant._(); // private constructor

  // Primary Colors
  static const Color primaryColor = Color(0xFFFFB74D); // orangeAccent[200]
  static const Color darkPrimaryColor = Color(0xFFFF8A65); // deepOrangeAccent[200]

  // AppBar Colors
  static const Color appBarLightColor = Colors.blue;
  static const Color appBarDarkColor = Color(0xFF212121); // grey[900]

  // Scaffold Colors
  static const Color scaffoldLight = Color(0xFFEEEEEE); // grey[200]
  static const Color scaffoldDark = Colors.black;

  // Navigation Colors
  static const Color navSelectedLight = Colors.orangeAccent;
  static const Color navSelectedDark = Color(0xFFFFCC80); // orangeAccent[100]
  static const Color navUnselectedLight = Colors.black54;
  static const Color navUnselectedDark = Color(0xFFBDBDBD); // grey[400]

  // Common Radius
  static const double defaultRadius = 5.0;

  // Font
  static const String fontFamily = 'OpenSansRegular';
}
