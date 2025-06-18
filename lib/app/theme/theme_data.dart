import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      useMaterial3: false,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,


      primarySwatch: Colors.blue,


      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.grey[200],


      fontFamily: 'OpenSansRegular',


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSansRegular',
          ),
          backgroundColor: isDarkMode
              ? Colors.deepOrangeAccent[200]
              : Colors.orangeAccent[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(15),
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(fontSize: 16),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode
                ? Colors.deepOrangeAccent
                : Colors.orangeAccent,
          ),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDarkMode
            ? Colors.deepOrangeAccent[200]
            : Colors.orangeAccent[200],
      ),


      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        selectedItemColor: isDarkMode
            ? Colors.orangeAccent[100]
            : Colors.orangeAccent,
        unselectedItemColor:
        isDarkMode ? Colors.grey[400] : Colors.black54,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
      ),
    );
  }
}
