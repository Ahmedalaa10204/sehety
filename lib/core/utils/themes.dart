import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: AppColors.white,
    snackBarTheme: const SnackBarThemeData(backgroundColor: AppColors.redColor),
    scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(AppColors.color1),
        trackColor: WidgetStatePropertyAll(AppColors.color2),
        trackVisibility: WidgetStatePropertyAll(true),
        radius: Radius.circular(20)),
    appBarTheme: AppBarTheme(
        titleTextStyle:
            getTitleStyle(color: AppColors.white).copyWith(fontFamily: 'Cairo'),
        centerTitle: true,
        elevation: 0.0,
        actionsIconTheme: const IconThemeData(color: AppColors.color1),
        backgroundColor: AppColors.color1),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      filled: true,
      suffixIconColor: AppColors.color1,
      prefixIconColor: AppColors.color1,
      fillColor: AppColors.accentColor,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.black,
      indent: 10,
      endIndent: 10,
    ),
  );
}