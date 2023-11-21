import 'package:flutter/material.dart';

MyAppButton({
  required final VoidCallback onPressed,
  final String? buttonText,
  final Color? buttonTextColor,
  final Color? buttonBorderColor,
  final Color? buttonColor,
  final double? buttonTextSize,
  final double? buttonSizeX,
  final double? buttonSizeY,
  buttonTextWeight,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(
        side: BorderSide(
          width: 1.5,
          color: buttonBorderColor ?? Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      backgroundColor: buttonColor,
      minimumSize: Size(buttonSizeX ?? 10, buttonSizeY ?? 27),
    ),
    child: Text(
      buttonText!,
      style: TextStyle(
        fontSize: buttonTextSize ?? 10,
        fontWeight: buttonTextWeight ?? FontWeight.w500,
        color: buttonTextColor,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
