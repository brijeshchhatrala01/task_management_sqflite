import 'package:flutter/material.dart';
import 'package:task_management/theme/colors.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: appPrimaryColor),
  appBarTheme: AppBarTheme(backgroundColor: appPrimaryColor, elevation: 0),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      shape: BeveledRectangleBorder(
          side: BorderSide(
            color: blackColor,
            width: 0.1,
          ),
          borderRadius: BorderRadius.circular(12.00))),
);

TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  color: blackColor,
  letterSpacing: 2,
);

SizedBox smallSizedBox = const SizedBox(
  height: 12,
);

SizedBox smallWidth = const SizedBox(
  width: 6,
);
TextStyle mediumText = TextStyle(
  fontSize: 16,
  color: blackColor,
);

TextStyle errorTextStyle = TextStyle(
  color: errorColor,
);
