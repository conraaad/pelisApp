//classe que ens serveix per tenir els temes més modulars

import 'package:flutter/material.dart';

abstract class AppTheme {
  static const Color mainColor = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: mainColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      elevation: 0,
      centerTitle: true,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: mainColor)
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainColor,
      elevation: 5,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        shape: const StadiumBorder(),
        elevation: 5,
      )
    ),

    /*
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: mainColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
        borderSide: BorderSide(color: mainColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
        borderSide: BorderSide(color: mainColor),
      )
    ),

    */
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: mainColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      elevation: 0,
      centerTitle: true,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: mainColor)
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainColor,
      elevation: 5,
    )
  );
}