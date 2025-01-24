import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 255, 251, 251),
      onPrimary: Color.fromARGB(255, 0, 0, 0),
      secondary: Color.fromARGB(255, 231, 41, 47),
      onSecondary: Color.fromARGB(255, 0, 0, 0),
      tertiary: Color.fromARGB(255, 255, 185, 89),
      surface: Color.fromARGB(255, 255, 255, 255),
      error: Colors.redAccent,
      onError: Colors.black,
      onSurface: Color.fromARGB(255, 7, 7, 7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 12, 12, 12),
      onPrimary: Color.fromARGB(255, 14, 14, 14),
      secondary: Color.fromARGB(255, 227, 62, 67),
      onSecondary: Color.fromARGB(255, 5, 5, 5),
      tertiary: Color.fromARGB(255, 168, 144, 65),
      surface: Color.fromARGB(255, 17, 17, 17),
      error: Colors.redAccent,
      onError: Colors.black,
      onSurface: Color.fromARGB(255, 12, 12, 12),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
