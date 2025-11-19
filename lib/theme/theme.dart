import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    surface: Colors.grey.shade300,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
     surface: const Color.fromARGB(255, 20, 20, 20),
    primary: const Color.fromARGB(255, 105, 105, 105),
    secondary: const Color.fromARGB(255, 30, 30, 30),
    tertiary: const Color.fromARGB(255, 47, 47, 47),
    inversePrimary: Colors.grey.shade300,
  )
);
