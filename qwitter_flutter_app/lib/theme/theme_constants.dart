import 'package:flutter/material.dart';

const main_color = Color.fromRGBO(29, 155, 240, 1.0);
const title_color = Color.fromRGBO(119, 119, 119, 1.0);
const black = Colors.black;
const white = Colors.white;

const TextTheme _baseTextTheme = TextTheme(
  labelLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: title_color,
  ),
  bodySmall: TextStyle(
    color: title_color,
  ),
);

ThemeData _buildThemeData(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: brightness == Brightness.light ? white : black,
    appBarTheme: AppBarTheme(
      color: brightness == Brightness.light ? white : black,
      elevation: 1.1,
      shadowColor: title_color,
    ),
    primaryColor: main_color,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: main_color),
    fontFamily: "Roboto",
    textTheme: _baseTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              brightness == Brightness.light ? black : white),
          foregroundColor: MaterialStateProperty.all<Color>(
              brightness == Brightness.light ? white : black),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          textStyle:
              MaterialStateProperty.all<TextStyle>(_baseTextTheme.labelLarge!)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: brightness == Brightness.light ? black : white),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
                brightness == Brightness.light ? black : white),
            textStyle: MaterialStateProperty.all<TextStyle>(
                _baseTextTheme.labelLarge!))),
  );
}

ThemeData light_theme = _buildThemeData(Brightness.light);
ThemeData dark_theme = _buildThemeData(Brightness.dark);
