import 'package:blog_application/core/theme/app_pallate.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: color, width: 3));

  static final darkModeTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      appBarTheme:
          const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
      chipTheme: const ChipThemeData(
        side: BorderSide.none,
        color: MaterialStatePropertyAll(AppPallete.backgroundColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: _border(),
          focusedBorder: _border(AppPallete.gradient1)));
}
