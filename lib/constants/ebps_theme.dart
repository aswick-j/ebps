import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme myTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 28.00,
      fontWeight: FontWeight.w600,
      color: AppColors.CLR_PRIMARY),
  displayMedium: TextStyle(
      fontSize: 28.00,
      fontWeight: FontWeight.w500,
      color: AppColors.CLR_PRIMARY),
  displaySmall: TextStyle(
      fontSize: 20.00, fontWeight: FontWeight.w400, color: Colors.white),
  bodyLarge: TextStyle(
      fontSize: 18.00,
      fontWeight: FontWeight.w600,
      color: AppColors.CLR_PRIMARY),
  bodyMedium: TextStyle(
      fontSize: 18.00,
      fontWeight: FontWeight.w400,
      color: AppColors.CLR_PRIMARY),
  bodySmall: TextStyle(
      fontSize: 16.00,
      fontWeight: FontWeight.w400,
      color: AppColors.CLR_PRIMARY),
);

ThemeData ebpsTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: AppColors.CLR_BACKGROUND,
    unselectedWidgetColor: AppColors.TXT_CLR_GREY,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      color: AppColors.CLR_BACKGROUND, //<-- SEE HERE
    ),
    textTheme: myTextTheme);

ThemeData DarkTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: AppColors.CLR_BACKGROUND,
    unselectedWidgetColor: AppColors.TXT_CLR_GREY,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      color: AppColors.CLR_BACKGROUND, //<-- SEE HERE
    ),
    textTheme: myTextTheme);
