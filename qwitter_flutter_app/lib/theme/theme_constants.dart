import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor blackColor = MaterialColor(
    0x000000, // 0% comes in  here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0x00000000), //10%
      100: Color(0x00000000), //20%
      200: Color(0x00000000), //30%
      300: Color(0x00000000), //40%
      400: Color(0x00000000), //50%
      500: Color(0x00000000), //60%
      600: Color(0x00000000), //70%
      700: Color(0x00000000), //80%
      800: Color(0x00000000), //90%
      900: Color(0x00000000), //100%
    },
  );
}

const mainColor = Color.fromRGBO(29, 155, 240, 1.0);
const titleColor = Color.fromRGBO(119, 119, 119, 1.0);
const black = Colors.black;
const white = Colors.white;

const TextTheme _baseTextTheme = TextTheme(
  labelLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: titleColor,
  ),
  bodySmall: TextStyle(
    color: titleColor,
  ),
);

ThemeData _buildThemeData(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primarySwatch: Palette.blackColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Palette.blackColor,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: brightness == Brightness.light ? white : black,
    appBarTheme: AppBarTheme(
      color: brightness == Brightness.light ? white : black,
      elevation: 0.5,
      shadowColor: Colors.grey[700],
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: brightness == Brightness.light ? white : black,
      elevation: 0.5,
      shadowColor: Colors.grey[700],
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: white,
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.blue, // Set your desired cursor color
    ),
    useMaterial3: true,
    primaryColor: mainColor,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: mainColor),
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

ThemeData lightTheme = _buildThemeData(Brightness.light);
ThemeData darkTheme = _buildThemeData(Brightness.dark);
